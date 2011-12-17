unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualRedirector, ComCtrls, RichEdit, ExtCtrls,
  MPCommonObjects;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    RichEdit1: TRichEdit;
    Button1: TButton;
    Label1: TLabel;
    VirtualCommandLineRedirector1: TVirtualCommandLineRedirector;
    procedure Button1Click(Sender: TObject);
    procedure RichEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VirtualCommandLineRedirector1ChildProcessEnd(
      Sender: TObject);
    procedure VirtualCommandLineRedirector1ErrorInput(Sender: TObject;
      NewInput: AnsiString);
    procedure VirtualCommandLineRedirector1Input(Sender: TObject;
      NewInput: AnsiString);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    Data: string;
    NewCommand: Boolean;
end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Path: string;
begin
  SetLength(Path, MAX_PATH);
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    GetSystemDirectory(PChar(Path), MAX_PATH)
  else
    GetWindowsDirectory(PChar(Path), MAX_PATH);
  SetLength(Path, StrLen(PChar(Path)));
  Path := ExcludeTrailingBackslash(Path);
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Path := Path + '\cmd.exe'
  else
    Path := Path + '\COMMAND.COM';
  VirtualCommandLineRedirector1.Run(Path, ExtractFileDrive(Path) + '\');
end;

procedure TForm1.RichEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Command: string;
  CharRange: TCharRange;
  Buffer: string;
begin
  if Key = VK_RETURN then
  begin
    SendMessage(RichEdit1.Handle, WM_SETREDRAW, 0, 0);
    try
      // Select any new data past the Data string we have stored
      CharRange.cpMin := Length(Data);
      CharRange.cpMax := SendMessage(RichEdit1.Handle, WM_GETTEXTLENGTH, 0, 0);
      SendMessage(RichEdit1.Handle, EM_EXSETSEL, 0, LPARAM(@CharRange));

      // Copy the selected text to the bufffer
      SetLength(Buffer, CharRange.cpMax - CharRange.cpMin); // The null is automaticlly added
      FillChar(PChar(@Buffer[1])^, Length(Buffer), #0);
      SendMessage(RichEdit1.Handle, EM_GETSELTEXT, 0, LPARAM(@Buffer[1]));

      // Unselect the copied string
      CharRange.cpMin := SendMessage(RichEdit1.Handle, WM_GETTEXTLENGTH, 0, 0);
      CharRange.cpMax := CharRange.cpMin;
      SendMessage(RichEdit1.Handle, EM_EXSETSEL, 0, LPARAM(@CharRange));

      NewCommand := True;
      VirtualCommandLineRedirector1.Write(Buffer);
    finally
      SendMessage(RichEdit1.Handle, WM_SETREDRAW, 1, 0);
    end;
    Command := Buffer;
    Key := 0;
  end;
end;

procedure TForm1.VirtualCommandLineRedirector1ChildProcessEnd(
  Sender: TObject);
begin
  beep;
end;

procedure TForm1.VirtualCommandLineRedirector1ErrorInput(Sender: TObject;
  NewInput: AnsiString);
begin
  beep;
end;

procedure TForm1.VirtualCommandLineRedirector1Input(Sender: TObject;
  NewInput: AnsiString);
var
  s: string;
  CharRange: TCharRange;
  OldScrollPos: Integer;
  Index: Integer;
begin
  if NewInput <> '' then
  begin
    s := NewInput;
    // A new Command was issued
    if NewCommand then
    begin
      // The Command Shell sends a mystery #10 before the data for some reason
      // we need to strip it off
      Index := 1;
      while (Index < Length(s)) and ((s[Index] = #10) or (s[Index] = #13)) do
      begin
        s[Index] := ' ';
        Inc(Index);
      end;
      if Index > 1 then
      begin
        // If we found a line feed or carrage return then slide the rest of the
        // characters down and shorten the string. This should not cause a new
        // string to be allocated so it is very efficient
        MoveMemory(PChar(@s[1]), PChar(@s[Index]), Length(s) - (Index - 1));
        SetLength(s, Length(s) - (Index - 1))
      end
    end;
    Data := Data + VirtualCommandLineRedirector1.FormatData(PChar(s));
    RichEdit1.SetFocus;
    OldScrollPos := GetScrollPos(RichEdit1.Handle, SB_VERT);
    SendMessage(RichEdit1.Handle, WM_SETREDRAW, 0, 0);
    SendMessage(RichEdit1.Handle, WM_SETTEXT, 0, LPARAM(PChar(Data)));
    SendMessage(RichEdit1.Handle, WM_VSCROLL, WPARAM(MakeLong(SB_THUMBPOSITION, OldScrollPos)), 0);
    SendMessage(RichEdit1.Handle, WM_SETREDRAW, 1, 0);
    InvalidateRect(RichEdit1.Handle, nil, False);
    UpdateWindow(RichEdit1.Handle);
    CharRange.cpMin := Length(Data);
    CharRange.cpMax := Length(Data);
    SendMessage(RichEdit1.Handle, EM_EXSETSEL, 0, LPARAM(@CharRange));
    SendMessage(RichEdit1.Handle, EM_SCROLLCARET, 0, 0);

    // Scroll down until we stop scrolling
    // In XP and Win2k the EM_SCROLLCARET does not do anything!
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      while LoWord(SendMessage(RichEdit1.Handle, EM_SCROLL, SB_LINEDOWN, 0)) > 0 do
  end;
  NewCommand := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // NOTE:  Calling Kill forces the Process to die using TerminateProcess.
  //        In Win9x this usually leaves the 16 bit wrapper "WinOldApp" running
  //        in the task list.  If this process is orphaned Win9x will not shut
  //        down.  It is best to use the correct input to the child process to
  //        cause it to terminate itself
  //
  VirtualCommandLineRedirector1.Kill;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not VirtualCommandLineRedirector1.Running;
  if not CanClose then
  begin
    ShowMessage('Please type "Exit" at the command line to exit shell');
  end
end;

end.

unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI, Messages;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    OKButton: TButton;
    Label2: TLabel;
    Timer1: TTimer;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Label3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.Timer1Timer(Sender: TObject);

  function CheckURL(ALabel: TLabel): Boolean;
  begin
    if PtInRect(ALabel.ClientRect, ALabel.ScreenToClient(Mouse.CursorPos)) then
    begin
      Screen.Cursor := crHandPoint;
      ALabel.Font.Color := clBlue;
      ALabel.Font.Style := ALabel.Font.Style + [fsBold];
      Result := True;
    end else
    begin
      ALabel.Font.Color := clBlack;
      ALabel.Font.Style := ALabel.Font.Style - [fsBold];
      Result := False;
    end
  end;

begin
  {$B+}
  if not (CheckURL(Label3) or CheckURL(Label4) or CheckURL(Label5) or CheckURL(Label1) or CheckURL(Label7)) then
  begin
    Screen.Cursor := crDefault;
  end;
   {$B-} 
end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
  ProgramIcon.Picture.LoadFromFile('VST Logo 1.bmp');
end;

procedure TAboutBox.FormHide(Sender: TObject);
begin
  Timer1.Enabled := False;
  ProgramIcon.Picture.Bitmap.ReleaseHandle;
end;

procedure TAboutBox.Label3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShellExecute(Handle, 'open', 'http://Borland.com', '', '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Label4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShellExecute(Handle, 'open', 'http://www.lischke-online.de/VirtualTreeview.html', '', '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Label5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShellExecute(Handle, 'open', 'http://groups.yahoo.com/group/VirtualExplorerTree/', '', '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Label1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShellExecute(Handle, 'open', 'http://www.delphi-gems.com/ThemeManager.html', '', '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Label7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShellExecute(Handle, 'open', 'mailto: jimdk@mindspring.com', '', '', SW_SHOWNORMAL);
end;

end.


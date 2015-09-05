unit VirtualRedirector;

// Version 2.4.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------

interface

{$include ..\Include\AddIns.inc}

uses
  Windows, Messages, Classes, MPShellTypes,
  MPCommonUtilities,
  MPThreadManager;


resourcestring
  STR_CREATE_PIPE_ERROR = 'Unable to Create Pipe';
  STR_ERRORREADINGERRORPIPE = 'Error reading from pipe';
  STR_ERRORWRITINGINPIPE = 'Error writing to the pipe';
  STR_SHELLPROCESSTERMINATEERROR = 'Unable to Terminate Process';
  STR_SHELLPROCESSCREATEERROR = 'Unable to Create Process';
  STR_INVALIDAPPLICATIONFILE = 'Unable to locate the application: ';
  STR_CHILDPROCESSNOTRUNNING = 'Child process not running';
  STR_XCOPYRUNERROR = 'XCopy must be run as a separate redirected process';

const
  WM_NEWINPUT = WM_APP + 111;
  WM_ERRORINPUT = WM_APP + 112;
  WM_CHILDPROCESSCLOSE = WM_APP + 113;

  LineFeed =  #10#13;

type
  TRedirectorInputEvent = procedure(Sender: TObject; NewInput: AnsiString) of object;
  TRedirectorChildProcessEndEvent = procedure(Sender: TObject) of object;

  TPipeThread = class(TCommonThread)
  private
    FPipeIn: THandle;
    FPipeErrorIn: THandle;
  protected
    procedure Execute; override;

    property PipeIn: THandle read FPipeIn write FPipeIn;
    property PipeErrorIn: THandle read FPipeErrorIn write FPipeErrorIn;
  public
    procedure Terminate; override;
  end;

  TProcessTerminateThread = class(TCommonThread)
  private
    FChildProcess: THandle;
  protected
     procedure Execute; override;

     property ChildProcess: THandle read FChildProcess write FChildProcess;
  end;

  TCustomVirtualRedirector = class(TComponent)
  private
    FRunning: Boolean;
    FPipeIn: THandle;     // With respect to this process, Pipe input from child process
    FPipeOut: THandle;    // With respect to this process, Pipe output to child process
    FPipeErrorIn: THandle; // With respect to this process, Pipe input from child process
    FProcessInfo: TProcessInformation;
    FOnInput: TRedirectorInputEvent;
    FOnErrorInput: TRedirectorInputEvent;
    FOnChildProcessEnd: TRedirectorChildProcessEndEvent;
    FHelperWnd: HWnd;
    FPipeThread: TPipeThread;
    FProcessTerminateThread: TProcessTerminateThread;
    function GetChildProcessHandle: THandle;
    function GetChildProcessThread: THandle;
    function GetChildProcessID: Longword;
    function GetChildThreadID: Longword;
  protected
    procedure CloseAndZeroHandle(var Handle: THandle);
    procedure CloseHandles;
    procedure DoErrorInput(NewErrorInput: AnsiString); virtual;
    procedure DoInput(NewInput: AnsiString); virtual;
    procedure DoChildProcessEnd; virtual;
    procedure HelperWndProc(var Message: TMessage);
    procedure KillThreads;

    property HelperWnd: HWnd read FHelperWnd write FHelperWnd;
    property OnErrorInput: TRedirectorInputEvent read FOnErrorInput write FOnErrorInput;
    property OnInput: TRedirectorInputEvent read FOnInput write FOnInput;
    property OnChildProcessEnd: TRedirectorChildProcessEndEvent read FOnChildProcessEnd write FOnChildProcessEnd;
    property PipeOut: THandle read FPipeOut write FPipeOut;
    property PipeIn: THandle read FPipeIn write FPipeIn;
    property PipeErrorIn: THandle read FPipeErrorIn write FPipeErrorIn;
    property PipeThread: TPipeThread read FPipeThread write FPipeThread;
    property ProcessTerminateThread: TProcessTerminateThread read FProcessTerminateThread write FProcessTerminateThread;
    property ProcessInfo: TProcessInformation read FProcessInfo write FProcessInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Run(FileName, InitialDirectory: WideString; Parameters: WideString = ''): Boolean;
    procedure Kill;
    procedure Write(Command: AnsiString); virtual;

    property ChildProcessHandle: THandle read GetChildProcessHandle;
    property ChildProcessID: Longword read GetChildProcessID;
    property ChildProcessThread: THandle read GetChildProcessThread;
    property ChildThreadID: Longword read GetChildThreadID;
    property Running: Boolean read FRunning;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualRedirector = class(TCustomVirtualRedirector)
  published
    property OnErrorInput;
    property OnInput;
    property OnChildProcessEnd;
  end;

  // ******************
  TRedirectorChangeDir = procedure(Sender: TObject; NewDir: WideString; var Allow: Boolean) of object;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualCommandLineRedirector = class(TCustomVirtualRedirector)
  private
    FCurrentDir: AnsiString;
    FOnDirChange: TRedirectorChangeDir;
    procedure SetCurrentDir(const Value: AnsiString);
  protected
    procedure DoChangeDir(NewDir: WideString; var Allow: Boolean); virtual;
  public
    procedure CarrageReturn;
    procedure ChangeDir(NewDir: AnsiString);
    function FormatData(Data: AnsiString): AnsiString;
    procedure Write(Command: AnsiString); override;
    procedure WriteUni(const Command: string);
    property CurrentDir: AnsiString read FCurrentDir write SetCurrentDir;
  published
    property OnChildProcessEnd;
    property OnDirChange: TRedirectorChangeDir read FOnDirChange write FOnDirChange;
    property OnErrorInput;
    property OnInput;
  end;

implementation

uses
  SysUtils, AnsiStrings;

{ TCustomVirtualRedirector }

procedure TCustomVirtualRedirector.CloseAndZeroHandle(var Handle: THandle);
begin
  if Handle <> 0 then
  try
    CloseHandle(Handle);
  finally
    Handle := 0;
  end
end;

procedure TCustomVirtualRedirector.CloseHandles;
begin
  CloseAndZeroHandle(FPipeIn);
  CloseAndZeroHandle(FPipeErrorIn);
  CloseAndZeroHandle(FPipeOut);
end;

constructor TCustomVirtualRedirector.Create(AOwner: TComponent);
begin
  inherited;
  HelperWnd :=Classes.AllocateHWnd(HelperWndProc);
end;

destructor TCustomVirtualRedirector.Destroy;
begin
  if Running then
  begin
    Kill;
    KillThreads;
  end;
  Classes.DeAllocateHWnd(HelperWnd);
  inherited;
end;

procedure TCustomVirtualRedirector.DoChildProcessEnd;
begin
  if Assigned(FOnChildProcessEnd) then
    OnChildProcessEnd(Self)
end;

procedure TCustomVirtualRedirector.DoErrorInput(NewErrorInput: AnsiString);
begin
  if Assigned(FOnErrorInput) then
    FOnErrorInput(Self, NewErrorInput)
end;

procedure TCustomVirtualRedirector.DoInput(NewInput: AnsiString);
begin
  if Assigned(FOnInput) then
    FOnInput(Self, NewInput)
end;

function TCustomVirtualRedirector.GetChildProcessHandle: THandle;
begin
  Result := FProcessInfo.hProcess
end;

function TCustomVirtualRedirector.GetChildProcessID: Longword;
begin
  Result := FProcessInfo.dwProcessId
end;

function TCustomVirtualRedirector.GetChildProcessThread: THandle;
begin
  Result := FProcessInfo.hThread
end;

function TCustomVirtualRedirector.GetChildThreadID: Longword;
begin
  Result := FProcessInfo.dwThreadId
end;

procedure TCustomVirtualRedirector.HelperWndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_NCCREATE:
      Message.Result := 1;
    WM_NEWINPUT:
      begin
        DoInput(PAnsiChar(Message.wParam));
        FreeMem(PAnsiChar(Message.wParam))
      end;
    WM_ERRORINPUT:
      begin
        DoErrorInput(PAnsiChar(Message.wParam));
        FreeMem(PAnsiChar(Message.wParam))
      end;
    WM_CHILDPROCESSCLOSE:
      begin
        ZeroMemory(@FProcessInfo, SizeOf(ProcessInfo));
        KillThreads;
        CloseHandles;
        FRunning := False;
        DoChildProcessEnd;
      end;
  else
    with Message do
      Result := DefWindowProc(HelperWnd, Msg, wParam, lParam);
  end
end;

procedure TCustomVirtualRedirector.Kill;
begin
  // NOTE:  Calling Kill forces the Process to die using TerminateProcess.
  //        In Win9x this usually leaves the 16 bit wrapper "WinOldApp" running
  //        in the task list.  If this process is orphaned Win9x will not shut
  //        down.  It is best to use the correct input to the child process to
  //        cause it to terminate itself
  if Running and (FProcessInfo.hProcess <> 0) then
    TerminateProcess(FProcessInfo.hProcess, 0);
end;

procedure TCustomVirtualRedirector.KillThreads;
begin
  if Assigned(PipeThread) then
    if not PipeThread.Terminated then
    begin
      PipeThread.Terminate;
      while not PipeThread.Finished do
        Sleep(100);
      PipeThread.Free;
      PipeThread := nil;
    end;

  if Assigned(ProcessTerminateThread) then
  begin
    if not ProcessTerminateThread.Finished then
    begin
      ProcessTerminateThread.TriggerEvent;
      while not ProcessTerminateThread.Finished do
        Sleep(100);
    end;
      ProcessTerminateThread.Free;
      ProcessTerminateThread := nil;
  end
end;

function TCustomVirtualRedirector.Run(FileName, InitialDirectory: WideString; Parameters: WideString = ''): Boolean;
var
  StartupInfoA: _STARTUPINFOA;
  StartupInfoW: _STARTUPINFOW;
  szDirectoryA: PAnsiChar;
  szDirectoryW: PWideChar;
  SecAttr: TSecurityAttributes;
  PipeChildIn, PipeChildOut, PipeChildErrorOut: THandle;
  FileNameA, InitialDirectoryA, ParametersA: AnsiString;
  TempWideCharFile, TempWideCharParams: PWideChar;
  TempCharFile, TempCharParams: PAnsiChar;
begin
  Result := False;
  if not Running then
  begin
    if FileExistsW(FileName) then
    begin
      PipeChildIn := 0;
      PipeChildOut := 0;
      try
        ZeroMemory(@StartupInfoW, SizeOf(StartupInfoW));
        ZeroMemory(@StartupInfoA, SizeOf(StartupInfoA));
        StartupInfoW.cb := SizeOf(StartupInfoW);
        StartupInfoA.cb := SizeOf(StartupInfoA);

        ZeroMemory(@FProcessInfo, SizeOf(FProcessInfo));

        StartupInfoW.wShowWindow := SW_HIDE;    // Don't show the service on the screen

        // Create the Pipe handes as inheritable so we can give them to the
        // child process and we can close them
        SecAttr.nLength := SizeOf(SecAttr);
        SecAttr.lpSecurityDescriptor := nil;
        SecAttr.bInheritHandle := True;

        // Create output Pipe to the Child Process
        if not CreatePipe(PipeChildIn, FPipeOut, @SecAttr, 0) then
          raise Exception.Create(STR_CREATE_PIPE_ERROR);

        // Create the input Pipe from the Child Process
        if not CreatePipe(FPipeIn, PipeChildOut, @SecAttr, 0) then
          raise Exception.Create(STR_CREATE_PIPE_ERROR);

        // Create the input Error Pipe from the Child Process
        if not CreatePipe(FPipeErrorIn, PipeChildErrorOut, @SecAttr, 0) then
          raise Exception.Create(STR_CREATE_PIPE_ERROR);


        StartupInfoW.hStdOutput := PipeChildOut;
        StartupInfoW.hStdInput := PipeChildIn;
        StartupInfoW.hStdError := PipeChildErrorOut;
        StartupInfoW.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;

        if Assigned(CreateProcessW_MP) then
        begin
          if InitialDirectory = '' then
            szDirectoryW := nil
          else
            szDirectoryW := PWideChar( InitialDirectory);

          // Sending a nil is NOT equal to sending PWideChar(FileName) if FileName = '';
          if FileName = '' then
            TempWideCharFile := nil
          else
            TempWideCharFile := PWideChar( FileName);

          if Parameters = '' then
            TempWideCharParams := nil
          else
            TempWideCharParams := PWideChar( Parameters);

          // Note that fInheritHandles must be true so the process is just
          // increasing the reference count to the passed handles.  That mean we
          // must close them here to release our count on them.
          if not CreateProcessW_MP(TempWideCharFile, TempWideCharParams, nil, nil, True, 0,
            nil, szDirectoryW, StartupInfoW, FProcessInfo)
          then
            raise Exception.Create(STR_SHELLPROCESSCREATEERROR);
        end else
        begin
          StartupInfoA.hStdInput := StartupInfoW.hStdInput;
          StartupInfoA.hStdOutput := StartupInfoW.hStdOutput;
          StartupInfoA.hStdError := StartupInfoW.hStdError;
          StartupInfoA.wShowWindow := StartupInfoW.wShowWindow;
          StartupInfoA.dwFlags := StartupInfoW.dwFlags;

          InitialDirectoryA := AnsiString(InitialDirectory);
          ParametersA := AnsiString(Parameters);
          FileNameA := AnsiString(FileName);

          if InitialDirectoryA = '' then
            szDirectoryA := nil
          else
            szDirectoryA := PAnsiChar(InitialDirectoryA);

          // Sending a nil is NOT equal to sending PWideChar(FileName) if FileName = '';
          if FileNameA = '' then
            TempCharFile := nil
          else
            TempCharFile := PAnsiChar( FileNameA);

          if ParametersA = '' then
            TempCharParams := nil
          else
            TempCharParams := PAnsiChar( ParametersA);

          // Note that fInheritHandles must be true so the process is just
          // increasing the reference count to the passed handles.  That mean we
          // must close them here to release our count on them.
          if not CreateProcessA(TempCharFile, TempCharParams, nil, nil, True, 0,
            nil, szDirectoryA, StartupInfoA, FProcessInfo)
          then
            raise Exception.Create(STR_SHELLPROCESSCREATEERROR);
        end;

        // We can now close our references to the ends of the pipe the child owns
        CloseAndZeroHandle(PipeChildIn);
        CloseAndZeroHandle(PipeChildOut);
        CloseAndZeroHandle(PipeChildErrorOut);

        PipeThread := TPipeThread.Create(True);
        PipeThread.PipeIn := PipeIn;
        PipeThread.PipeErrorIn := PipeErrorIn;
        PipeThread.TargetWnd := HelperWnd;
        PipeThread.Resume;
        ProcessTerminateThread := TProcessTerminateThread.Create(True);
        ProcessTerminateThread.TargetWnd := HelperWnd;
        ProcessTerminateThread.ChildProcess := ChildProcessHandle;
        ProcessTerminateThread.Resume;

        FRunning := True
      except
        CloseHandles;
        CloseAndZeroHandle(PipeChildOut);
        CloseAndZeroHandle(PipeChildIn);
        CloseAndZeroHandle(PipeChildErrorOut);
      end
    end else
      raise Exception.Create(STR_INVALIDAPPLICATIONFILE + FileName);
  end
end;

procedure TCustomVirtualRedirector.Write(Command: AnsiString);
var
  BytesWritten, BytesToWrite: Cardinal;
begin
  if Running then
  begin
    if Length(Command) > 1 then
    begin
      if (Command[Length(Command)-1] <> #10) and (Command[Length(Command)] <> #13) then
        Command := Command + LineFeed
    end;
    BytesToWrite := Length(Command);
    WriteFile(PipeOut, PAnsiChar(Command)^, BytesToWrite, BytesWritten, nil);
    if BytesWritten <> BytesToWrite then
      raise Exception.Create(STR_ERRORWRITINGINPIPE);
  end
end;

{ TVirtualCommandLineRedirector }

procedure TVirtualCommandLineRedirector.CarrageReturn;
begin
  Write(LineFeed);
end;

procedure TVirtualCommandLineRedirector.ChangeDir(NewDir: AnsiString);
var
  Allow: Boolean;
begin
  Allow := True;
  DoChangeDir(string(NewDir), Allow);
  if Allow then
  begin
    // Are we on a different drive?
    if WideLowerCase(WideExtractFileDrive(string(FCurrentDir))) <> WideLowerCase(WideExtractFileDrive(string(NewDir))) then
    begin
      // Different drive, change drives first
      WriteUni(WideStripTrailingBackslash(WideExtractFileDrive(string(NewDir)) + ' /d', True));  // Need switch for across network drives
      // If not the root drive then change the directory
      if not WideIsDrive(string(NewDir)) then
        WriteUni('cd ' + ShortFileName(string(NewDir)));
    end else
      WriteUni('cd ' + ShortFileName(string(NewDir)));
    FCurrentDir := NewDir;
  end;
end;

procedure TVirtualCommandLineRedirector.DoChangeDir(NewDir: WideString; var Allow: Boolean);
begin
  if Assigned(FOnDirChange) then
    FOnDirChange(Self, NewDir, Allow)
end;

function TVirtualCommandLineRedirector.FormatData(Data: AnsiString): AnsiString;
begin
  if Data <> '' then
  begin
    // The ANSI convert will be the same size buffer
    OEMToCharA(PAnsiChar( Data), PAnsiChar(Data));
    AnsiStrings.Trim( AnsiString(Data));
    Result := AnsiString(AdjustLineBreaks(string(Data)));
  end else
    Result := ''
end;

procedure TVirtualCommandLineRedirector.SetCurrentDir(const Value: AnsiString);
begin
  ChangeDir(Value)
end;

procedure TVirtualCommandLineRedirector.Write(Command: AnsiString);
begin
  // We need watch for some special commands that we must handle differently
  if AnsiStrings.AnsiPos('xcopy', LowerCase(Command)) > 0 then
  begin
  // xcopy is a separate executable that the command shell will launch.  The
  // redirection doess not work well with child new processes launched from our
  // child process so do it ourselves.
    raise Exception.Create(STR_XCOPYRUNERROR);
  end else
    inherited Write(Command);
end;

procedure TVirtualCommandLineRedirector.WriteUni(const Command: string);
begin
  Write(AnsiString(Command));
end;

{ TProcessTeminateThread }

procedure TProcessTerminateThread.Execute;
var
  Handles: TWOHandleArray;
begin
  try
    try
      Handles[0] := Event;
      Handles[1] := ChildProcess;
      WaitForMultipleObjects(2, @Handles, False, INFINITE)
    finally
      PostMessage(TargetWnd, WM_CHILDPROCESSCLOSE, 0, 0);
    end
  except
    // don't let any exceptions escape the thread
  end
end;

{ TPipeThread }

procedure TPipeThread.Execute;
var
  AvailableBytes, BytesRead: Cardinal;
  Mem: PAnsiChar;
begin
  while not Terminated do
  try
    Sleep(250);
    if PeekNamedPipe(PipeIn, nil, 0, nil, @AvailableBytes, nil) then
    begin
      if PeekNamedPipe(PipeIn, nil, 0, nil, @AvailableBytes, nil) then
      begin
        if AvailableBytes > 0 then
        begin
          Mem := AllocMem(AvailableBytes + 1);
          if ReadFile(PipeIn, Mem^, AvailableBytes, BytesRead, nil) then
            PostMessage(TargetWnd, WM_NEWINPUT, LPARAM(Mem), 0);
        end
      end;
      if PeekNamedPipe(PipeErrorIn, nil, 0, nil, @AvailableBytes, nil) then
      begin
        if AvailableBytes > 0 then
        begin
          Mem := AllocMem(AvailableBytes + 1);
          if ReadFile(PipeErrorIn, Mem^, AvailableBytes, BytesRead, nil) then
            PostMessage(TargetWnd, WM_ERRORINPUT, LPARAM(Mem), 0);
        end
      end
    end
  except
    // don't let any exceptions escape the thread
  end
end;

procedure TPipeThread.Terminate;
begin
  inherited Terminate;
  TriggerEvent;
end;

end.

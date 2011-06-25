unit VirtualCommandLine;

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

{$include Compilers.inc}
{$include ..\Include\AddIns.inc}

{$ifdef COMPILER_12_UP}
  {$WARN IMPLICIT_STRING_CAST       OFF}
 {$WARN IMPLICIT_STRING_CAST_LOSS  OFF}
{$endif COMPILER_12_UP}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ImgList, ShlObj,
  ShellAPI, ActiveX;

type
  TCommandLinePipe = class(TComponent)
  private
   //                  | ------------------------------------------- |
   //                  |  hPipe2WriteDuplicate ----> hPipe2Read      |
   // Current Process  |                                             | Child Process
   //                  |  hPipe1ReadDuplicate <---- hPipe1Write      |
   //                  | ------------------------------------------- |
    FhPipe2Read: THandle;
    FhPipe1Write: THandle;
    FhPipe1ReadDuplicate: THandle;
    FhPipe2WriteDuplicate: THandle;
    FMemStream: TMemoryStream;
  protected
    property hPipe1Write: THandle read FhPipe1Write write FhPipe1Write;
    property hPipe1ReadDuplicate: THandle read FhPipe1ReadDuplicate write FhPipe1ReadDuplicate;
    property hPipe2Read: THandle read FhPipe2Read write FhPipe2Read;
    property hPipe2WriteDuplicate: THandle read FhPipe2WriteDuplicate write FhPipe2WriteDuplicate;
    property MemStream: TMemoryStream read FMemStream write FMemStream;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DOSCommand(Command: AnsiString);
    procedure Initialize;
    procedure ReadFrom(Stream: TMemoryStream);
    function ReadResult: AnsiString;
    procedure SendTo(Stream: TMemoryStream);
  end;

implementation

{ TCommandLinePipe }

constructor TCommandLinePipe.Create(AOwner: TComponent);
begin
  inherited;
  MemStream := TMemoryStream.Create;
end;

destructor TCommandLinePipe.Destroy;
begin
  MemStream.Free;
  inherited;
end;

procedure TCommandLinePipe.Initialize;
var
  hOldSTDOut,        // Handle associated with the Pipe attached to
  hPipe1Read,        // (Current Process ---> Child Process

  hOldSTDIn,         // Handle associated with the Pipe attached to
  hPipe2Write: THandle;

  SecurityAttribs: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
begin
   // The steps for redirecting child process's STDOUT:
   //     1. Save current STDOUT, to be restored later.
   //     2. Create anonymous pipe to be STDOUT for child process.
   //     3. Set STDOUT of the parent process to be write handle to
   //        the pipe, so it is inherited by the child process.
   //     4. Create a noninheritable duplicate of the read handle and
   //        close the inheritable read handle.

   // Set the bInheritHandle flag so pipe handles are inherited.
   SecurityAttribs.nLength := sizeof(SECURITY_ATTRIBUTES);
   SecurityAttribs.bInheritHandle := True;
   SecurityAttribs.lpSecurityDescriptor := Nil;

   // Save the handle to the current STDOUT.
   hOldSTDOut := GetStdHandle(STD_OUTPUT_HANDLE);

   // Create a pipe for the child process's STDOUT.
   // Current Process --- > Child Process
   if not CreatePipe(hPipe1Read, FhPipe1Write, @SecurityAttribs, 0) then
     windows.beep(100, 100);

   // Set a write handle to the pipe to be STDOUT.
   // The current processes STD Output now flows into the Pipe and will write
   // to the child process
   if not SetStdHandle(STD_OUTPUT_HANDLE, hPipe1Write) then
     windows.beep(100, 100);

   // Create noninheritable read handle and close the inheritable read handle.
   // Create a new unique handle output side of the pipe
   if not DuplicateHandle(GetCurrentProcess, hPipe1Read, GetCurrentProcess,
     @hPipe1ReadDuplicate, 0, False, DUPLICATE_SAME_ACCESS)
   then
    windows.beep(100, 100);

   CloseHandle(hPipe1Read);

   // The steps for redirecting child process's STDIN:
   //     1.  Save current STDIN, to be restored later.
   //     2.  Create anonymous pipe to be STDIN for child process.
   //     3.  Set STDIN of the parent to be the read handle to the
   //         pipe, so it is inherited by the child process.
   //     4.  Create a noninheritable duplicate of the write handle,
   //         and close the inheritable write handle.

   // Save the handle to the current STDIN.
   hOldSTDIn := GetStdHandle(STD_INPUT_HANDLE);

   // Create a pipe for the child process's STDOut to this processes StdIn.
   if not CreatePipe(FhPipe2Read, hPipe2Write, @SecurityAttribs, 0) then
     windows.beep(100, 100);

   // The STDIn now reads from the second Pipe
   // Current Process <--- Child Process
   if not SetStdHandle(STD_INPUT_HANDLE, hPipe2Read) then
     windows.beep(100, 100);

   // Duplicate the write handle to the pipe so it is not inherited.
   if not DuplicateHandle(GetCurrentProcess, hPipe2Write, GetCurrentProcess(),
     @hPipe2WriteDuplicate, 0, False, DUPLICATE_SAME_ACCESS)
   then
    windows.beep(100, 100);

   CloseHandle(hPipe2Write);

   // Now the current process's std input and output are attached to the ends
   // of two pipes.  The other ends have had duplicate handles created and the
   // originals closed.  Now we can create the process and attach the other
   // ends of the pipes to the process


   // Create a command line process that inherits handles. That mean it simply
   // uses the same STDIn, STDOut, and STDError handles that we assigned earlier
   // by incrementing the count.
   ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
   StartupInfo.cb := SizeOf(StartupInfo);
   ZeroMemory(@ProcessInformation, SizeOf(ProcessInformation));
   if not CreateProcess('C:\WINNT\system32\cmd.exe', '', nil, nil, True, 0, nil, nil, StartupInfo, ProcessInformation) then
     windows.beep(100, 100);

   // We now replace our original STDIn and STDOut handlers.
   SetStdHandle(STD_OUTPUT_HANDLE, hOldSTDOut);
   SetStdHandle(STD_INPUT_HANDLE, hOldSTDIn);

   // Note what this gets us.  The new process now has
   // hPipeWriteOuput as the STDOut for the new process and
   // hPipeReadInput as the STDIn for the new process while we
   // have the other end of the pipes in hPipeReadOutputDuplicate and
   // hPipeWriteInputDuplicate
   // So we have this:
   //                  | ------------------------------------------- |
   //                  |  hPipe2WriteDuplicate ----> hPipe2Read      |
   // Current Process  |                                             | Child Process
   //                  |  hPipe1ReadDuplicate <---- hPipe1Write      |
   //                  | ------------------------------------------- |
   //


end;

procedure TCommandLinePipe.ReadFrom(Stream: TMemoryStream);
var
  BytesInPipe: DWORD;
begin
  if PeekNamedPipe(hPipe1ReadDuplicate, nil, 0, nil, @BytesInPipe, nil) then
  begin
    Stream.Size := BytesInPipe;
    ReadFile(hPipe1ReadDuplicate, Stream.Memory^, BytesInPipe, BytesInPipe, nil);
  end
end;

function TCommandLinePipe.ReadResult: AnsiString;
begin
  ReadFrom(MemStream);
  SetLength(Result, MemStream.Size);
  Move(PAnsiChar(Result)^, MemStream.Memory^, MemStream.Size);
end;

procedure TCommandLinePipe.DOSCommand(Command: AnsiString);
var
  Written: DWORD;
begin
  if not WriteFile(hPipe2WriteDuplicate, PAnsiChar(Command)^, Length(Command), Written, nil) then
    windows.beep(100, 100);

    Exit;

  MemStream.Size := Length(Command);
  Move(PAnsiChar(Command)^, MemStream.Memory^, Length(Command));
  SendTo(MemStream);
end;

procedure TCommandLinePipe.SendTo(Stream: TMemoryStream);
var
  Written: DWORD;
begin
  if not WriteFile(hPipe2WriteDuplicate, Stream.Memory^, Stream.Size, Written, nil) then
    windows.beep(100, 100);
end;


end.

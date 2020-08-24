unit VirtualFileSearch;

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

{$B+}

{$include ..\Include\AddIns.inc}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Dialogs,
  ActiveX,
  ShlObj,
  MPCommonUtilities,
  MPThreadManager,
  MPShellTypes,
  ExtCtrls,
  MPShellUtilities,
  VirtualResources,
  MPCommonObjects;

type
  TVirtualFileSearch = class;  // Forward

  TVirtualSearchAttrib = (
      vsaArchive,    // File is an archive file
      vsaCompressed, // File is a compressed file
      vsaEncrypted,  // File is a encrypted file
      vsaHidden,     // File is a hidden file
      vsaNormal,     // File is a normal file
      vsaOffline,    // File is an offline file
      vsaReadOnly,   // File is a Read Only file
      vsaSystem,     // File is a system file
      vsaTemporary   // File is a temporary file
    );
    TVirtualSearchAttribs = set of TVirtualSearchAttrib;
  TFileSearchProgressEvent = procedure(Sender: TObject; Results: TCommonPIDLList; var Handled: Boolean; var FreePIDLs: Boolean) of object;
  TFileSearchFinishedEvent = procedure(Sender: TObject; Results: TCommonPIDLList) of object;
   // WARNING CALLED IN CONTEXT OF THREAD
  TFileSearchCompareEvent = procedure(Sender: TObject; const FilePath: string; FindFileData: TWIN32FindDataW; var UseFile: Boolean) of object;
  TVirtualFileSearchThread = class(TCommonThread)
  private
    FCaseSensitive: Boolean;
    FFileMask: DWORD;      // The mask of attributes of a file to use in the search
//    FSearchCriteriaContent: TStringList;
    FSearchCriteriaFileName: TStringList;
    FSearchPaths: TStringList;
    FSearchManager: TVirtualFileSearch;
    FSearchResultsLocal: TCommonPIDLList;
    FTemporary: Boolean;
  protected
    procedure Execute; override;
    procedure ProcessFiles(Path: string; Masks: TStringList; PIDLList: TCommonPIDLList);
    property SearchManager: TVirtualFileSearch read FSearchManager write FSearchManager;
    property SearchResultsLocal: TCommonPIDLList read FSearchResultsLocal write FSearchResultsLocal;
    property Temporary: Boolean read FTemporary write FTemporary;
  public
    constructor Create(CreateSuspended: Boolean); override;
    destructor Destroy; override;
    procedure BuildFolderList(const Path: string; FolderList: TStringList);
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property FileMask: DWORD read FFileMask write FFileMask;
//    property SearchCriteriaContent: TStringList read FSearchCriteriaContent write FSearchCriteriaContent;
    property SearchCriteriaFileName: TStringList read FSearchCriteriaFileName write FSearchCriteriaFileName;
    property SearchPaths: TStringList read FSearchPaths write FSearchPaths;
  end;

  {$IF CompilerVersion >= 23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$IFEND}
  TVirtualFileSearch = class(TComponent)
  private
    FCaseSensitive: Boolean;
    FFileFindThread: TVirtualFileSearchThread;
    FFinished: Boolean;
    FOnProgress: TFileSearchProgressEvent;
    FOnSearchCompare: TFileSearchCompareEvent;  // WARNING CALLED IN CONTEXT OF THREAD
    FOnSearchEnd: TFileSearchFinishedEvent;
    FSearchAttribs: TVirtualSearchAttribs;
//    FSearchCriteriaContent: TStringList;
    FSearchCriteriaFilename: TStringList;
    FSearchPath: TStringList;
    FSearchResults: TCommonPIDLList;
    FSubFolders: Boolean;
{$WARN SYMBOL_PLATFORM OFF}
    FThreadPriority: TThreadPriority;
{$WARN SYMBOL_PLATFORM ON}
    FTimer: TTimer;
    FUpdateRate: Integer;
  protected
    function BuildMask: Integer;
    procedure DoProgress(Results: TCommonPIDLList; var Handled: Boolean; var FreePIDLs: Boolean); virtual;
    procedure DoSearchCompare(const FilePath: string; FindFileData: TWIN32FindDataW; var UseFile: Boolean);
    procedure DoSearchEnd(Results: TCommonPIDLList);
    procedure TimerTick(Sender: TObject);
    property FileFindThread: TVirtualFileSearchThread read FFileFindThread write FFileFindThread;
    property Timer: TTimer read FTimer write FTimer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Run: Boolean; virtual;
    procedure Stop; virtual;
    property Finished: Boolean read FFinished;
//    property SearchCriteriaContent: TStringList read FSearchCriteriaContent write FSearchCriteriaContent;
    property SearchCriteriaFilename: TStringList read FSearchCriteriaFilename write FSearchCriteriaFilename;
    property SearchPaths: TStringList read FSearchPath write FSearchPath;
    property SearchResults: TCommonPIDLList read FSearchResults write FSearchResults;
  published
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive default False;
    property OnProgress: TFileSearchProgressEvent read FOnProgress write FOnProgress;
     // WARNING CALLED IN CONTEXT OF THREAD
    property OnSearchCompare: TFileSearchCompareEvent read FOnSearchCompare write FOnSearchCompare;
    property OnSearchEnd: TFileSearchFinishedEvent read FOnSearchEnd write FOnSearchEnd;
    property SearchAttribs: TVirtualSearchAttribs read FSearchAttribs write FSearchAttribs default [vsaArchive, vsaCompressed, vsaEncrypted, vsaHidden, vsaNormal, vsaOffline, vsaReadOnly, vsaSystem, vsaTemporary];
    property SubFolders: Boolean read FSubFolders write FSubFolders default False;
{$WARN SYMBOL_PLATFORM OFF}
    property ThreadPriority: TThreadPriority read FThreadPriority write FThreadPriority default tpNormal;
{$WARN SYMBOL_PLATFORM ON}
    property UpdateRate: Integer read FUpdateRate write FUpdateRate default 500;
  end;

implementation

{ TVirtualFileSearchThread }
constructor TVirtualFileSearchThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  SearchPaths := TStringList.Create;
  SearchCriteriaFileName := TStringList.Create;
//  SearchCriteriaContent := TStringList.Create;
end;

destructor TVirtualFileSearchThread.Destroy;
begin
  SearchPaths.Free;
  SearchCriteriaFileName.Free;
//  SearchCriteriaContent.Free;
  inherited Destroy;
end;

procedure TVirtualFileSearchThread.BuildFolderList(const Path: string; FolderList: TStringList);
//
// Builds a list of folders that are contained in the Path
//
var
  FindHandle: THandle;
  FindFileDataW: TWIN32FindDataW;
begin
    FindHandle := FindFirstFileW(PWideChar(string( Path + '\*.*')), FindFileDataW);
    if FindHandle <> INVALID_HANDLE_VALUE then
    begin
      repeat
        // Recurse SubFolder if desired, don't get into an endless loop with ReparsePoints
        if not Terminated and ((FFileMask and FILE_ATTRIBUTE_DIRECTORY <> 0) and (FindFileDataW.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) and (FindFileDataW.dwFileAttributes and FILE_ATTRIBUTE_REPARSE_POINT = 0)) then
        begin
          // This is very ugly but it saves from testing filename lengths
          if FindFileDataW.cFileName[0] <> #0 then
          begin
            if FindFileDataW.cFileName[1] = #0 then
            begin
              // One character long name, if '.' then skip it
              if FindFileDataW.cFileName[0] <> '.' then
                FolderList.Add(Path + '\' + FindFileDataW.cFileName)
            end else
            begin
              if FindFileDataW.cFileName[2] = #0 then
              begin
                // Two character long name, if '..' then skip it
                if not ((FindFileDataW.cFileName[0] = '.') and (FindFileDataW.cFileName[1] = '.')) then
                  FolderList.Add(Path + '\' + FindFileDataW.cFileName)
              end else
                FolderList.Add(Path + '\' + FindFileDataW.cFileName)
            end
          end
        end
       until Terminated or not FindNextFileW(FindHandle, FindFileDataW);
      Windows.FindClose(FindHandle);
    end
end;

procedure TVirtualFileSearchThread.Execute;
var
  i: Integer;
  PIDLList: TCommonPIDLList;
begin
  PIDLList := TCommonPIDLList.Create;
  PIDLList.SharePIDLs := True;
  i := 0;
  while not Terminated and (i < SearchPaths.Count) do
  begin
    if DirectoryExists(SearchPaths[i]) then
      ProcessFiles(ExcludeTrailingPathDelimiter( SearchPaths[i]), SearchCriteriaFileName, PIDLList);
    Inc(i)
  end;
  // Clean out the PIDL List
  LockThread;
  try
    for i := 0 to PIDLList.Count - 1 do
      SearchResultsLocal.Add(PIDLList[i]);
    PIDLList.Clear;
  finally
    UnlockThread;
    PIDLList.Free;
  end;
end;

procedure TVirtualFileSearchThread.ProcessFiles(Path: string; Masks: TStringList; PIDLList: TCommonPIDLList);
var
  FindFileDataW: TWIN32FindDataW;
  FolderList: TStringList;
  FindHandle: THandle;
  i, j: Integer;
  UseFile, Done: Boolean;
  PIDL: PItemIDList;
  CurrentPath, CurrentPathSpec: string;
  IsDotPath, IsDotDotPath: Boolean;
begin
  i := 0;
  FolderList := TStringList.Create;
  try
    while not Terminated and (i < Masks.Count) do
    begin
      // Find all files in the folder
      CurrentPathSpec := Path + '\*.*';
      FindHandle := FindFirstFileW(PWideChar( CurrentPathSpec), FindFileDataW);

      if (FindHandle <> INVALID_HANDLE_VALUE) then
      begin
        repeat
            // .............  ANSII or UNICODE .......................

            // We filled in the FileFileDataW above even if on Win9x
            CurrentPath := Path + '\' + FindFileDataW.cFileName;
            IsDotPath := (WideStrIComp(@FindFileDataW.cFileName, '.') = 0);
            IsDotDotPath := (WideStrIComp(@FindFileDataW.cFileName, '..') = 0);

            if not (IsDotPath or IsDotDotPath) then
            begin

              // Decide if we use the file or not
              UseFile := FileMask and FindFileDataW.dwFileAttributes <> 0;
              if WidePathMatchSpecExists then
                UseFile := UseFile and WidePathMatchSpec(FindFileDataW.cFileName, Masks[i]);

              // Let the program override us
              if UseFile then
                SearchManager.DoSearchCompare(Path, FindFileDataW, UseFile);

              // Using the file
               if UseFile then
              begin
                PIDL := PathToPIDL(CurrentPath);
                PIDLList.Add(PIDL);

                // Cut down on the number of thread locks we use, they are expensive
                if PIDLList.Count > 99 then
                begin
                  LockThread;
                  for j := 0 to PIDLList.Count - 1 do
                    SearchResultsLocal.Add(PIDLList[j]);
                  PIDLList.Clear;
                  UnlockThread;
                end
              end;
            end;

            // Add the folders if we are recursing the folder, but only on the first runthrough
            if (i = 0) and (FindFileDataW.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) and not(IsDotPath or IsDotDotPath) then
              FolderList.Add(CurrentPath);

              Done := not FindNextFileW(FindHandle, FindFileDataW)
        until Terminated or Done;
        Windows.FindClose(FindHandle);
      end;
      Inc(i)
    end;
    // Recurse into sub folders if necessary
    if FileMask and FILE_ATTRIBUTE_DIRECTORY <> 0 then
    begin
      for i := 0 to FolderList.Count - 1 do
        ProcessFiles(FolderList[i], Masks, PIDLList)
    end;
  finally
    FolderList.Free;
  end
end;

{ TVirtualFileSearch }
constructor TVirtualFileSearch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SearchResults := TCommonPIDLList.Create;
  Timer := TTimer.Create(Self);
  Timer.Enabled := False;
  Timer.OnTimer := TimerTick;
  SearchPaths := TStringList.Create;
  SearchCriteriaFilename := TStringList.Create;
 // SearchCriteriaContent := TStringList.Create;
  FUpdateRate := 1000;
  FThreadPriority := tpLower;
  SearchAttribs := [vsaArchive, vsaCompressed, vsaEncrypted, vsaHidden, vsaNormal, vsaOffline, vsaReadOnly, vsaSystem, vsaTemporary]
end;

destructor TVirtualFileSearch.Destroy;
begin
  Stop;
  SearchPaths.Free;
  SearchCriteriaFilename.Free;
  SearchResults.Free;
//  SearchCriteriaContent.Free;
  inherited Destroy;
end;

function TVirtualFileSearch.BuildMask: Integer;
begin
  Result := 0;
  if vsaReadOnly in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_READONLY;
  if vsaHidden in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_HIDDEN;
  if vsaSystem in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_SYSTEM;
  if SubFolders then
    Result := Result or FILE_ATTRIBUTE_DIRECTORY;
  if vsaArchive in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_ARCHIVE;
  if vsaNormal in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_NORMAL;
  if vsaCompressed in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_COMPRESSED;
  if vsaOffline in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_OFFLINE;
  if vsaTemporary in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_TEMPORARY;
  if vsaEncrypted in SearchAttribs then
    Result := Result or FILE_ATTRIBUTE_ENCRYPTED;
end;

procedure TVirtualFileSearch.DoProgress(Results: TCommonPIDLList; var Handled: Boolean; var FreePIDLs: Boolean);
begin
  if Assigned(OnProgress) then
    OnProgress(Self, Results, Handled, FreePIDLs)
end;

procedure TVirtualFileSearch.DoSearchCompare(const FilePath: string; FindFileData: TWIN32FindDataW; var UseFile: Boolean);
begin
  // WARNING CALLED IN CONTEXT OF THREAD
  if Assigned(OnSearchCompare) then
    OnSearchCompare(Self, FilePath, FindFileData, UseFile)
end;

procedure TVirtualFileSearch.DoSearchEnd(Results: TCommonPIDLList);
begin
  if Assigned(OnSearchEnd) then
    OnSearchEnd(Self, Results)
end;

function TVirtualFileSearch.Run: Boolean;
begin
  FFinished := False;
  SearchResults.Clear;
  FileFindThread := TVirtualFileSearchThread.Create(True);
  FileFindThread.SearchResultsLocal := SearchResults;
  FileFindThread.SearchManager := Self;
  FileFindThread.SearchPaths.Assign(SearchPaths);
  FileFindThread.SearchCriteriaFileName.Assign(SearchCriteriaFilename);
//  FileFindThread.SearchCriteriaContent.Assign(SearchCriteriaContent);
  FileFindThread.CaseSensitive := CaseSensitive;
  FileFindThread.FileMask := BuildMask;
  FileFindThread.Priority := ThreadPriority;
  FileFindThread.Resume;
  Timer.Interval := UpdateRate;
  Timer.Enabled := True;
  Result := True;
end;

procedure TVirtualFileSearch.Stop;
var
  SafetyNet: Integer;
begin
  SafetyNet := 0;
  if Assigned(FileFindThread) then
  begin
    Timer.Enabled := False;
    FileFindThread.Terminate;
    while not FileFindThread.Finished and (SafetyNet < 50) do
    begin
      Sleep(100);
      Inc(SafetyNet);
    end;
    if SafetyNet > 49 then
      FileFindThread.ForceTerminate;
    FreeAndNil(FFileFindThread);
  end;
  FFinished := True;
end;

procedure TVirtualFileSearch.TimerTick(Sender: TObject);
var
  Handled, FreePIDLs: Boolean;
begin
  if Assigned(FileFindThread) then
    FileFindThread.LockThread;
  try
    Handled := False;
    FreePIDLS := False;
    DoProgress(SearchResults, Handled, FreePIDLs);
    if Handled then
    begin
      if FreePIDLs then
        SearchResults.SharePIDLs := False;
      SearchResults.Clear;
      SearchResults.SharePIDLs := True
    end;
  finally
    if not Assigned(FileFindThread) or FileFindThread.Finished then
    begin
      Timer.Enabled := False;
      FFinished := True;
      DoSearchEnd(SearchResults);
      SearchResults.Clear;
    end;

    if Assigned(FileFindThread) then
    begin
      FileFindThread.UnlockThread;
      if FileFindThread.Finished then
        FreeAndNil(FFileFindThread);
    end
  end
end;

end.

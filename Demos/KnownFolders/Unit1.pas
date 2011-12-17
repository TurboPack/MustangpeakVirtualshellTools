unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MPShellTypes, MPSHellUtilities, ExtCtrls, MPCommonObjects;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    CheckBoxExists: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    EditAliasPath: TEdit;
    EditFilePath: TEdit;
    Image1: TImage;
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FolderIDs: array[0..101] of TGUID;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ListBox1Click(Sender: TObject);
var
  NS: TNamespace;
begin
  EditAliasPath.Text := '';
  EditFilePath.Text := '';
  Image1.Picture.Bitmap.Width := JumboSysImages.Width;
  Image1.Picture.Bitmap.Height := JumboSysImages.Height;
  Image1.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, Image1.Picture.Bitmap.Width, Image1.Picture.Bitmap.Height));
  NS := CreateKnownFolderNamespace(FolderIDs[ListBox1.ItemIndex], False, False);
  CheckBoxExists.Checked := Assigned(NS);
  if Assigned(NS) then
  begin
    JumboSysImages.Draw(Image1.Picture.Bitmap.Canvas, 0, 0, NS.GetIconIndex(False, icLarge));
    EditAliasPath.Text := NS.NameForParsing;
    NS.Free;
    NS := CreateKnownFolderNamespace(FolderIDs[ListBox1.ItemIndex], False, True);
    if Assigned(NS) then
    begin
      EditFilePath.Text := NS.NameForParsing;
      NS.Free
    end
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FolderIDs[0] := FOLDERID_AddNewPrograms;
  FolderIDs[1] := FOLDERID_AdminTools;
  FolderIDs[2] := FOLDERID_AppUpdates;
  FolderIDs[3] :=  FOLDERID_CDBurning;
  FolderIDs[4] :=  FOLDERID_ChangeRemovePrograms;
  FolderIDs[5] :=  FOLDERID_CommonAdminTools;
  FolderIDs[6] :=  FOLDERID_CommonOEMLinks;
  FolderIDs[7] :=  FOLDERID_CommonPrograms;
  FolderIDs[8] :=  FOLDERID_CommonStartMenu;
  FolderIDs[9] :=  FOLDERID_CommonStartup;
  FolderIDs[10] :=  FOLDERID_CommonTemplates;
  FolderIDs[11] :=  FOLDERID_ComputerFolder;
  FolderIDs[12] :=  FOLDERID_ConflictFolder;
  FolderIDs[13] :=  FOLDERID_ConnectionsFolder;
  FolderIDs[14] :=  FOLDERID_Contacts;
  FolderIDs[15] :=  FOLDERID_ControlPanelFolder;
  FolderIDs[16] :=  FOLDERID_Cookies;
  FolderIDs[17] :=  FOLDERID_Desktop;
  FolderIDs[18] :=  FOLDERID_DeviceMetadataStore;
  FolderIDs[19] :=  FOLDERID_DocumentsLibrary;
  FolderIDs[20] :=  FOLDERID_Downloads;
  FolderIDs[21] :=  FOLDERID_Favorites;
  FolderIDs[22] :=  FOLDERID_Fonts;
  FolderIDs[23] :=  FOLDERID_Games;
  FolderIDs[24] :=  FOLDERID_GameTasks;
  FolderIDs[25] :=  FOLDERID_History;
  FolderIDs[26] :=  FOLDERID_HomeGroup;
  FolderIDs[27] :=  FOLDERID_ImplicitAppShortcuts;
  FolderIDs[28] :=  FOLDERID_InternetCache;
  FolderIDs[29] :=  FOLDERID_InternetFolder;
  FolderIDs[30] :=  FOLDERID_Libraries;
  FolderIDs[31] :=  FOLDERID_Links;
  FolderIDs[32] :=  FOLDERID_LocalAppData;
  FolderIDs[33] :=  FOLDERID_LocalAppDataLow;
  FolderIDs[34] :=  FOLDERID_LocalizedResourcesDir;
  FolderIDs[35] :=  FOLDERID_Music;
  FolderIDs[36] :=  FOLDERID_MusicLibrary;
  FolderIDs[37] :=  FOLDERID_NetworkFolder;
  FolderIDs[38] :=  FOLDERID_OriginalImages;
  FolderIDs[39] :=  FOLDERID_PhotoAlbums;
  FolderIDs[40] :=  FOLDERID_PicturesLibrary;
  FolderIDs[41] :=  FOLDERID_Pictures;
  FolderIDs[42] :=  FOLDERID_Playlists;
  FolderIDs[43] :=  FOLDERID_PrintersFolder;
  FolderIDs[44] :=  FOLDERID_PrintHood;
  FolderIDs[45] :=  FOLDERID_Profile;
  FolderIDs[46] :=  FOLDERID_ProgramData;
  FolderIDs[47] :=  FOLDERID_ProgramFiles;
  FolderIDs[48] :=  FOLDERID_ProgramFilesX64;
  FolderIDs[49] :=  FOLDERID_ProgramFilesX86;
  FolderIDs[50] :=  FOLDERID_ProgramFilesCommon;
  FolderIDs[51] :=  FOLDERID_ProgramFilesCommonX64;
  FolderIDs[52] :=  FOLDERID_ProgramFilesCommonX86;
  FolderIDs[53] :=  FOLDERID_Programs;
  FolderIDs[54] :=  FOLDERID_Public;
  FolderIDs[55] :=  FOLDERID_PublicDesktop;
  FolderIDs[56] :=  FOLDERID_PublicDocuments;
  FolderIDs[57] :=  FOLDERID_PublicDownloads;
  FolderIDs[58] :=  FOLDERID_PublicGameTasks;
  FolderIDs[59] :=  FOLDERID_PublicLibraries;
  FolderIDs[60] :=  FOLDERID_PublicMusic;
  FolderIDs[61] :=  FOLDERID_PublicPictures;
  FolderIDs[62] :=  FOLDERID_PublicRingtones;
  FolderIDs[63] :=  FOLDERID_PublicVideos;
  FolderIDs[64] :=  FOLDERID_QuickLaunch;
  FolderIDs[65] :=  FOLDERID_Recent;
  FolderIDs[66] :=  FOLDERID_RecordedTV;
  FolderIDs[67] :=  FOLDERID_RecordedTVLibrary;
  FolderIDs[68] :=  FOLDERID_RecycleBinFolder;
  FolderIDs[69] :=  FOLDERID_ResourceDir;
  FolderIDs[70] :=  FOLDERID_Ringtones;
  FolderIDs[71] :=  FOLDERID_RoamingAppData;
  FolderIDs[72] :=  FOLDERID_SampleMusic;
  FolderIDs[73] :=  FOLDERID_SamplePictures;
  FolderIDs[74] :=  FOLDERID_SamplePlaylists;
  FolderIDs[75] :=  FOLDERID_SampleVideos;
  FolderIDs[76] :=  FOLDERID_SavedGames;
  FolderIDs[77] :=  FOLDERID_SavedSearches;
  FolderIDs[78] :=  FOLDERID_SEARCH_CSC;
  FolderIDs[79] :=  FOLDERID_SEARCH_MAPI;
  FolderIDs[80] :=  FOLDERID_SearchHome;
  FolderIDs[81] :=  FOLDERID_SendTo;
  FolderIDs[82] :=  FOLDERID_SidebarDefaultParts;
  FolderIDs[83] :=  FOLDERID_SidebarParts;
  FolderIDs[84] :=  FOLDERID_StartMenu;
  FolderIDs[85] :=  FOLDERID_Startup;
  FolderIDs[86] :=  FOLDERID_SyncManagerFolder;
  FolderIDs[87] :=  FOLDERID_SyncResultsFolder;
  FolderIDs[88] :=  FOLDERID_SyncSetupFolder;
  FolderIDs[89] :=  FOLDERID_System;
  FolderIDs[90] :=  FOLDERID_SystemX86;
  FolderIDs[91] := FOLDERID_Templates;
  FolderIDs[92] :=  FOLDERID_TreeProperties;
  FolderIDs[93] :=  FOLDERID_UserPinned;
  FolderIDs[94] := FOLDERID_UserProfiles;
  FolderIDs[95] :=  FOLDERID_UserProgramFiles;
  FolderIDs[96] :=  FOLDERID_UserProgramFilesCommon;
  FolderIDs[97] :=  FOLDERID_UsersFiles;
  FolderIDs[98] :=  FOLDERID_UsersLibraries;
  FolderIDs[99] :=  FOLDERID_Videos;
  FolderIDs[100] :=  FOLDERID_VideosLibrary;
  FolderIDs[101] :=  FOLDERID_Windows
end;

end.

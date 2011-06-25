object Form1: TForm1
  Left = 417
  Top = 155
  Width = 734
  Height = 569
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    718
    531)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 296
    Top = 56
    Width = 85
    Height = 13
    Caption = 'Alias (Virtual) Path'
  end
  object Label2: TLabel
    Left = 296
    Top = 112
    Width = 41
    Height = 13
    Caption = 'File Path'
  end
  object Image1: TImage
    Left = 328
    Top = 176
    Width = 385
    Height = 345
    Transparent = True
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 265
    Height = 531
    Align = alLeft
    ItemHeight = 13
    Items.Strings = (
      'FOLDERID_AddNewPrograms'
      'FOLDERID_AdminTools'
      'FOLDERID_AppUpdates'
      'FOLDERID_CDBurning'
      'FOLDERID_ChangeRemovePrograms'
      'FOLDERID_CommonAdminTools'
      'FOLDERID_CommonOEMLinks'
      'FOLDERID_CommonPrograms'
      'FOLDERID_CommonStartMenu'
      'FOLDERID_CommonStartup'
      'FOLDERID_CommonTemplates'
      'FOLDERID_ComputerFolder'
      'FOLDERID_ConflictFolder'
      'FOLDERID_ConnectionsFolder'
      'FOLDERID_Contacts'
      'FOLDERID_ControlPanelFolder'
      'FOLDERID_Cookies'
      'FOLDERID_Desktop'
      'FOLDERID_DeviceMetadataStore'
      'FOLDERID_DocumentsLibrary'
      'FOLDERID_Downloads'
      'FOLDERID_Favorites'
      'FOLDERID_Fonts'
      'FOLDERID_Games'
      'FOLDERID_GameTasks'
      'FOLDERID_History'
      'FOLDERID_HomeGroup'
      'FOLDERID_ImplicitAppShortcuts'
      'FOLDERID_InternetCache'
      'FOLDERID_InternetFolder'
      'FOLDERID_Libraries'
      'FOLDERID_Links'
      'FOLDERID_LocalAppData'
      'FOLDERID_LocalAppDataLow'
      'FOLDERID_LocalizedResourcesDir'
      'FOLDERID_Music'
      'FOLDERID_MusicLibrary'
      'FOLDERID_NetworkFolder'
      'FOLDERID_OriginalImages'
      'FOLDERID_PhotoAlbums'
      'FOLDERID_PicturesLibrary'
      'FOLDERID_Pictures'
      'FOLDERID_Playlists'
      'FOLDERID_PrintersFolder'
      'FOLDERID_PrintHood'
      'FOLDERID_Profile'
      'FOLDERID_ProgramData'
      'FOLDERID_ProgramFiles'
      'FOLDERID_ProgramFilesX64'
      'FOLDERID_ProgramFilesX86'
      'FOLDERID_ProgramFilesCommon'
      'FOLDERID_ProgramFilesCommonX64'
      'FOLDERID_ProgramFilesCommonX86'
      'FOLDERID_Programs'
      'FOLDERID_Public'
      'FOLDERID_PublicDesktop'
      'FOLDERID_PublicDocuments'
      'FOLDERID_PublicDownloads'
      'FOLDERID_PublicGameTasks'
      'FOLDERID_PublicLibraries'
      'FOLDERID_PublicMusic'
      'FOLDERID_PublicPictures'
      'FOLDERID_PublicRingtones'
      'FOLDERID_PublicVideos'
      'FOLDERID_QuickLaunch'
      'FOLDERID_Recent'
      'FOLDERID_RecordedTV'
      'FOLDERID_RecordedTVLibrary'
      'FOLDERID_RecycleBinFolder'
      'FOLDERID_ResourceDir'
      'FOLDERID_Ringtones'
      'FOLDERID_RoamingAppData'
      'FOLDERID_SampleMusic'
      'FOLDERID_SamplePictures'
      'FOLDERID_SamplePlaylists'
      'FOLDERID_SampleVideos'
      'FOLDERID_SavedGames'
      'FOLDERID_SavedSearches'
      'FOLDERID_SEARCH_CSC'
      'FOLDERID_SEARCH_MAPI'
      'FOLDERID_SearchHome'
      'FOLDERID_SendTo'
      'FOLDERID_SidebarDefaultParts'
      'FOLDERID_SidebarParts'
      'FOLDERID_StartMenu'
      'FOLDERID_Startup'
      'FOLDERID_SyncManagerFolder'
      'FOLDERID_SyncResultsFolder'
      'FOLDERID_SyncSetupFolder'
      'FOLDERID_System'
      'FOLDERID_SystemX86'
      'FOLDERID_Templates'
      'FOLDERID_TreeProperties'
      'FOLDERID_UserPinned'
      'FOLDERID_UserProfiles'
      'FOLDERID_UserProgramFiles'
      'FOLDERID_UserProgramFilesCommon'
      'FOLDERID_UsersFiles'
      'FOLDERID_UsersLibraries'
      'FOLDERID_Videos'
      'FOLDERID_VideosLibrary'
      'FOLDERID_Windows')
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object CheckBoxExists: TCheckBox
    Left = 296
    Top = 24
    Width = 73
    Height = 17
    Caption = 'Exists'
    TabOrder = 1
  end
  object EditAliasPath: TEdit
    Left = 328
    Top = 80
    Width = 372
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'EditAliasPath'
  end
  object EditFilePath: TEdit
    Left = 328
    Top = 136
    Width = 372
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'EditFilePath'
  end
end

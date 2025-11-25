object Form1: TForm1
  Left = 184
  Top = 218
  Width = 781
  Height = 488
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    765
    452)
  PixelsPerInch = 96
  TextHeight = 13
  object TntLabel1: TLabel
    Left = 248
    Top = 16
    Width = 200
    Height = 13
    Caption = 'Enter Search String(s), semicolon delimited'
  end
  object Label1: TLabel
    Left = 536
    Top = 8
    Width = 63
    Height = 13
    Caption = 'File Attributes'
  end
  object Label2: TLabel
    Left = 400
    Top = 40
    Width = 124
    Height = 26
    Caption = 'Thread Priority (be careful with TimeCritical)'
    FocusControl = Button1
    WordWrap = True
  end
  object Label3: TLabel
    Left = 256
    Top = 96
    Width = 241
    Height = 13
    AutoSize = False
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 256
    Top = 112
    Width = 241
    Height = 13
    AutoSize = False
  end
  object Label5: TLabel
    Left = 256
    Top = 128
    Width = 497
    Height = 13
    AutoSize = False
  end
  object VirtualExplorerTreeview1: TVirtualExplorerTreeview
    Left = 0
    Top = 0
    Width = 241
    Height = 452
    Active = True
    Align = alLeft
    ColumnDetails = cdUser
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    FileObjects = [foFolders]
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintMode = hmHint
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 0
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages, toGhostedIfUnfocused]
    TreeOptions.SelectionOptions = [toMultiSelect, toSiblingSelectConstraint]
    TreeOptions.VETShellOptions = [toContextMenus]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toRemoveContextMenuShortCut]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
    OnEnumFolder = VirtualExplorerTreeview1EnumFolder
    Columns = <>
  end
  object Button1: TButton
    Left = 360
    Top = 414
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Search'
    TabOrder = 1
    OnClick = Button1Click
  end
  object TntMemoCriteria: TMemo
    Left = 256
    Top = 40
    Width = 97
    Height = 49
    Lines.Strings = (
      '*.exe')
    TabOrder = 2
  end
  object CheckBoxArchive: TCheckBox
    Left = 536
    Top = 24
    Width = 97
    Height = 17
    Caption = 'Archive'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CheckBoxCaseSensitive: TCheckBox
    Left = 536
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Case Sensitive'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object CheckBoxCompressed: TCheckBox
    Left = 536
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Compressed'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CheckBoxHidden: TCheckBox
    Left = 536
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Hidden'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object CheckBoxNormal: TCheckBox
    Left = 536
    Top = 104
    Width = 97
    Height = 17
    Caption = 'Normal'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object CheckBoxOffline: TCheckBox
    Left = 656
    Top = 24
    Width = 97
    Height = 17
    Caption = 'Offline'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object CheckBoxReadOnly: TCheckBox
    Left = 656
    Top = 40
    Width = 97
    Height = 17
    Caption = 'Read Only'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object CheckBoxSubFolders: TCheckBox
    Left = 656
    Top = 56
    Width = 97
    Height = 17
    Caption = 'Sub-Folders'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object CheckBoxSystem: TCheckBox
    Left = 656
    Top = 72
    Width = 97
    Height = 17
    Caption = 'System'
    Checked = True
    State = cbChecked
    TabOrder = 11
  end
  object CheckBoxTemporary: TCheckBox
    Left = 656
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Temporary'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object CheckBoxEncrypted: TCheckBox
    Left = 536
    Top = 72
    Width = 97
    Height = 17
    Caption = 'Encrypted'
    Checked = True
    State = cbChecked
    TabOrder = 13
  end
  object ComboBox1: TComboBox
    Left = 408
    Top = 72
    Width = 89
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 3
    TabOrder = 14
    Text = 'Normal'
    OnChange = ComboBox1Change
    Items.Strings = (
      'Idle'
      'Lowest'
      'Lower'
      'Normal'
      'Higher'
      'Highest'
      'TimeCritical'
      ''
      '')
  end
  object CheckBoxAnimateProgress: TCheckBox
    Left = 256
    Top = 144
    Width = 121
    Height = 17
    Caption = 'Animate Progress'
    TabOrder = 15
  end
  object Button2: TButton
    Left = 448
    Top = 414
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 16
    OnClick = Button2Click
  end
  object VirtualMultiPathExplorerEasyListview1: TVirtualMultiPathExplorerEasyListview
    Left = 256
    Top = 168
    Width = 497
    Height = 233
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelKind = bkTile
    CompressedFile.Color = clBlue
    CompressedFile.Font.Charset = DEFAULT_CHARSET
    CompressedFile.Font.Color = clWindowText
    CompressedFile.Font.Height = -11
    CompressedFile.Font.Name = 'MS Sans Serif'
    CompressedFile.Font.Style = []
    DefaultSortColumn = 0
    EditManager.Font.Charset = DEFAULT_CHARSET
    EditManager.Font.Color = clWindowText
    EditManager.Font.Height = -11
    EditManager.Font.Name = 'MS Sans Serif'
    EditManager.Font.Style = []
    EncryptedFile.Color = clGreen
    EncryptedFile.Font.Charset = DEFAULT_CHARSET
    EncryptedFile.Font.Color = clWindowText
    EncryptedFile.Font.Height = -11
    EncryptedFile.Font.Name = 'MS Sans Serif'
    EncryptedFile.Font.Style = []
    FileSizeFormat = vfsfDefault
    DragManager.Enabled = True
    Grouped = False
    GroupingColumn = 0
    Options = [eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloBrowseExecuteZipFolder, eloExecuteOnDblClick, eloThreadedImages, eloThreadedDetails, eloQueryInfoHints, eloShellContextMenus]
    PaintInfoGroup.MarginBottom.CaptionIndent = 4
    PaintInfoGroup.MarginTop.Visible = False
    ParentShowHint = False
    ShowHint = True
    Sort.Algorithm = esaQuickSort
    Sort.AutoSort = True
    Selection.AlphaBlend = True
    Selection.AlphaBlendSelRect = True
    Selection.EnableDragSelect = True
    Selection.MultiSelect = True
    Selection.RoundRect = True
    Selection.UseFocusRect = False
    TabOrder = 17
    Themed = False
    ThumbsManager.StorageFilename = 'Thumbnails.album'
    View = elsThumbnail
    OnScroll = VirtualMultiPathExplorerEasyListview1Scroll
    OnSortBegin = VirtualMultiPathExplorerEasyListview1SortBegin
    OnSortEnd = VirtualMultiPathExplorerEasyListview1SortEnd
  end
  object VirtualFileSearch1: TVirtualFileSearch
    OnProgress = VirtualFileSearch1Progress
    OnSearchEnd = VirtualFileSearch1SearchEnd
    ThreadPriority = tpIdle
    UpdateRate = 1000
    Left = 272
    Top = 168
  end
end

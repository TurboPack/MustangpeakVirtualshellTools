object Form1: TForm1
  Left = 248
  Top = 118
  Width = 770
  Height = 592
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Lucida Sans Unicode'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 266
    Top = 41
    Height = 366
  end
  object Panel1: TPanel
    Left = 0
    Top = 431
    Width = 754
    Height = 125
    Align = alBottom
    TabOrder = 0
    object Label3: TLabel
      Left = 216
      Top = 48
      Width = 37
      Height = 15
      Caption = 'Margin'
    end
    object Label4: TLabel
      Left = 216
      Top = 72
      Width = 42
      Height = 15
      Caption = 'Spacing'
    end
    object Label5: TLabel
      Left = 8
      Top = 8
      Width = 537
      Height = 30
      Caption = 
        'Controls the various properties associated with ShellToolbar1 (F' +
        'olders Toolbar).  Drop a few folders on the toolbar then control' +
        ' its appearance with the various options.'
      WordWrap = True
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 48
      Width = 73
      Height = 17
      Caption = 'Autosize'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 80
      Width = 97
      Height = 17
      Caption = 'Flat'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 96
      Width = 97
      Height = 17
      Caption = 'Transparent'
      TabOrder = 2
      OnClick = CheckBox4Click
    end
    object CheckBox5: TCheckBox
      Left = 104
      Top = 48
      Width = 105
      Height = 17
      Caption = 'Caption'
      TabOrder = 3
      OnClick = CheckBox5Click
    end
    object Edit3: TEdit
      Left = 265
      Top = 48
      Width = 48
      Height = 23
      TabOrder = 4
    end
    object Edit4: TEdit
      Left = 265
      Top = 72
      Width = 48
      Height = 23
      TabOrder = 5
    end
    object Button4: TButton
      Left = 320
      Top = 51
      Width = 25
      Height = 17
      Caption = 'Go'
      TabOrder = 6
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 320
      Top = 75
      Width = 25
      Height = 17
      Caption = 'Go'
      TabOrder = 7
      OnClick = Button5Click
    end
    object RadioGroup1: TRadioGroup
      Left = 352
      Top = 40
      Width = 138
      Height = 57
      Caption = 'Glyph Layout'
      Columns = 2
      ItemIndex = 2
      Items.Strings = (
        'Top'
        'Bottom'
        'Left'
        'Right')
      TabOrder = 8
      OnClick = RadioGroup1Click
    end
    object CheckBox3: TCheckBox
      Left = 104
      Top = 80
      Width = 97
      Height = 17
      Caption = 'Tile'
      TabOrder = 9
      OnClick = CheckBox3Click
    end
    object CheckBox6: TCheckBox
      Left = 104
      Top = 64
      Width = 97
      Height = 17
      Caption = 'No Extension'
      TabOrder = 10
      OnClick = CheckBox6Click
    end
    object CheckBox7: TCheckBox
      Left = 8
      Top = 64
      Width = 89
      Height = 17
      Caption = 'Same Width'
      TabOrder = 11
      OnClick = CheckBox7Click
    end
  end
  object DriveToolbar1: TVirtualDriveToolbar
    Left = 0
    Top = 41
    Width = 41
    Height = 366
    Align = alLeft
    BkGndParent = Owner
    ButtonCaptionOptions = [coDriveLetterOnly]
    Options = [toFlat, toThemeAware]
    VirtualExplorerTree = ExplorerTreeview1
  end
  object ShellToolbar1: TVirtualShellToolbar
    Left = 0
    Top = 0
    Width = 754
    Height = 41
    AutoSize = True
    BkGndParent = Owner
    Options = [toCustomizable, toFlat, toInsertDropable, toThemeAware]
    VirtualExplorerTree = ExplorerTreeview1
    WideText = 'Drop Folders Here:'
  end
  object ExplorerTreeview1: TVirtualExplorerTreeview
    Left = 41
    Top = 41
    Width = 225
    Height = 366
    Active = True
    Align = alLeft
    ColumnDetails = cdUser
    DefaultNodeHeight = 17
    DragHeight = 250
    DragImageKind = diMainColumnOnly
    DragWidth = 150
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintAnimation = hatNone
    HintMode = hmHint
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 3
    TabStop = True
    TreeOptions.AnimationOptions = [toAnimatedToggle]
    TreeOptions.AutoOptions = [toAutoScroll]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toReportMode, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toShowTreeLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETShellOptions = [toContextMenus, toDragDrop]
    TreeOptions.VETSyncOptions = [toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toExecuteOnDblClk]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages]
    VirtualExplorerListview = ExplorerListview1
    Columns = <>
  end
  object ExplorerListview1: TVirtualExplorerListview
    Left = 269
    Top = 41
    Width = 485
    Height = 366
    Active = True
    Align = alClient
    ColumnDetails = cdShellColumns
    DefaultNodeHeight = 17
    DragHeight = 250
    DragImageKind = diMainColumnOnly
    DragWidth = 150
    FileObjects = [foFolders, foNonFolders, foHidden]
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.SortColumn = 0
    HintAnimation = hatNone
    HintMode = hmHint
    Indent = 0
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 4
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toReportMode, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETFolderOptions = [toHideRootFolder]
    TreeOptions.VETShellOptions = [toContextMenus, toDragDrop]
    TreeOptions.VETSyncOptions = []
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toExecuteOnDblClk]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages]
    ColumnMenuItemCount = 8
    VirtualExplorerTreeview = ExplorerTreeview1
  end
  object SpecialFolderToolbar1: TVirtualSpecialFolderToolbar
    Left = 0
    Top = 407
    Width = 754
    Height = 24
    Align = alBottom
    BkGndParent = Owner
    Options = [toFlat, toThemeAware]
    SpecialFolders = [sfBitBucket, sfControlPanel, sfDesktop, sfDrives, sfFavorites, sfMyPictures, sfNetwork]
    SpecialCommonFolders = []
    VirtualExplorerTree = ExplorerTreeview1
    WideText = 'Special Folders'
  end
end

object Form1: TForm1
  Left = 274
  Top = 248
  Caption = 'Form1'
  ClientHeight = 341
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnShow = FormShow
  DesignSize = (
    551
    341)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 119
    Height = 26
    Caption = 'Click button or right click on the Listview'
    WordWrap = True
  end
  object RadioGroupFileName: TRadioGroup
    Left = 10
    Top = 72
    Width = 528
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    Caption = 'New Filename'
    ItemIndex = 0
    Items.Strings = (
      'Let VSTools create the filename'
      'Use my filename (no extenstion necessary)')
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 266
    Top = 102
    Width = 264
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'My Custom Filename'
  end
  object ExplorerListview1: TVirtualExplorerListview
    Left = 10
    Top = 136
    Width = 527
    Height = 201
    Active = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColumnDetails = cdShellColumns
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    FileObjects = [foFolders, foNonFolders]
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    HintAnimation = hatNone
    HintMode = hmHint
    Indent = 0
    ParentColor = False
    PopupMenu = VirtualShellNewMenu1
    RootFolder = rfDesktop
    TabOrder = 2
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toReportMode, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETFolderOptions = [toHideRootFolder]
    TreeOptions.VETShellOptions = [toContextMenus]
    TreeOptions.VETSyncOptions = []
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages]
    ColumnMenuItemCount = 8
  end
  object GroupBox1: TGroupBox
    Left = 152
    Top = 8
    Width = 385
    Height = 57
    Caption = 'Options'
    TabOrder = 3
    object CheckBox1: TCheckBox
      Left = 136
      Top = 16
      Width = 121
      Height = 17
      Hint = 
        'Turning this option on mimics Explorer New menu.  Explorer short' +
        'ens the list for example HTML files should have a *.htm and a *h' +
        'tml item.  Not combining items will leave both in menu.'
      Caption = 'Combine Like Items'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 136
      Top = 32
      Width = 105
      Height = 17
      Caption = 'Use Shell Images'
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 264
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Warn on Overwrite'
      TabOrder = 2
      OnClick = CheckBox3Click
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = 'New Folder Item'
      TabOrder = 3
      OnClick = CheckBox4Click
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 32
      Width = 113
      Height = 17
      Caption = 'New Shortcut Item'
      TabOrder = 4
      OnClick = CheckBox5Click
    end
  end
  object TBXToolbar1: TTBXToolbar
    Left = 16
    Top = 40
    Width = 90
    Height = 19
    Caption = 'TBXToolbar1'
    TabOrder = 4
    object TBXSubmenuItem1: TTBXSubmenuItem
      Caption = 'ShellNew Menu'
      Options = [tboDropdownArrow]
      OnPopup = TBXSubmenuItem1Popup
    end
  end
  object VirtualShellNewMenu1: TVirtualShellNewMenu
    OnAddMenuItem = VirtualShellNewMenu1AddMenuItem
    OnCreateNewFile = VirtualShellNewMenu1CreateNewFile
    WarnOnOverwrite = False
    Left = 88
    Top = 240
  end
end

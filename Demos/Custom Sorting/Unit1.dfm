object Form1: TForm1
  Left = 293
  Top = 197
  Width = 553
  Height = 409
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 545
    Height = 334
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object VirtualExplorerTreeview1: TVirtualExplorerTreeview
      Left = 0
      Top = 0
      Width = 200
      Height = 315
      Active = True
      Align = alLeft
      ColumnDetails = cdUser
      DefaultNodeHeight = 17
      DragHeight = 250
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
      HintMode = hmHint
      ParentColor = False
      RootFolder = rfDesktop
      TabOrder = 0
      TabStop = True
      TreeOptions.AutoOptions = [toAutoScroll]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toToggleOnDblClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages, toGhostedIfUnfocused]
      TreeOptions.SelectionOptions = [toLevelSelectConstraint]
      TreeOptions.VETShellOptions = [toContextMenus]
      TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
      TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toRemoveContextMenuShortCut]
      TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
      OnFocusChanged = VirtualExplorerTreeview1FocusChanged
      Columns = <>
    end
    object VirtualExplorerEasyListview1: TVirtualExplorerEasyListview
      Left = 200
      Top = 0
      Width = 345
      Height = 315
      Align = alClient
      DefaultSortColumn = 0
      DefaultSortDir = esdNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Shell Dlg 2'
      Font.Style = []
      Grouped = False
      GroupingColumn = 0
      GroupFont.Charset = DEFAULT_CHARSET
      GroupFont.Color = clWindowText
      GroupFont.Height = -11
      GroupFont.Name = 'MS Shell Dlg 2'
      GroupFont.Style = []
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Shell Dlg 2'
      Header.Font.Style = []
      Header.Visible = True
      PaintInfoGroup.MarginBottom.CaptionIndent = 4
      ParentFont = False
      ShowInactive = False
      TabOrder = 1
      ThumbsManager.StorageFilename = 'Thumbnails.album'
      View = elsIcon
      OnEnumFolder = VirtualExplorerEasyListview1EnumFolder
      OnItemCompare = VirtualExplorerEasyListview1ItemCompare
    end
    object StatusBar1: TStatusBar
      Left = 0
      Top = 315
      Width = 545
      Height = 19
      Panels = <
        item
          Width = 50
        end>
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 545
    Height = 41
    Align = alTop
    TabOrder = 1
    object CheckBox1: TCheckBox
      Left = 16
      Top = 8
      Width = 281
      Height = 17
      Caption = 'Assign OnItemCompare'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object ComboBox1: TComboBox
      Left = 320
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 1
      Text = 'Icon'
      OnChange = ComboBox1Change
      Items.Strings = (
        'Icon'
        'SmallIcon'
        'List'
        'Details'
        'Thumbnails'
        'Tile')
    end
  end
end

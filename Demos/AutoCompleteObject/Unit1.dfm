object Form1: TForm1
  Left = 320
  Top = 329
  Caption = 'Form1'
  ClientHeight = 252
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    520
    252)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 211
    Height = 13
    Caption = 'Start to type a target path into the Combobox'
  end
  object ExplorerTreeview1: TVirtualExplorerTreeview
    Left = 8
    Top = 72
    Width = 200
    Height = 204
    Active = True
    Anchors = [akLeft, akTop, akBottom]
    ColumnDetails = cdUser
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    ExplorerComboBox = ExplorerComboBox1
    FileObjects = [foFolders, foHidden, foEnableAsync]
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
    TabOrder = 0
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll, toAutoScrollOnExpand]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETShellOptions = [toContextMenus]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages]
    VirtualExplorerListview = ExplorerListview1
    Columns = <>
  end
  object ExplorerListview1: TVirtualExplorerListview
    Left = 214
    Top = 72
    Width = 297
    Height = 201
    Active = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColumnDetails = cdShellColumns
    DefaultNodeHeight = 17
    DragHeight = 250
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
    TabOrder = 1
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toReportMode, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETFolderOptions = [toHideRootFolder]
    TreeOptions.VETShellOptions = [toContextMenus, toShellColumnMenu]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages]
    ColumnMenuItemCount = 8
    VirtualExplorerTreeview = ExplorerTreeview1
    ThreadedEnum = True
  end
  object ExplorerComboBox1: TVirtualExplorerCombobox
    Left = 8
    Top = 40
    Width = 300
    Active = True
    Constraints.MinHeight = 23
    Options = [vcboThemeAware]
    TabOrder = 2
    TabStop = False
    Path = 'ExplorerComboBox1'
    PopupAutoCompleteOptions.Contents = [accCurrentDir, accMyComputer, accDesktop, accFileSysDirs, accFileSysFiles]
    PopupAutoCompleteOptions.OnAutoCompleteUpdateList = ExplorerComboBox1AutoCompleteUpdateList
    VirtualExplorerTree = ExplorerTreeview1
    OnAutoCompleteUpdateList = ExplorerComboBox1AutoCompleteUpdateList
  end
  object CheckBoxCustom: TCheckBox
    Left = 320
    Top = 40
    Width = 129
    Height = 17
    Caption = 'Fill with Custom Paths'
    TabOrder = 3
  end
end

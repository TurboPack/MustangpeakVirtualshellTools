object Form1: TForm1
  Left = 274
  Top = 180
  Caption = 'Form1'
  ClientHeight = 420
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 241
    Top = 0
    Height = 296
    ExplicitHeight = 301
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 401
    Width = 651
    Height = 19
    AutoHint = True
    Panels = <>
    SimplePanel = True
  end
  object Panel3: TPanel
    Left = 0
    Top = 296
    Width = 651
    Height = 105
    Align = alBottom
    BevelOuter = bvLowered
    BorderWidth = 2
    TabOrder = 1
    object Panel5: TPanel
      Left = 3
      Top = 3
      Width = 158
      Height = 99
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object ReadTreeFileBtn: TButton
        Left = 2
        Top = 0
        Width = 75
        Height = 25
        Hint = 'Read State From File'
        Caption = 'Read Tree'
        TabOrder = 0
        OnClick = ReadFileBtnClick
      end
      object CheckBoxTreeInfo: TCheckBox
        Left = 4
        Top = 80
        Width = 77
        Height = 17
        Caption = 'TreeInfo'
        TabOrder = 1
        OnClick = CheckBoxTreeInfoClick
      end
      object WriteTreeFileBtn: TButton
        Left = 80
        Top = 0
        Width = 75
        Height = 25
        Hint = 'Write States To File'
        Caption = 'Write Tree'
        TabOrder = 2
        OnClick = WriteFileBtnClick
      end
      object GetTreeCheckedBtn: TButton
        Left = 2
        Top = 25
        Width = 75
        Height = 25
        Hint = 'Get All Checked Paths'
        Caption = 'Checked'
        TabOrder = 3
        OnClick = GetAllCheckedPathsButtonClick
      end
      object GetTreeResolvedBtn: TButton
        Left = 80
        Top = 26
        Width = 75
        Height = 25
        Hint = 'Get Resolved Paths'
        Caption = 'Resolved'
        TabOrder = 4
        OnClick = GetResolvedPathsButtonClick
      end
      object SetTreeBtn: TButton
        Left = 2
        Top = 51
        Width = 75
        Height = 25
        Hint = 'Set Paths'
        Caption = 'Set Paths'
        TabOrder = 5
        OnClick = SetPathsButtonClick
      end
      object CheckBoxListInfo: TCheckBox
        Left = 84
        Top = 80
        Width = 77
        Height = 17
        Caption = 'ListInfo'
        TabOrder = 6
        OnClick = CheckBoxListInfoClick
      end
    end
    object TreeMemo: TMemo
      Left = 161
      Top = 3
      Width = 487
      Height = 99
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object SysTree: TVirtualExplorerTreeview
    Left = 0
    Top = 0
    Width = 241
    Height = 296
    Active = True
    Align = alLeft
    ColumnDetails = cdUser
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    FileObjects = [foFolders, foNonFolders, foHidden]
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = 0
    Header.Height = 17
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintMode = hmHint
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 2
    TabStop = True
    TreeOptions.AnimationOptions = [toAnimatedToggle]
    TreeOptions.AutoOptions = [toAutoScroll, toAutoHideButtons]
    TreeOptions.MiscOptions = [toCheckSupport, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toThemeAware, toUseBlendedImages, toGhostedIfUnfocused]
    TreeOptions.SelectionOptions = [toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETFolderOptions = [toFoldersExpandable, toForceHideRecycleBin]
    TreeOptions.VETShellOptions = []
    TreeOptions.VETSyncOptions = [toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages]
    OnChange = SysTreeChange
    VirtualExplorerListview = SysList
    Columns = <>
  end
  object SysList: TVirtualExplorerListview
    Left = 244
    Top = 0
    Width = 407
    Height = 296
    Active = True
    Align = alClient
    ColumnDetails = cdShellColumns
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    FileObjects = [foFolders, foNonFolders, foHidden]
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = -1
    Header.Height = 17
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.SortColumn = 0
    HintMode = hmHint
    Indent = 0
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 3
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll, toAutoHideButtons]
    TreeOptions.MiscOptions = [toCheckSupport, toReportMode, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toThemeAware, toUseBlendedImages, toGhostedIfUnfocused]
    TreeOptions.SelectionOptions = [toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETFolderOptions = [toHideRootFolder, toForceHideRecycleBin]
    TreeOptions.VETShellOptions = [toRightAlignSizeColumn]
    TreeOptions.VETSyncOptions = [toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread, toPersistentColumns]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages]
    OnChange = SysListChange
    ColumnMenuItemCount = 8
    VirtualExplorerTreeview = SysTree
  end
end

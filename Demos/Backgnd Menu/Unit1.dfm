object Form1: TForm1
  Left = 264
  Top = 180
  Caption = 'Form1'
  ClientHeight = 407
  ClientWidth = 644
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 24
    Top = 16
    Width = 209
    Height = 25
    Caption = 'Test'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 54
    Width = 644
    Height = 353
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 282
      Top = 1
      Width = 6
      Height = 351
      ResizeStyle = rsUpdate
    end
    object VirtualExplorerListview1: TVirtualExplorerListview
      Left = 1
      Top = 1
      Width = 281
      Height = 351
      Active = True
      Align = alLeft
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
      Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Header.SortColumn = 0
      Header.Style = hsPlates
      HintMode = hmTooltip
      Indent = 0
      ParentColor = False
      ParentShowHint = False
      RootFolder = rfDesktop
      ShowHint = True
      TabOrder = 0
      TabStop = True
      TreeOptions.AutoOptions = [toAutoScroll]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toReportMode, toToggleOnDblClick]
      TreeOptions.PaintOptions = [toHotTrack, toShowTreeLines, toThemeAware, toUseBlendedImages, toGhostedIfUnfocused, toUseBlendedSelection]
      TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
      TreeOptions.VETFolderOptions = [toHideRootFolder]
      TreeOptions.VETShellOptions = [toRightAlignSizeColumn, toContextMenus, toShellHints, toShellColumnMenu]
      TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
      TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toExecuteOnDblClk]
      TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
      BackGndMenu = VirtualShellBackgroundContextMenu1
      ColumnMenuItemCount = 8
    end
    object VirtualExplorerEasyListview1: TVirtualExplorerEasyListview
      Left = 288
      Top = 1
      Width = 355
      Height = 351
      Active = True
      Align = alClient
      BackGndMenu = VirtualShellBackgroundContextMenu2
      BevelKind = bkTile
      CompressedFile.Color = clBlue
      CompressedFile.Font.Charset = DEFAULT_CHARSET
      CompressedFile.Font.Color = clWindowText
      CompressedFile.Font.Height = -11
      CompressedFile.Font.Name = 'MS Sans Serif'
      CompressedFile.Font.Style = []
      DefaultSortColumn = 0
      EditManager.Enabled = True
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
      FileObjects = [foFolders, foNonFolders, foEnableAsync]
      FileSizeFormat = vfsfDefault
      Grouped = False
      GroupingColumn = 0
      Header.Visible = True
      Options = [eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloBrowseExecuteZipFolder, eloExecuteOnDblClick, eloThreadedImages, eloThreadedDetails, eloQueryInfoHints, eloShellContextMenus, eloChangeNotifierThread]
      PaintInfoGroup.MarginBottom.CaptionIndent = 4
      PaintInfoGroup.MarginTop.Visible = False
      ParentShowHint = False
      ShowHint = True
      Sort.Algorithm = esaQuickSort
      Sort.AutoSort = True
      Selection.AlphaBlend = True
      Selection.AlphaBlendSelRect = True
      Selection.EnableDragSelect = True
      Selection.Gradient = True
      Selection.MultiSelect = True
      Selection.RoundRect = True
      Selection.TextColor = clHighlight
      Selection.UseFocusRect = False
      TabOrder = 1
      ThumbsManager.StorageFilename = 'Thumbnails.album'
      View = elsReport
    end
  end
  object VirtualShellBackgroundContextMenu1: TVirtualShellBackgroundContextMenu
    AutoDetectNewItem = True
    OnMenuMerge = VirtualShellBackgroundContextMenu1MenuMerge
    OnMenuMergeBottom = VirtualShellBackgroundContextMenu1MenuMergeBottom
    OnMenuMergeTop = VirtualShellBackgroundContextMenu1MenuMergeTop
    OnNewItem = VirtualShellBackgroundContextMenu1NewItem
    OnShow = VirtualShellBackgroundContextMenu1Show
    Left = 112
    Top = 136
  end
  object PopupMenuTop: TPopupMenu
    Left = 112
    Top = 240
    object opItem11: TMenuItem
      Caption = 'Top Item 1'
      OnClick = MyItemClick
    end
    object opItem21: TMenuItem
      Caption = 'Top Item 2'
      OnClick = MyItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object opItem31: TMenuItem
      Caption = 'Top Item 3'
      OnClick = MyItemClick
    end
    object opSubItem1: TMenuItem
      Caption = 'Top Sub Item'
      object SubItem11: TMenuItem
        Caption = 'Sub Item 1'
        OnClick = MyItemClick
      end
      object SubItem21: TMenuItem
        Caption = 'Sub Item 2'
        OnClick = MyItemClick
      end
    end
  end
  object PopupMenuBottom: TPopupMenu
    Left = 112
    Top = 296
    object MyItemFirst1: TMenuItem
      Caption = 'My Item Last'
      OnClick = MyItemClick
    end
  end
  object PopupMenuNormal: TPopupMenu
    Left = 112
    Top = 184
    object MyItemNormal1: TMenuItem
      Caption = 'My Item Normal'
      OnClick = MyItemClick
    end
  end
  object VirtualShellBackgroundContextMenu2: TVirtualShellBackgroundContextMenu
    AutoDetectNewItem = True
    OnMenuMergeTop = VirtualShellBackgroundContextMenu2MenuMergeTop
    OnNewItem = VirtualShellBackgroundContextMenu2NewItem
    Left = 416
    Top = 112
  end
  object PopupMenuViews: TPopupMenu
    Left = 416
    Top = 160
    object View1: TMenuItem
      Caption = 'View'
      object Icon1: TMenuItem
        Caption = 'Icon'
        Checked = True
        OnClick = Icon1Click
      end
      object SmallIcon1: TMenuItem
        Caption = 'Small Icon'
        OnClick = SmallIcon1Click
      end
      object List1: TMenuItem
        Caption = 'List'
        OnClick = List1Click
      end
      object Report1: TMenuItem
        Caption = 'Report'
        OnClick = Report1Click
      end
      object Thumbnails1: TMenuItem
        Caption = 'Thumbnails'
        OnClick = Thumbnails1Click
      end
      object Tile1: TMenuItem
        Caption = 'Tile'
        OnClick = Tile1Click
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object ArrangeBy1: TMenuItem
      Caption = 'Arrange Icons By'
      object Name1: TMenuItem
        Caption = 'Name'
        Checked = True
        OnClick = Name1Click
      end
      object Type1: TMenuItem
        Caption = 'Type'
        OnClick = Type1Click
      end
      object Size1: TMenuItem
        Caption = 'Size'
        OnClick = Size1Click
      end
      object Modified1: TMenuItem
        Caption = 'Modified'
        OnClick = Modified1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Group1: TMenuItem
        Caption = 'Group'
        OnClick = Grup1Click
      end
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      OnClick = Refresh1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
  end
end

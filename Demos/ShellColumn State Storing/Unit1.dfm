object Form1: TForm1
  Left = 275
  Top = 103
  Width = 696
  Height = 480
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 312
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 241
      Top = 1
      Width = 6
      Height = 310
      AutoSnap = False
      ResizeStyle = rsUpdate
    end
    object ExplorerTreeview1: TVirtualExplorerTreeview
      Left = 1
      Top = 1
      Width = 240
      Height = 310
      Active = True
      Align = alLeft
      ColumnDetails = cdUser
      DefaultNodeHeight = 17
      DragHeight = 250
      DragWidth = 150
      FileObjects = [foFolders, foHidden]
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
      TreeOptions.AutoOptions = [toAutoScroll, toAutoTristateTracking]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toToggleOnDblClick]
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
      Left = 247
      Top = 1
      Width = 440
      Height = 310
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
      RootFolder = rfDesktop
      TabOrder = 1
      TabStop = True
      TreeOptions.AutoOptions = [toAutoScroll]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toReportMode, toToggleOnDblClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
      TreeOptions.VETFolderOptions = [toHideRootFolder]
      TreeOptions.VETShellOptions = [toContextMenus, toShellColumnMenu]
      TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
      TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread, toPersistentColumns]
      TreeOptions.VETImageOptions = [toImages, toThreadedImages]
      ColumnMenuItemCount = 8
      VirtualExplorerTreeview = ExplorerTreeview1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 688
    Height = 141
    Align = alBottom
    TabOrder = 1
    object Panel3: TPanel
      Left = 280
      Top = 1
      Width = 407
      Height = 139
      Align = alClient
      BevelOuter = bvLowered
      BorderWidth = 5
      TabOrder = 0
      object Memo1: TMemo
        Left = 6
        Top = 6
        Width = 395
        Height = 127
        Align = alClient
        Lines.Strings = (
          
            '    This demo shows how the TExplorerListview saves the state of' +
            ' the header '
          
            'columns on a node by node instance.  The column width, position,' +
            ' and visibility '
          'are saved in the Storage property of VET. '
          ''
          
            '    The Storage property is an sorted linked structure that can ' +
            'rapidly store and '
          
            'retrieve Pointer to Item ID Lists (PIDLs) that represent a shell' +
            ' namespace.'
          ''
          
            '    This structure is stored in memory for fast access.  To save' +
            ' the information '
          'for the next time VET is opened stream the Storage structure.'
          ''
          
            '    Also note the header right click dialog box if the column co' +
            'unt exceeds 8 '
          
            'items.  Windows 2000, WinME, and WinXP all support up to 37 buil' +
            't in '
          'columns '
          'for file objects.')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 279
      Height = 139
      Align = alLeft
      BevelOuter = bvLowered
      BorderWidth = 5
      TabOrder = 1
      object Label4: TLabel
        Left = 6
        Top = 68
        Width = 267
        Height = 65
        Align = alBottom
        Caption = 
          'Change the width of a column, order of the columns or visibilty ' +
          'of the columns of various nodes then press the Save to stream bu' +
          'tton.  Close then reopen the program then press the Load button.' +
          '  The states of each nodes header will be restored.'
        WordWrap = True
      end
      object Button1: TButton
        Left = 16
        Top = 3
        Width = 241
        Height = 25
        Caption = 'Save ExplorerListview Column Settings'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 16
        Top = 33
        Width = 241
        Height = 25
        Caption = 'Restore ExplorerListview Column Settings'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
end

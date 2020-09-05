object WndSearchFiles: TWndSearchFiles
  Left = 345
  Top = 149
  Caption = 'File Search'
  ClientHeight = 464
  ClientWidth = 407
  Color = clBtnFace
  Constraints.MinHeight = 220
  Constraints.MinWidth = 420
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001020000001000400280100001600000028000000100000002000
    0000010004000000000080000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000004EC0000000000004ECC000000877774ECC77000008F
    FF4ECC7F70000080087CC7FF7000087E70887FFF70008FE7E707FFFF70008EFE
    7E07FFFF70008FEFE707FFFF700008FEF07FFFFF7000008807FFFFFF7000008F
    FFFFFF000000008FFFFFFF7F8000008FFFFFFF7800000088888888800000FFCF
    0000FF870000C0030000C0030000C0030000C003000080030000000300000003
    00000003000080030000C0030000C0030000C0070000C00F0000C01F0000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 445
    Width = 407
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel_Middle: TPanel
    Left = 0
    Top = 190
    Width = 407
    Height = 16
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel_Top: TPanel
    Left = 0
    Top = 0
    Width = 407
    Height = 190
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel_Top'
    TabOrder = 0
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 293
      Height = 190
      ActivePage = TabSheet1
      Align = alLeft
      Constraints.MinWidth = 282
      MultiLine = True
      TabOrder = 0
      TabStop = False
      object TabSheet1: TTabSheet
        Caption = 'Name && Location'
        object Label1: TLabel
          Left = 13
          Top = 2
          Width = 45
          Height = 13
          Caption = 'File&name:'
          FocusControl = Edit_Filename
        end
        object Label2: TLabel
          Left = 13
          Top = 94
          Width = 44
          Height = 13
          Caption = '&Location:'
          FocusControl = Edit_Location
        end
        object Label3: TLabel
          Left = 13
          Top = 48
          Width = 77
          Height = 13
          Caption = '&Containing Text:'
          FocusControl = Edit_ContainingText
        end
        object Edit_Filename: TEdit
          Left = 13
          Top = 18
          Width = 258
          Height = 21
          Constraints.MinWidth = 200
          TabOrder = 0
        end
        object Edit_Location: TEdit
          Left = 13
          Top = 110
          Width = 258
          Height = 21
          Constraints.MinWidth = 200
          TabOrder = 3
          Text = 'C:\'
        end
        object CheckBox_IncludeSubfolders: TCheckBox
          Left = 13
          Top = 137
          Width = 129
          Height = 17
          Caption = '&Include subfolders'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object Button_Browse: TButton
          Left = 196
          Top = 134
          Width = 75
          Height = 25
          Caption = '&Browse...'
          TabOrder = 5
          OnClick = Button_BrowseClick
        end
        object Edit_ContainingText: TEdit
          Left = 13
          Top = 64
          Width = 258
          Height = 21
          Constraints.MinWidth = 200
          TabOrder = 1
        end
        object CheckBox_CaseInsensitive: TCheckBox
          Left = 173
          Top = 86
          Width = 97
          Height = 17
          Caption = 'C&ase Insensitive'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Date'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object DateTimePicker_BeforeDate: TDateTimePicker
          Left = 7
          Top = 133
          Width = 130
          Height = 21
          Date = 36578.000000000000000000
          Time = 36578.000000000000000000
          Enabled = False
          TabOrder = 6
        end
        object RadioGroup_DateSelection: TRadioGroup
          Left = 8
          Top = 7
          Width = 264
          Height = 53
          Caption = ' Find files '
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            '&Created'
            '&Modified'
            '&Accessed')
          TabOrder = 0
        end
        object DateTimePicker_AfterDate: TDateTimePicker
          Left = 7
          Top = 87
          Width = 130
          Height = 21
          Date = 36578.000000000000000000
          Time = 36578.000000000000000000
          Enabled = False
          TabOrder = 2
        end
        object DateTimePicker_BeforeTime: TDateTimePicker
          Left = 152
          Top = 133
          Width = 105
          Height = 21
          Date = 36579.998521296290000000
          Time = 36579.998521296290000000
          Enabled = False
          Kind = dtkTime
          TabOrder = 8
        end
        object DateTimePicker_AfterTime: TDateTimePicker
          Left = 152
          Top = 87
          Width = 105
          Height = 21
          Date = 36579.998521296290000000
          Time = 36579.998521296290000000
          Enabled = False
          Kind = dtkTime
          TabOrder = 4
        end
        object CheckBox_BeforeDate: TCheckBox
          Left = 7
          Top = 116
          Width = 82
          Height = 17
          Caption = 'Before Date:'
          TabOrder = 5
          OnClick = CheckBox_BeforeDateClick
        end
        object CheckBox_BeforeTime: TCheckBox
          Left = 152
          Top = 116
          Width = 82
          Height = 17
          Caption = 'Before Time:'
          TabOrder = 7
          OnClick = CheckBox_BeforeTimeClick
        end
        object CheckBox_AfterDate: TCheckBox
          Left = 7
          Top = 70
          Width = 74
          Height = 17
          Caption = 'After Date:'
          TabOrder = 1
          OnClick = CheckBox_AfterDateClick
        end
        object CheckBox_AfterTime: TCheckBox
          Left = 152
          Top = 70
          Width = 82
          Height = 17
          Caption = 'After Time:'
          TabOrder = 3
          OnClick = CheckBox_AfterTimeClick
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Advanced'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Attributes: TGroupBox
          Left = 8
          Top = 1
          Width = 268
          Height = 66
          Caption = ' Attributes '
          TabOrder = 0
          object CheckBox_AttributeSystem: TCheckBox
            Left = 91
            Top = 19
            Width = 67
            Height = 17
            Caption = 'Sys&tem'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object CheckBox_AttributeHidden: TCheckBox
            Left = 91
            Top = 39
            Width = 67
            Height = 17
            Caption = '&Hidden'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
          object CheckBox_AttributeReadonly: TCheckBox
            Left = 10
            Top = 39
            Width = 67
            Height = 17
            Caption = '&Readonly'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object CheckBox_AttributeArchive: TCheckBox
            Left = 10
            Top = 19
            Width = 67
            Height = 17
            Caption = '&Archive'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object CheckBox_AttributeDirectory: TCheckBox
            Left = 172
            Top = 39
            Width = 67
            Height = 17
            Caption = '&Directory'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
        end
        object CheckBox_AttributeExactMatch: TCheckBox
          Left = 8
          Top = 70
          Width = 227
          Height = 17
          Caption = 'Select files only if attribute &exactly matched '
          TabOrder = 1
        end
        object FileSize: TGroupBox
          Left = 8
          Top = 94
          Width = 268
          Height = 65
          Caption = ' Size '
          TabOrder = 2
          object Label8: TLabel
            Left = 223
            Top = 38
            Width = 14
            Height = 13
            Caption = 'KB'
          end
          object Label9: TLabel
            Left = 98
            Top = 38
            Width = 14
            Height = 13
            Caption = 'KB'
          end
          object Label10: TLabel
            Left = 136
            Top = 20
            Width = 39
            Height = 13
            Caption = 'At &Most:'
            FocusControl = SpinEdit_SizeMax
          end
          object Label11: TLabel
            Left = 10
            Top = 20
            Width = 42
            Height = 13
            Caption = 'At &Least:'
            FocusControl = SpinEdit_SizeMin
          end
          object SpinEdit_SizeMax: TSpinEdit
            Left = 135
            Top = 33
            Width = 86
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 1
            Value = 0
          end
          object SpinEdit_SizeMin: TSpinEdit
            Left = 10
            Top = 33
            Width = 86
            Height = 22
            MaxValue = 0
            MinValue = 0
            TabOrder = 0
            Value = 0
          end
        end
      end
    end
    object Panel_Right: TPanel
      Left = 293
      Top = 0
      Width = 114
      Height = 190
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Button_Find: TButton
        Left = 17
        Top = 28
        Width = 82
        Height = 25
        Caption = 'Find'
        Default = True
        TabOrder = 0
        OnClick = Button_FindClick
      end
      object Button_Stop: TButton
        Left = 17
        Top = 62
        Width = 82
        Height = 25
        Cancel = True
        Caption = 'Stop'
        Enabled = False
        TabOrder = 1
        OnClick = Button_StopClick
      end
      object Animate: TAnimate
        Left = 30
        Top = 99
        Width = 53
        Height = 50
        AutoSize = False
        CommonAVI = aviFindFile
        StopFrame = 8
      end
    end
  end
  object Panel_SearchResult: TPanel
    Left = 0
    Top = 206
    Width = 407
    Height = 239
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel_SearchResult'
    TabOrder = 1
    object SearchResult: TVirtualExplorerListview
      Left = 0
      Top = 0
      Width = 407
      Height = 239
      Active = False
      Align = alClient
      ColumnDetails = cdVETColumns
      DefaultNodeHeight = 17
      DragHeight = 250
      DragWidth = 150
      FileObjects = [foFolders, foNonFolders, foHidden]
      FileSizeFormat = fsfExplorer
      FileSort = fsFileType
      Header.AutoSizeIndex = -1
      Header.Height = 17
      Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible]
      HintMode = hmHint
      Indent = 0
      ParentColor = False
      RootFolder = rfDesktop
      TabOrder = 0
      TabStop = True
      TreeOptions.AutoOptions = [toAutoScroll, toDisableAutoscrollOnFocus]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toReportMode, toToggleOnDblClick]
      TreeOptions.PaintOptions = [toShowTreeLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
      TreeOptions.VETFolderOptions = [toHideRootFolder]
      TreeOptions.VETShellOptions = [toRightAlignSizeColumn, toContextMenus, toDragDrop, toShellColumnMenu]
      TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
      TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread, toExecuteOnDblClk]
      TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
      OnClipboardCopy = SearchResultClipboardCopy
      OnClipboardCut = SearchResultClipboardCut
      OnClipboardPaste = SearchResultClipboardPaste
      OnContextMenuCmd = SearchResultContextMenuCmd
      OnCreateDataObject = SearchResultCreateDataObject
      OnEnter = SearchResultEnter
      OnShellNotify = SearchResultShellNotify
      ColumnMenuItemCount = 8
      OnHeaderRebuild = SearchResultHeaderRebuild
      Columns = <
        item
          Position = 0
          Width = 200
          ColumnDetails = cdFileName
          WideText = 'Name'
        end
        item
          Alignment = taRightJustify
          Position = 1
          Width = 96
          ColumnDetails = cdSize
          WideText = 'Size'
        end
        item
          Position = 2
          Width = 120
          ColumnDetails = cdType
          WideText = 'Type'
        end
        item
          Position = 3
          Width = 120
          ColumnDetails = cdModified
          WideText = 'Modified'
        end
        item
          Position = 4
          Width = 60
          ColumnDetails = cdAttributes
          WideText = 'Attributes'
        end
        item
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coEditable]
          Position = 5
          Width = 180
          ColumnDetails = cdAccessed
          WideText = 'Accessed'
        end
        item
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coEditable]
          Position = 6
          Width = 120
          ColumnDetails = cdCreated
          WideText = 'Created'
        end
        item
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coEditable]
          Position = 7
          Width = 80
          ColumnDetails = cdDOSName
          WideText = 'DOS Name'
        end
        item
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coEditable]
          Position = 8
          Width = 150
          ColumnDetails = cdPath
          WideText = 'Path'
        end>
    end
  end
  object Timer_Notify: TTimer
    Enabled = False
    Interval = 50
    Left = 325
    Top = 168
  end
end

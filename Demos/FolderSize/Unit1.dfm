object Form1: TForm1
  Left = 281
  Top = 212
  Caption = 'Form1'
  ClientHeight = 425
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VirtualExplorerTree1: TVirtualExplorerTree
    Left = 0
    Top = 129
    Width = 633
    Height = 296
    Active = True
    Align = alClient
    ButtonFillMode = fmShaded
    ColumnDetails = cdUser
    ColumnMenuItemCount = 8
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    DrawSelectionMode = smBlendedRectangle
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Shell Dlg 2'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    HintAnimation = hatNone
    HintMode = hmHint
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 0
    TabStop = True
    TreeOptions.PaintOptions = [toShowButtons, toShowHorzGridLines, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.VETShellOptions = [toRightAlignSizeColumn, toContextMenus]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toExecuteOnDblClk]
    TreeOptions.VETImageOptions = [toImages]
    OnBeforeCellPaint = VirtualExplorerTree1BeforeCellPaint
    OnExpanded = VirtualExplorerTree1Expanded
    OnGetVETText = VirtualExplorerTree1GetVETText
    Columns = <
      item
        Position = 0
        Width = 300
        ColumnDetails = cdFileName
        WideText = 'Folder'
      end
      item
        Position = 1
        Width = 200
        ColumnDetails = cdCustom
        WideText = 'Relative Size'
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 33
    Align = alTop
    BevelInner = bvSpace
    BevelOuter = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 221
      Top = 9
      Width = 55
      Height = 13
      Caption = 'Size Format'
    end
    object Bevel1: TBevel
      Left = 368
      Top = 1
      Width = 9
      Height = 31
      Shape = bsLeftLine
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 8
      Width = 113
      Height = 17
      Caption = 'Recurse Folders'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object ComboBox1: TComboBox
      Left = 280
      Top = 6
      Width = 81
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnClick = ComboBox1Click
      Items.Strings = (
        'Byte'
        'KB'
        'MB'
        'GB'
        'Auto')
    end
    object CheckBox2: TCheckBox
      Left = 120
      Top = 8
      Width = 89
      Height = 17
      Caption = 'Gradient Bars'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 376
      Top = 8
      Width = 121
      Height = 17
      Caption = 'Read Floppy Drives'
      TabOrder = 3
    end
    object CheckBox4: TCheckBox
      Left = 496
      Top = 8
      Width = 137
      Height = 17
      Caption = 'Read Removable Drives'
      TabOrder = 4
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 33
    Width = 633
    Height = 96
    Align = alTop
    BorderStyle = bsNone
    Color = clInfoBk
    Lines.Strings = (
      
        'The demo shows folder sizes and presents them in a separate colu' +
        'mn as a bar chart.'
      
        'The bar represents the corresponding percentage of the total amo' +
        'unt of bytes in the tree branch.'
      'If the size is 0 no bar is shown at all.'
      
        'The caption format is controlled by the "Size Format" combobox, ' +
        'the sizes can be shown as bytes, KB, MB, GB or it can '
      'be automatically formated.'
      
        'When "Recurse Folder" is checked the size will be the total of t' +
        'he directory plus its subdirs; otherwise it will represent only '
      'the immediate files in the directory.'
      
        'When "Gradient Bars" are not used the bars are painted in red if' +
        ' they are 100% full.'
      ''
      'This demo shows you how to:'
      
        ' - Create a custom column, setting its caption and custom drawin' +
        'g it.'
      ' - Work with file sizes, and formating them to a string.'
      ' - Get the size of a particular directory.'
      
        ' - Get the total size of a tree branch, and set a percentage for' +
        ' each of the children.')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
end

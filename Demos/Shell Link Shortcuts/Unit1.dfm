object Form1: TForm1
  Left = 200
  Top = 188
  Width = 808
  Height = 477
  Caption = 'Form1'
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
  object Splitter1: TSplitter
    Left = 265
    Top = 0
    Width = 6
    Height = 441
    ResizeStyle = rsUpdate
  end
  object VirtualExplorerTree1: TVirtualExplorerTree
    Left = 0
    Top = 0
    Width = 265
    Height = 441
    Active = True
    Align = alLeft
    ColumnDetails = cdUser
    ColumnMenuItemCount = 8
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    FileObjects = [foFolders, foNonFolders]
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
    TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.VETShellOptions = [toContextMenus]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread, toExecuteOnDblClk]
    TreeOptions.VETImageOptions = [toImages]
    OnChange = VirtualExplorerTree1Change
    OnEnumFolder = VirtualExplorerTree1EnumFolder
    Columns = <>
  end
  object Panel1: TPanel
    Left = 271
    Top = 0
    Width = 521
    Height = 441
    Align = alClient
    BorderWidth = 5
    TabOrder = 1
    DesignSize = (
      521
      441)
    object Memo1: TMemo
      Left = 6
      Top = 351
      Width = 509
      Height = 84
      Align = alBottom
      Color = clBtnFace
      Lines.Strings = (
        'This demo shows the usage of the TShellLink component.  '
        ''
        
          'The VirtualExplorerTree on the left is set to only show shortcut' +
          ' files.  As a shortcut file is selected its '
        'properties are shown on the right.'
        ''
        
          'To create a shortcut file fill in the edit boxes with the desire' +
          'd information and press Create Link')
      ReadOnly = True
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 9
      Top = 8
      Width = 510
      Height = 305
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvLowered
      TabOrder = 1
      DesignSize = (
        510
        305)
      object Label1: TLabel
        Left = 7
        Top = 39
        Width = 56
        Height = 13
        Caption = 'Target File: '
      end
      object Label2: TLabel
        Left = 7
        Top = 62
        Width = 50
        Height = 13
        Caption = 'Arguments'
      end
      object Label3: TLabel
        Left = 7
        Top = 109
        Width = 53
        Height = 13
        Caption = 'Description'
      end
      object Label4: TLabel
        Left = 7
        Top = 132
        Width = 35
        Height = 13
        Caption = 'HotKey'
      end
      object Label5: TLabel
        Left = 7
        Top = 155
        Width = 73
        Height = 13
        Caption = 'HotKey Modifer'
      end
      object Label6: TLabel
        Left = 7
        Top = 178
        Width = 65
        Height = 13
        Caption = 'Icon Location'
      end
      object Label7: TLabel
        Left = 7
        Top = 16
        Width = 44
        Height = 13
        Caption = 'FileName'
      end
      object Label8: TLabel
        Left = 7
        Top = 85
        Width = 85
        Height = 13
        Caption = 'Working Directory'
      end
      object Label18: TLabel
        Left = 7
        Top = 224
        Width = 69
        Height = 13
        Caption = 'Show Window'
      end
      object Label19: TLabel
        Left = 7
        Top = 201
        Width = 50
        Height = 13
        Caption = 'Icon Index'
      end
      object Edit1: TEdit
        Left = 98
        Top = 8
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'Edit1'
      end
      object Edit2: TEdit
        Left = 98
        Top = 31
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        Text = 'Edit2'
      end
      object Edit3: TEdit
        Left = 98
        Top = 54
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        Text = 'Edit3'
      end
      object Edit4: TEdit
        Left = 98
        Top = 77
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        Text = 'Edit4'
      end
      object Edit5: TEdit
        Left = 98
        Top = 101
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        Text = 'Edit5'
      end
      object Edit6: TEdit
        Left = 98
        Top = 124
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        Text = 'Edit6'
      end
      object Edit8: TEdit
        Left = 98
        Top = 170
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 6
        Text = 'Edit8'
      end
      object Edit9: TEdit
        Left = 98
        Top = 193
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 7
        Text = 'Edit9'
      end
      object CheckBox1: TCheckBox
        Left = 100
        Top = 149
        Width = 45
        Height = 17
        Caption = 'Alt'
        TabOrder = 8
      end
      object CheckBox2: TCheckBox
        Left = 152
        Top = 149
        Width = 65
        Height = 17
        Caption = 'Control'
        TabOrder = 9
      end
      object CheckBox3: TCheckBox
        Left = 311
        Top = 149
        Width = 49
        Height = 17
        Caption = 'Shift'
        TabOrder = 10
      end
      object CheckBox4: TCheckBox
        Left = 225
        Top = 149
        Width = 73
        Height = 17
        Caption = 'Extended'
        TabOrder = 11
      end
      object RadioGroup1: TRadioGroup
        Left = 98
        Top = 213
        Width = 406
        Height = 85
        Anchors = [akLeft, akTop, akRight]
        Columns = 3
        Items.Strings = (
          'HIDE'
          'MAXIMIZE'
          'MINIMIZE'
          'RESTORE'
          'SHOW'
          'SHOWDEFAULT'
          'SHOWMINIMIZED'
          'SHOWMINNOACTIVE'
          'SHOWNA'
          'SHOWNOACTIVE'
          'SHOWNORMAL')
        TabOrder = 12
      end
    end
    object BitBtn1: TBitBtn
      Left = 202
      Top = 328
      Width = 97
      Height = 25
      Caption = 'Create Link'
      Default = True
      TabOrder = 2
      OnClick = BitBtn1Click
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
  end
  object VirtualShellLink1: TVirtualShellLink
    Left = 312
    Top = 272
  end
end

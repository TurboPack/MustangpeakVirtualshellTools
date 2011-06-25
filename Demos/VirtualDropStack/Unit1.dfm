object Form1: TForm1
  Left = 236
  Top = 153
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 185
    Top = 0
    Width = 6
    Height = 444
    ResizeStyle = rsUpdate
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 444
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 183
      Height = 39
      Align = alTop
      Caption = 
        'Drop File Objects from the Listview to the DropStack Window from' +
        ' one or more folders.'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 1
      Top = 53
      Width = 183
      Height = 78
      Align = alTop
      Caption = 
        'Browse to some other folder in the Listview and drag the files f' +
        'rom the DropStack to the Listview.  Hold the normal modifider ke' +
        'ys (CTRL, ALT, SHIFT) to copy, move or link just as in Explorer.'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 1
      Top = 40
      Width = 183
      Height = 13
      Align = alTop
    end
    object Label4: TLabel
      Left = 1
      Top = 131
      Width = 183
      Height = 13
      Align = alTop
    end
    object Label5: TLabel
      Left = 1
      Top = 144
      Width = 183
      Height = 78
      Align = alTop
      Caption = 
        'WARNING: Only the references to the objects are saved in the Dro' +
        'pStack Window.  The original files MUST be available when the ob' +
        'jects are dragged out of the DropStack Window.'
      WordWrap = True
    end
    object Panel2: TPanel
      Left = 1
      Top = 222
      Width = 183
      Height = 72
      Align = alTop
      TabOrder = 0
      object CheckBox1: TCheckBox
        Left = 84
        Top = 8
        Width = 85
        Height = 17
        Caption = 'Show Hint'
        TabOrder = 0
        OnClick = CheckBox1Click
      end
      object Button1: TButton
        Left = 4
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 1
        OnClick = Button1Click
      end
      object ComboBox1: TComboBox
        Left = 8
        Top = 40
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnChange = ComboBox1Change
        Items.Strings = (
          'Icon'
          'SmallIcon'
          'elsList'
          'Report'
          'Thumbnail'
          'Tile')
      end
    end
    object VirtualDropStack1: TVirtualDropStack
      Left = 1
      Top = 294
      Width = 183
      Height = 149
      Align = alClient
      BevelKind = bkTile
      DragManager.Enabled = True
      Selection.EnableDragSelect = True
      Selection.MultiSelect = True
      Selection.UseFocusRect = False
      TabOrder = 1
    end
  end
  object VirtualExplorerEasyListview1: TVirtualExplorerEasyListview
    Left = 191
    Top = 0
    Width = 489
    Height = 444
    Active = True
    Align = alClient
    BevelKind = bkTile
    CompressedFile.Color = clBlue
    CompressedFile.Font.Charset = DEFAULT_CHARSET
    CompressedFile.Font.Color = clWindowText
    CompressedFile.Font.Height = -11
    CompressedFile.Font.Name = 'MS Sans Serif'
    CompressedFile.Font.Style = []
    DefaultSortColumn = 0
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
    ExtensionColorCode = False
    DragManager.Enabled = True
    FileSizeFormat = vfsfDefault
    Grouped = False
    GroupingColumn = 0
    Options = [eloBrowseExecuteFolder, eloBrowseExecuteFolderShortcut, eloBrowseExecuteZipFolder, eloExecuteOnDblClick, eloThreadedImages, eloThreadedDetails, eloChangeNotifierThread]
    PaintInfoGroup.MarginBottom.CaptionIndent = 4
    PaintInfoGroup.MarginTop.Visible = False
    Sort.Algorithm = esaQuickSort
    Sort.AutoSort = True
    Selection.AlphaBlend = True
    Selection.AlphaBlendSelRect = True
    Selection.EnableDragSelect = True
    Selection.FullItemPaint = True
    Selection.Gradient = True
    Selection.MultiSelect = True
    Selection.RoundRect = True
    Selection.TextColor = clBlue
    TabOrder = 1
    ThumbsManager.StorageFilename = 'Thumbnails.album'
  end
end

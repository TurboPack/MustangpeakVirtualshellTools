object Form1: TForm1
  Left = 100
  Top = 89
  Caption = 'Form1'
  ClientHeight = 349
  ClientWidth = 741
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LV: TVirtualExplorerEasyListview
    Left = 0
    Top = 56
    Width = 741
    Height = 250
    Active = True
    Align = alClient
    BevelKind = bkTile
    CompressedFile.Color = clRed
    CompressedFile.Font.Charset = DEFAULT_CHARSET
    CompressedFile.Font.Color = clWindowText
    CompressedFile.Font.Height = -11
    CompressedFile.Font.Name = 'MS Shell Dlg 2'
    CompressedFile.Font.Style = []
    DefaultSortColumn = 0
    EditManager.Font.Charset = DEFAULT_CHARSET
    EditManager.Font.Color = clWindowText
    EditManager.Font.Height = -11
    EditManager.Font.Name = 'MS Shell Dlg 2'
    EditManager.Font.Style = []
    EncryptedFile.Color = 32832
    EncryptedFile.Font.Charset = DEFAULT_CHARSET
    EncryptedFile.Font.Color = clWindowText
    EncryptedFile.Font.Height = -11
    EncryptedFile.Font.Name = 'MS Shell Dlg 2'
    EncryptedFile.Font.Style = []
    FileSizeFormat = vfsfDefault
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
    PaintInfoGroup.MarginBottom.CaptionIndent = 4
    PaintInfoGroup.MarginTop.Visible = False
    ParentFont = False
    Sort.Algorithm = esaQuickSort
    Sort.AutoSort = True
    TabOrder = 0
    ThumbsManager.StorageFilename = 'Thumbnails.album'
    OnItemCompare = LVItemCompare
    OnItemGetCaption = LVItemGetCaption
    OnRootRebuild = LVRootRebuild
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 741
    Height = 56
    Align = alTop
    TabOrder = 1
    object ComboBox1: TComboBox
      Left = 16
      Top = 18
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'elsIcon'
      OnClick = ComboBox1Click
      Items.Strings = (
        'elsIcon'
        'elsSmallIcon'
        'elsList'
        'elsReport'
        'elsThumbnail'
        'elsTile'
        'elsFilmStrip'
        'elsGrid')
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 306
    Width = 741
    Height = 43
    Align = alBottom
    Color = clInfoBk
    Lines.Strings = (
      
        'This demo shows you how to add the [..] dir to the VirtualExplor' +
        'erEasyListview')
    ReadOnly = True
    TabOrder = 2
  end
end

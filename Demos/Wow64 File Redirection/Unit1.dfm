object Form1: TForm1
  Left = 369
  Top = 221
  Width = 792
  Height = 615
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    776
    577)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 40
    Width = 689
    Height = 13
    Caption = 
      'If VSTools is compiled into a 32 Bit application access to syste' +
      'm folders that are reserved for 64 Bit files are redirected to a' +
      ' equivalient 32 Bit Folder'
  end
  object Label2: TLabel
    Left = 48
    Top = 64
    Width = 650
    Height = 13
    Caption = 
      'By disabling redirection a 32 Bit application can access the 64 ' +
      'Bit folder.  In 64 Bit Windows the System32 Folder is reserved f' +
      'or 64 Bit files'
  end
  object Label3: TLabel
    Left = 48
    Top = 88
    Width = 658
    Height = 13
    Caption = 
      'and will typically redirect into the SysWow64 Bit folder.  Use t' +
      'he Disable Wow64 Redirection flag in VSTools to access 64 Bit sy' +
      'stem folders.'
  end
  object VirtualExplorerEasyListview1: TVirtualExplorerEasyListview
    Left = 16
    Top = 112
    Width = 737
    Height = 449
    Active = True
    Anchors = [akLeft, akTop, akRight, akBottom]
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
    FileSizeFormat = vfsfDefault
    Grouped = False
    GroupingColumn = 0
    PaintInfoGroup.MarginBottom.CaptionIndent = 4
    PaintInfoGroup.MarginTop.Visible = False
    Sort.Algorithm = esaQuickSort
    Sort.AutoSort = True
    TabOrder = 0
    ThumbsManager.StorageFilename = 'Thumbnails.album'
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 16
    Width = 233
    Height = 17
    Caption = 'Disable WOW64 Bit File Redirecction'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
end

object Form1: TForm1
  Left = 372
  Top = 233
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object VirtualExplorerCombobox1: TVirtualExplorerCombobox
    Left = 0
    Top = 41
    Width = 680
    Active = True
    Align = alTop
    TabOrder = 0
    Path = 'VirtualExplorerCombobox1'
    TextType = ecbtFullPath
  end
  object VirtualColumnModeView1: TVirtualColumnModeView
    Left = 0
    Top = 64
    Width = 680
    Height = 380
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    ParentColor = False
    TabOrder = 1
    ExplorerCombobox = VirtualExplorerCombobox1
    GroupingColumn = 0
    SmoothScrollDelta = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 41
    Align = alTop
    TabOrder = 2
    object CheckBox1: TCheckBox
      Left = 16
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Active'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
  end
end

object Form2: TForm2
  Left = 99
  Top = 372
  Width = 645
  Height = 312
  BorderStyle = bsSizeToolWin
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView1: TTreeView
    Left = 0
    Top = 25
    Width = 408
    Height = 253
    Align = alClient
    Indent = 19
    TabOrder = 0
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 637
    Height = 25
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 61
    Caption = 'ToolBar1'
    ShowCaptions = True
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      AutoSize = True
      Caption = 'Delete All'
      ImageIndex = 0
      OnClick = ToolButton1Click
    end
    object ToolButton2: TToolButton
      Left = 56
      Top = 2
      Caption = 'Mark All'
      ImageIndex = 1
      OnClick = ToolButton2Click
    end
    object ToolButton3: TToolButton
      Left = 117
      Top = 2
      AutoSize = True
      Caption = 'Collapse All'
      ImageIndex = 2
      OnClick = ToolButton3Click
    end
    object ToolButton4: TToolButton
      Left = 182
      Top = 2
      Caption = 'Expand All'
      ImageIndex = 3
      OnClick = ToolButton4Click
    end
  end
  object Panel1: TPanel
    Left = 408
    Top = 25
    Width = 229
    Height = 253
    Align = alRight
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 109
      Height = 13
      Caption = 'Shell Notifications Sent'
    end
    object Label2: TLabel
      Left = 16
      Top = 48
      Width = 116
      Height = 13
      Caption = 'Kernel Notifications Sent'
    end
    object Label3: TLabel
      Left = 16
      Top = 72
      Width = 137
      Height = 13
      Caption = 'Peak Change Notify Objects:'
    end
    object Label4: TLabel
      Left = 16
      Top = 120
      Width = 119
      Height = 13
      Caption = 'Peak Change Notify Lists'
    end
    object Label5: TLabel
      Left = 176
      Top = 24
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label6: TLabel
      Left = 176
      Top = 48
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label7: TLabel
      Left = 176
      Top = 72
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label8: TLabel
      Left = 176
      Top = 96
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label9: TLabel
      Left = 176
      Top = 120
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label10: TLabel
      Left = 176
      Top = 144
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label11: TLabel
      Left = 16
      Top = 96
      Width = 143
      Height = 13
      Caption = 'Current Change Notify Objects'
    end
    object Label12: TLabel
      Left = 16
      Top = 144
      Width = 128
      Height = 13
      Caption = 'Current Change Notify Lists'
    end
    object CheckBox1: TCheckBox
      Left = 120
      Top = 200
      Width = 97
      Height = 17
      Caption = 'Track Realtime'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object Button1: TButton
      Left = 8
      Top = 168
      Width = 97
      Height = 25
      Caption = 'Reset'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 120
      Top = 168
      Width = 97
      Height = 25
      Caption = 'Manual Refresh'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
end

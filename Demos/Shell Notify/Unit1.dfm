object Form1: TForm1
  Left = 183
  Top = 76
  Width = 568
  Height = 413
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  DesignSize = (
    552
    377)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 68
    Width = 111
    Height = 13
    Caption = 'Choose a Target Folder'
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 116
    Height = 26
    Caption = 'Click button or right click on the Listview'
    WordWrap = True
  end
  object RadioGroupFileName: TRadioGroup
    Left = -6
    Top = 112
    Width = 543
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    Caption = 'New Filename'
    ItemIndex = 0
    Items.Strings = (
      'Let VSTools create the filename'
      'Use my filename (no extension necessary)')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 18
    Top = 36
    Width = 121
    Height = 25
    Caption = 'ShellNew Menu'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 266
    Top = 142
    Width = 263
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'My Custom Filename'
  end
  object GroupBox1: TGroupBox
    Left = 152
    Top = 8
    Width = 385
    Height = 57
    Caption = 'Options'
    TabOrder = 4
    object CheckBox1: TCheckBox
      Left = 136
      Top = 16
      Width = 121
      Height = 17
      Hint = 
        'Turning this option on mimics Explorer New menu.  Explorer short' +
        'ens the list for example HTML files should have a *.htm and a *h' +
        'tml item.  Not combining items will leave both in menu.'
      Caption = 'Combine Like Items'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 136
      Top = 32
      Width = 105
      Height = 17
      Caption = 'Use Shell Images'
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 264
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Warn on Overwrite'
      TabOrder = 2
      OnClick = CheckBox3Click
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 16
      Width = 113
      Height = 17
      Caption = 'New Folder Item'
      TabOrder = 3
      OnClick = CheckBox4Click
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 32
      Width = 113
      Height = 17
      Caption = 'New Shortcut Item'
      TabOrder = 4
      OnClick = CheckBox5Click
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 358
    Width = 552
    Height = 19
    Panels = <
      item
        Text = ' 0 Total Objects'
        Width = 150
      end
      item
        Text = ' 0 Objects Selected'
        Width = 50
      end>
  end
end

object FormInfo: TFormInfo
  Left = 347
  Top = 221
  Width = 524
  Height = 472
  BorderStyle = bsSizeToolWin
  Caption = 'Namespace Info'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageContol1: TPageControl
    Left = 0
    Top = 0
    Width = 516
    Height = 438
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'IShellFolder'
      Enabled = False
      object GroupBox1: TGroupBox
        Left = 0
        Top = 310
        Width = 508
        Height = 100
        Align = alClient
        Caption = 'Name Relative to Parent Folder'
        TabOrder = 0
        object Label25: TLabel
          Left = 110
          Top = 15
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label26: TLabel
          Left = 110
          Top = 46
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label27: TLabel
          Left = 110
          Top = 63
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label28: TLabel
          Left = 110
          Top = 31
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label29: TLabel
          Left = 67
          Top = 15
          Width = 33
          Height = 13
          Alignment = taRightJustify
          Caption = 'Normal'
        end
        object Label30: TLabel
          Left = 65
          Top = 31
          Width = 35
          Height = 13
          Alignment = taRightJustify
          Caption = 'Parsing'
        end
        object Label31: TLabel
          Left = 46
          Top = 46
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = 'AddressBar'
        end
        object Label32: TLabel
          Left = 9
          Top = 63
          Width = 91
          Height = 13
          Alignment = taRightJustify
          Caption = 'Parsing Addressbar'
        end
        object Label35: TLabel
          Left = 110
          Top = 79
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label36: TLabel
          Left = 68
          Top = 79
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Editing'
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 206
        Width = 508
        Height = 104
        Align = alTop
        Caption = 'Name Relative to Desktop'
        TabOrder = 1
        object Label8: TLabel
          Left = 68
          Top = 18
          Width = 33
          Height = 13
          Alignment = taRightJustify
          Caption = 'Normal'
        end
        object Label9: TLabel
          Left = 66
          Top = 34
          Width = 35
          Height = 13
          Alignment = taRightJustify
          Caption = 'Parsing'
        end
        object Label11: TLabel
          Left = 111
          Top = 18
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label12: TLabel
          Left = 47
          Top = 50
          Width = 54
          Height = 13
          Alignment = taRightJustify
          Caption = 'AddressBar'
        end
        object Label13: TLabel
          Left = 111
          Top = 34
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label14: TLabel
          Left = 111
          Top = 50
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label16: TLabel
          Left = 10
          Top = 67
          Width = 91
          Height = 13
          Alignment = taRightJustify
          Caption = 'Parsing Addressbar'
        end
        object Label17: TLabel
          Left = 111
          Top = 67
          Width = 54
          Height = 13
          Caption = '                  '
        end
        object Label33: TLabel
          Left = 69
          Top = 82
          Width = 32
          Height = 13
          Alignment = taRightJustify
          Caption = 'Editing'
        end
        object Label34: TLabel
          Left = 111
          Top = 82
          Width = 54
          Height = 13
          Caption = '                  '
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 508
        Height = 47
        Align = alTop
        Caption = 'Capabilities'
        TabOrder = 2
        object CheckBox2: TCheckBox
          Left = 3
          Top = 14
          Width = 68
          Height = 13
          Caption = 'Can Copy'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
        object CheckBox3: TCheckBox
          Left = 108
          Top = 14
          Width = 121
          Height = 13
          Caption = 'Can Delete'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
        object CheckBox4: TCheckBox
          Left = 252
          Top = 14
          Width = 69
          Height = 13
          Caption = 'Can Link'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
        end
        object CheckBox5: TCheckBox
          Left = 252
          Top = 29
          Width = 74
          Height = 13
          Caption = 'Can Move'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
        end
        object CheckBox6: TCheckBox
          Left = 4
          Top = 29
          Width = 83
          Height = 13
          Caption = 'Can Rename'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
        end
        object CheckBox7: TCheckBox
          Left = 108
          Top = 29
          Width = 122
          Height = 13
          Caption = 'Drop Target'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 5
        end
        object CheckBox8: TCheckBox
          Left = 108
          Top = 29
          Width = 121
          Height = 13
          Caption = 'Has Property Sheet'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 6
        end
      end
      object GroupBox4: TGroupBox
        Left = 0
        Top = 47
        Width = 508
        Height = 31
        Align = alTop
        Caption = 'Attributes'
        TabOrder = 3
        object CheckBox9: TCheckBox
          Left = 3
          Top = 14
          Width = 62
          Height = 13
          Caption = 'Ghosted'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
        object CheckBox10: TCheckBox
          Left = 128
          Top = 14
          Width = 89
          Height = 13
          Caption = 'Link (shortcut)'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
        object CheckBox11: TCheckBox
          Left = 252
          Top = 14
          Width = 75
          Height = 13
          Caption = 'Read Only'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
        end
        object CheckBox12: TCheckBox
          Left = 343
          Top = 14
          Width = 58
          Height = 13
          Caption = 'Shared'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 78
        Width = 508
        Height = 31
        Align = alTop
        Caption = 'Miscellaneous Attributes'
        TabOrder = 4
        object CheckBox14: TCheckBox
          Left = 3
          Top = 14
          Width = 122
          Height = 13
          Caption = 'File System'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
        object CheckBox15: TCheckBox
          Left = 128
          Top = 14
          Width = 121
          Height = 13
          Caption = 'File System Ancestor'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
        object CheckBox16: TCheckBox
          Left = 252
          Top = 14
          Width = 65
          Height = 13
          Caption = 'Folder'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
        end
        object CheckBox17: TCheckBox
          Left = 343
          Top = 14
          Width = 76
          Height = 13
          Caption = 'Removable'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
        end
      end
      object GroupBox6: TGroupBox
        Left = 0
        Top = 142
        Width = 508
        Height = 64
        Align = alTop
        Caption = 'Supports Intefaces'
        TabOrder = 5
        object CheckBox18: TCheckBox
          Left = 3
          Top = 14
          Width = 99
          Height = 13
          Caption = 'IContext Menu'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
        object CheckBox19: TCheckBox
          Left = 3
          Top = 30
          Width = 99
          Height = 13
          Caption = 'IContext Menu 2'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
        object CheckBox20: TCheckBox
          Left = 111
          Top = 45
          Width = 99
          Height = 13
          Caption = 'IDataObject'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
        end
        object CheckBox21: TCheckBox
          Left = 218
          Top = 14
          Width = 82
          Height = 13
          Caption = 'IDropTarget'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
        end
        object CheckBox22: TCheckBox
          Left = 218
          Top = 30
          Width = 82
          Height = 13
          Caption = 'IExtractIcon'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
        end
        object CheckBox23: TCheckBox
          Left = 416
          Top = 13
          Width = 72
          Height = 13
          Caption = 'IQueryInfo'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 5
        end
        object CheckBox24: TCheckBox
          Left = 218
          Top = 45
          Width = 82
          Height = 13
          Caption = 'IShellDetails'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 6
        end
        object CheckBox25: TCheckBox
          Left = 3
          Top = 45
          Width = 99
          Height = 13
          Caption = 'IContextMenu 3'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 7
        end
        object CheckBox26: TCheckBox
          Left = 111
          Top = 14
          Width = 99
          Height = 13
          Caption = 'IExtractImage'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 8
        end
        object CheckBox27: TCheckBox
          Left = 111
          Top = 30
          Width = 99
          Height = 13
          Caption = 'IExtractImage2'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 9
        end
        object CheckBox28: TCheckBox
          Left = 304
          Top = 46
          Width = 72
          Height = 13
          Caption = 'IShellLink'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 10
        end
        object CheckBox1: TCheckBox
          Left = 304
          Top = 14
          Width = 72
          Height = 13
          Caption = 'ShellIcon'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 11
        end
        object CheckBox38: TCheckBox
          Left = 416
          Top = 46
          Width = 84
          Height = 13
          Caption = 'IShellFolder2'
          TabOrder = 12
        end
        object CheckBox39: TCheckBox
          Left = 416
          Top = 28
          Width = 73
          Height = 17
          Caption = 'IShellFolder'
          TabOrder = 13
        end
        object CheckBox40: TCheckBox
          Left = 304
          Top = 28
          Width = 105
          Height = 17
          Caption = 'IShellIconOverlay'
          TabOrder = 14
        end
      end
      object GroupBox9: TGroupBox
        Left = 0
        Top = 109
        Width = 508
        Height = 33
        Align = alTop
        Caption = 'Contents'
        TabOrder = 6
        object CheckBox13: TCheckBox
          Left = 4
          Top = 16
          Width = 122
          Height = 13
          Caption = 'Has Sub-Folders'
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'SHGetDataFromIDList'
      Enabled = False
      ImageIndex = 1
      object Label4: TLabel
        Left = 0
        Top = 161
        Width = 463
        Height = 26
        Align = alTop
        Caption = 
          'This sheet shows examples of the properties in the TNamespace cl' +
          'ass that take advantage of the TWin32FindData structure returned' +
          ' by both FindFirst and SHGetDataFromIDList.'
        WordWrap = True
      end
      object Label5: TLabel
        Left = 0
        Top = 192
        Width = 468
        Height = 39
        Align = alTop
        Caption = 
          'The only reason FindFirst is necessary is that the data returned' +
          ' by SHGetDataFromIDList is cached by the shell and is does not c' +
          'ontain a few of the fields in the data structure such as Creatio' +
          'n and Last Access times.'
        WordWrap = True
      end
      object GroupBox7: TGroupBox
        Left = 0
        Top = 0
        Width = 474
        Height = 62
        Align = alTop
        Caption = 'File Attributes'
        TabOrder = 0
        object CheckBox29: TCheckBox
          Left = 4
          Top = 14
          Width = 77
          Height = 13
          Caption = 'Archive'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
        end
        object CheckBox30: TCheckBox
          Left = 128
          Top = 14
          Width = 93
          Height = 13
          Caption = 'Compressed'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
        end
        object CheckBox31: TCheckBox
          Left = 252
          Top = 14
          Width = 122
          Height = 13
          Caption = 'Directory'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 2
        end
        object CheckBox32: TCheckBox
          Left = 252
          Top = 29
          Width = 61
          Height = 13
          Caption = 'Hidden'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 3
        end
        object CheckBox33: TCheckBox
          Left = 4
          Top = 29
          Width = 77
          Height = 13
          Caption = 'Normal'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 4
        end
        object CheckBox34: TCheckBox
          Left = 128
          Top = 29
          Width = 93
          Height = 13
          Caption = 'Off Line'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 5
        end
        object CheckBox35: TCheckBox
          Left = 128
          Top = 44
          Width = 93
          Height = 13
          Caption = 'Read Only File'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 6
        end
        object CheckBox36: TCheckBox
          Left = 252
          Top = 44
          Width = 59
          Height = 13
          Caption = 'System'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 7
        end
        object CheckBox37: TCheckBox
          Left = 4
          Top = 44
          Width = 77
          Height = 13
          Caption = 'Temporary'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 8
        end
      end
      object GroupBox8: TGroupBox
        Left = 0
        Top = 62
        Width = 474
        Height = 99
        Align = alTop
        Caption = 'Additional File Info'
        TabOrder = 1
        object Label41: TLabel
          Left = 136
          Top = 15
          Width = 45
          Height = 13
          Caption = '               '
          Color = clBtnFace
          ParentColor = False
        end
        object Label42: TLabel
          Left = 136
          Top = 32
          Width = 45
          Height = 13
          Caption = '               '
          Color = clBtnFace
          ParentColor = False
        end
        object Label43: TLabel
          Left = 136
          Top = 49
          Width = 45
          Height = 13
          Caption = '               '
          Color = clBtnFace
          ParentColor = False
        end
        object Label44: TLabel
          Left = 136
          Top = 64
          Width = 45
          Height = 13
          Caption = '               '
          Color = clBtnFace
          ParentColor = False
        end
        object Label45: TLabel
          Left = 136
          Top = 80
          Width = 45
          Height = 13
          Caption = '               '
          Color = clBtnFace
          ParentColor = False
        end
        object Label47: TLabel
          Left = 37
          Top = 15
          Width = 84
          Height = 13
          Caption = 'File Creation Time'
          Color = clBtnFace
          ParentColor = False
        end
        object Label48: TLabel
          Left = 18
          Top = 32
          Width = 103
          Height = 13
          Caption = 'File Last Access Time'
          Color = clBtnFace
          ParentColor = False
        end
        object Label51: TLabel
          Left = 31
          Top = 80
          Width = 89
          Height = 13
          Caption = 'File Size (kilobytes)'
          Color = clBtnFace
          ParentColor = False
        end
        object Label50: TLabel
          Left = 48
          Top = 64
          Width = 73
          Height = 13
          Caption = 'File Size (bytes)'
          Color = clBtnFace
          ParentColor = False
        end
        object Label49: TLabel
          Left = 29
          Top = 48
          Width = 93
          Height = 13
          Caption = 'File Last Write Time'
          Color = clBtnFace
          ParentColor = False
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'SHGetFileInfo'
      Enabled = False
      ImageIndex = 2
      ParentShowHint = False
      ShowHint = False
      object Label2: TLabel
        Left = 0
        Top = 134
        Width = 463
        Height = 39
        Align = alTop
        Caption = 
          'This sheet shows examples of the properties in the TNamespace cl' +
          'ass that take advantage of the SHGetFileInfo function.  These se' +
          'rvices can sometimes be retrieved by IShellDetails (column 2) or' +
          ' IExtractIcon.   '
        WordWrap = True
      end
      object Label3: TLabel
        Left = 0
        Top = 165
        Width = 472
        Height = 39
        Align = alTop
        Caption = 
          'Note that the results can be slightly different between methods ' +
          'depending on the Windows platform.  TNamespace tries to extract ' +
          'the information with the shell interfaces and resorts to SHGetFi' +
          'leInfo then defaults to hardcoded values as a last resort.'
        WordWrap = True
      end
      object GroupBox10: TGroupBox
        Left = 0
        Top = 0
        Width = 474
        Height = 38
        Align = alTop
        Caption = 'File Type'
        TabOrder = 0
        object Label24: TLabel
          Left = 7
          Top = 19
          Width = 48
          Height = 13
          Caption = '                '
        end
      end
      object GroupBox11: TGroupBox
        Left = 0
        Top = 38
        Width = 474
        Height = 96
        Align = alTop
        Caption = 'Icons'
        TabOrder = 1
        object GroupBox18: TGroupBox
          Left = 3
          Top = 11
          Width = 91
          Height = 80
          Caption = 'Normal'
          TabOrder = 0
          object Image1: TImage
            Left = 4
            Top = 58
            Width = 17
            Height = 17
          end
          object Image2: TImage
            Left = 26
            Top = 15
            Width = 60
            Height = 60
            Center = True
            Stretch = True
            Transparent = True
          end
        end
        object GroupBox19: TGroupBox
          Left = 106
          Top = 11
          Width = 91
          Height = 80
          Caption = 'Open'
          TabOrder = 1
          object Image3: TImage
            Left = 4
            Top = 58
            Width = 17
            Height = 16
          end
          object Image4: TImage
            Left = 27
            Top = 14
            Width = 60
            Height = 60
            Center = True
            Stretch = True
            Transparent = True
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'IShellDetails'
      ImageIndex = 3
      object Label21: TLabel
        Left = 0
        Top = 259
        Width = 508
        Height = 43
        Align = alTop
        AutoSize = False
        Caption = 
          'This sheet shows examples of the information extracted from the ' +
          'IShellDetails interface.  This is used by Explorer to change the' +
          ' headers in the right pane listview for special folders such as ' +
          'printers, Control Panel etc.'
        WordWrap = True
      end
      object Label22: TLabel
        Left = 0
        Top = 302
        Width = 491
        Height = 26
        Align = alTop
        Caption = 
          'Win2k only supports a limited number of folders with this legacy' +
          ' interface, it exposes IShellFolder2 which includes the same fun' +
          'ctions as IShellDetails and will soon be implemented.'
        WordWrap = True
      end
      object Label57: TLabel
        Left = 0
        Top = 328
        Width = 451
        Height = 26
        Align = alTop
        Caption = 
          'TNamespace attempts to use the values returned by IShellDetails ' +
          'through through the DetailOf, DetailsSupportedColumns, DetailsCo' +
          'lumnTitle, and ValidDetailsIndex methods.'
        WordWrap = True
      end
      object Label58: TLabel
        Left = 0
        Top = 354
        Width = 508
        Height = 26
        Align = alTop
        Caption = 
          'If the folder does not support IShellDetails it attempts to retr' +
          'ieve the information by other means.  Column text defaults to ph' +
          'ysical file type header text but can be overridden in the Detail' +
          'sDefaultxxxx methods.'
        WordWrap = True
      end
      object GroupBox12: TGroupBox
        Left = 0
        Top = 0
        Width = 508
        Height = 259
        Align = alTop
        Caption = 'IShellDetails Information'
        TabOrder = 0
        DesignSize = (
          508
          259)
        object Label1: TLabel
          Left = 61
          Top = 23
          Width = 107
          Height = 13
          Caption = 'Columns supported = x'
        end
        object Label6: TLabel
          Left = 320
          Top = 24
          Width = 144
          Height = 13
          Caption = 'Columns Supported (Parent) = '
          OnClick = FormCreate
        end
        object GroupBox13: TGroupBox
          Left = 3
          Top = 48
          Width = 238
          Height = 206
          Caption = 'Column Header Titles'
          TabOrder = 0
          object ListBox1: TListBox
            Left = 2
            Top = 15
            Width = 234
            Height = 189
            Align = alClient
            Color = clBtnFace
            ExtendedSelect = False
            ItemHeight = 13
            TabOrder = 0
          end
        end
        object GroupBox14: TGroupBox
          Left = 242
          Top = 48
          Width = 262
          Height = 206
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Column Details'
          TabOrder = 1
          object ListBox2: TListBox
            Left = 2
            Top = 15
            Width = 258
            Height = 189
            Align = alClient
            Color = clBtnFace
            Columns = 2
            ItemHeight = 13
            TabOrder = 0
          end
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Assorted Interfaces'
      Enabled = False
      ImageIndex = 4
      object GroupBox15: TGroupBox
        Left = 0
        Top = 289
        Width = 508
        Height = 72
        Align = alTop
        Caption = 'IQueryInfo'
        TabOrder = 0
        object GroupBox20: TGroupBox
          Left = 2
          Top = 15
          Width = 504
          Height = 55
          Align = alClient
          Caption = 'Info Tip'
          TabOrder = 0
          object Label62: TLabel
            Left = 2
            Top = 15
            Width = 500
            Height = 38
            Align = alClient
            AutoSize = False
            Caption = 'Label62'
            WordWrap = True
          end
        end
      end
      object GroupBox16: TGroupBox
        Left = 0
        Top = 0
        Width = 508
        Height = 289
        Align = alTop
        Caption = 'IExtractImage'
        TabOrder = 1
        object Label7: TLabel
          Left = 7
          Top = 19
          Width = 87
          Height = 13
          Caption = 'ExtractImage Path'
        end
        object Label18: TLabel
          Left = 100
          Top = 19
          Width = 38
          Height = 13
          Caption = 'Label18'
        end
        object GroupBox17: TGroupBox
          Left = 7
          Top = 44
          Width = 220
          Height = 220
          Caption = 'Image'
          TabOrder = 0
          object Image5: TImage
            Left = 2
            Top = 15
            Width = 216
            Height = 203
            Align = alClient
          end
        end
      end
      object GroupBox21: TGroupBox
        Left = 0
        Top = 361
        Width = 508
        Height = 49
        Align = alClient
        Caption = 'IShellIconOverlay'
        TabOrder = 2
        object Label10: TLabel
          Left = 32
          Top = 24
          Width = 121
          Height = 13
          AutoSize = False
          Caption = 'Overlay Index = '
        end
        object Label15: TLabel
          Left = 160
          Top = 24
          Width = 169
          Height = 13
          AutoSize = False
          Caption = 'Overlay Icon Index = '
        end
      end
    end
  end
  object ImageListSmall: TImageList
    Left = 828
    Top = 438
  end
  object ImageListLarge: TImageList
    Left = 826
    Top = 346
  end
end

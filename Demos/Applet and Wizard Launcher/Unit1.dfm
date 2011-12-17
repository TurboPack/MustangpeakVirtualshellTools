object Form1: TForm1
  Left = 157
  Top = 127
  Caption = 'Form1'
  ClientHeight = 535
  ClientWidth = 669
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Lucida Sans Unicode'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 15
  object Label6: TLabel
    Left = 0
    Top = 0
    Width = 669
    Height = 32
    Align = alTop
    Alignment = taCenter
    Caption = 
      'This Demo is for Window 2000 sp2 English version.  When a partic' +
      'ular tab in a dialog is selected it is dependant on the version ' +
      'of the Operating System.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Lucida Sans Unicode'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 643
  end
  object Bevel1: TBevel
    Left = 0
    Top = 32
    Width = 669
    Height = 18
    Align = alTop
    Shape = bsTopLine
    ExplicitWidth = 677
  end
  object RadioGroupAccessability: TRadioGroup
    Left = 8
    Top = 40
    Width = 129
    Height = 105
    Caption = 'Accessability Page'
    ItemIndex = 0
    Items.Strings = (
      'Keyboard'
      'Sound'
      'Display'
      'Mouse'
      'General')
    TabOrder = 0
  end
  object RadioGroupInstallUninstall: TRadioGroup
    Left = 144
    Top = 40
    Width = 129
    Height = 105
    Caption = 'Install/Uninstall Page'
    ItemIndex = 0
    Items.Strings = (
      'Install/Uninstall'
      'Windows Setup'
      'Startup Disk')
    TabOrder = 1
  end
  object RadioGroupScreenSettings: TRadioGroup
    Left = 280
    Top = 40
    Width = 177
    Height = 89
    Caption = 'Screen Settings Page'
    ItemIndex = 0
    Items.Strings = (
      'Background'
      'ScreenSaver'
      'Appearance'
      'Settings')
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 280
    Top = 440
    Width = 185
    Height = 89
    Caption = 'Install ScreenSaver (Dbl Click)'
    TabOrder = 3
    object VET1: TVirtualExplorerTree
      Left = 8
      Top = 16
      Width = 169
      Height = 65
      Active = True
      ColumnDetails = cdUser
      ColumnMenuItemCount = 8
      DefaultNodeHeight = 17
      DragHeight = 250
      DragWidth = 150
      FileObjects = [foNonFolders]
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
      RootFolder = rfSystem
      ScrollBarOptions.ScrollBars = ssVertical
      TabOrder = 0
      TabStop = True
      TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
      TreeOptions.VETFolderOptions = [toFoldersExpandable, toHideRootFolder]
      TreeOptions.VETShellOptions = [toContextMenus]
      TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
      TreeOptions.VETMiscOptions = [toExecuteOnDblClk]
      TreeOptions.VETImageOptions = [toImages]
      OnDblClick = VET1DblClick
      OnEnumFolder = VET1EnumFolder
      Columns = <>
    end
  end
  object RadioGroupMiscWizards: TRadioGroup
    Left = 8
    Top = 464
    Width = 265
    Height = 65
    Caption = 'Microsoft Applicatoin Settings'
    ItemIndex = 0
    Items.Strings = (
      'Exchange/Outlook Properties'
      'Mail PostOffice Properties')
    TabOrder = 4
  end
  object RadioGroupInternet: TRadioGroup
    Left = 8
    Top = 152
    Width = 129
    Height = 145
    Caption = 'Internet Properties Page'
    ItemIndex = 0
    Items.Strings = (
      'General'
      'Security'
      'Content'
      'Connection'
      'Programs'
      'Advanced')
    TabOrder = 5
  end
  object RadioGroupRegional: TRadioGroup
    Left = 144
    Top = 152
    Width = 129
    Height = 145
    Caption = 'Regional Settings Page'
    ItemIndex = 0
    Items.Strings = (
      'Regional Settings'
      'Number'
      'Currency'
      'Time'
      'Date'
      'Input Locals')
    TabOrder = 6
  end
  object RadioGroupControlPanel: TRadioGroup
    Left = 472
    Top = 40
    Width = 193
    Height = 281
    Caption = 'Control Panel'
    ItemIndex = 0
    Items.Strings = (
      'Control Panel'
      'Mouse'
      'Keyboard'
      'JoyStick'
      'Fast Find'
      'Sound'
      'Network Configuration'
      'OBDC Administrator'
      'Change Password (Win9x)'
      'Com Port Setting (WinNT)'
      'Server Properties (WinNT)'
      'Add New Hardware (Win9x)'
      'Add New Printer (Win9x)'
      'Themes'
      'UPS/Power Options (WinNT)'
      'TweakUI (if installed)')
    TabOrder = 7
  end
  object RadioGroupMultiMedia: TRadioGroup
    Left = 8
    Top = 384
    Width = 265
    Height = 73
    Caption = 'Multimedia Properties Page'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Sounds'
      'Audio'
      'Video'
      'MIDI'
      'CD Music'
      'Advanced/Devices')
    TabOrder = 8
  end
  object RadioGroupNetworkShare: TRadioGroup
    Left = 280
    Top = 264
    Width = 185
    Height = 57
    Caption = 'Network Share'
    ItemIndex = 0
    Items.Strings = (
      'Share Create'
      'Share Manage')
    TabOrder = 9
  end
  object Button1: TButton
    Left = 429
    Top = 291
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 10
    TabStop = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 102
    Top = 268
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 11
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 236
    Top = 267
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 12
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 237
    Top = 115
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 13
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 100
    Top = 115
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 14
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 421
    Top = 99
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 15
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 630
    Top = 50
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 16
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 237
    Top = 394
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 17
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 237
    Top = 499
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 18
    OnClick = Button9Click
  end
  object RadioGroupSysSettings: TRadioGroup
    Left = 8
    Top = 304
    Width = 265
    Height = 73
    Caption = 'System Settings (OS dependant this is Win2k)'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'General'
      'Network ID'
      'Hardware'
      'User Profiles'
      'Advanced')
    TabOrder = 19
  end
  object Button10: TButton
    Left = 237
    Top = 347
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 20
    OnClick = Button10Click
  end
  object RadioGroupTimeDate: TRadioGroup
    Left = 280
    Top = 136
    Width = 185
    Height = 57
    Caption = 'Time Date'
    ItemIndex = 0
    Items.Strings = (
      'General'
      'Time Zone')
    TabOrder = 21
  end
  object Button11: TButton
    Left = 429
    Top = 164
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 22
    OnClick = Button11Click
  end
  object RadioGroupModem: TRadioGroup
    Left = 280
    Top = 200
    Width = 185
    Height = 57
    Caption = 'Modem Page'
    ItemIndex = 0
    Items.Strings = (
      'Modem Options'
      'Dial Properties (WinNT)')
    TabOrder = 23
  end
  object Button12: TButton
    Left = 430
    Top = 228
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 24
    OnClick = Button12Click
  end
  object RadioGroupMiscApplet: TRadioGroup
    Left = 280
    Top = 328
    Width = 185
    Height = 105
    Caption = 'Misc Applets'
    ItemIndex = 0
    Items.Strings = (
      'Open With..'
      'Disk Copy'
      'View Fonts'
      'View Printers'
      'Dialup Wizard (Win9x)')
    TabOrder = 25
  end
  object Button13: TButton
    Left = 429
    Top = 403
    Width = 30
    Height = 25
    Caption = 'Go..'
    TabOrder = 26
    OnClick = Button13Click
  end
  object GroupBox2: TGroupBox
    Left = 472
    Top = 320
    Width = 193
    Height = 137
    Caption = 'Shell Dialogs'
    TabOrder = 27
    object SpeedButton1: TSpeedButton
      Left = 104
      Top = 16
      Width = 15
      Height = 15
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 104
      Top = 32
      Width = 15
      Height = 15
      OnClick = SpeedButton2Click
    end
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 81
      Height = 15
      Caption = 'SHFormatDrive'
    end
    object Label2: TLabel
      Left = 9
      Top = 35
      Width = 92
      Height = 15
      Caption = 'SHPickIconDialog'
    end
    object SpeedButton3: TSpeedButton
      Left = 104
      Top = 48
      Width = 15
      Height = 15
      OnClick = SpeedButton3Click
    end
    object Label3: TLabel
      Left = 9
      Top = 51
      Width = 53
      Height = 15
      Caption = 'SHRunFile'
    end
    object Label4: TLabel
      Left = 9
      Top = 66
      Width = 61
      Height = 15
      Caption = 'SHFindFiles'
      OnClick = Button10Click
    end
    object SpeedButton4: TSpeedButton
      Left = 104
      Top = 64
      Width = 15
      Height = 15
      OnClick = SpeedButton4Click
    end
    object Label5: TLabel
      Left = 9
      Top = 118
      Width = 92
      Height = 15
      Caption = 'SHFindComputer'
    end
    object SpeedButton5: TSpeedButton
      Left = 104
      Top = 117
      Width = 15
      Height = 15
      OnClick = SpeedButton5Click
    end
    object SpeedButton6: TSpeedButton
      Left = 104
      Top = 101
      Width = 15
      Height = 15
      OnClick = SpeedButton6Click
    end
    object Label7: TLabel
      Left = 8
      Top = 104
      Width = 80
      Height = 15
      Caption = 'Create Shorcut'
    end
    object CheckBoxRootMyComputer: TCheckBox
      Left = 24
      Top = 80
      Width = 161
      Height = 17
      Caption = 'Root from My Compter'
      TabOrder = 0
    end
  end
  object RadioGroupRunFile: TRadioGroup
    Left = 472
    Top = 464
    Width = 193
    Height = 65
    Hint = 
      'The RunFile Components allows a hook to test what file is tring ' +
      'to be run and to disallow it if necessary'
    Caption = 'RunFile Component'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Allow Run'
      'Cancel Run'
      'Force Retry')
    TabOrder = 28
  end
  object Button14: TButton
    Left = 584
    Top = 500
    Width = 51
    Height = 25
    Caption = 'Run...'
    TabOrder = 29
    OnClick = Button14Click
  end
  object VirtualRunFileDialog1: TVirtualRunFileDialog
    Options = []
    Left = 616
    Top = 448
  end
end

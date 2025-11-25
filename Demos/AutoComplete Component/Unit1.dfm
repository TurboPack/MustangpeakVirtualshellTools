object Form1: TForm1
  Left = 243
  Top = 192
  Width = 765
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    749
    442)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 272
    Top = 184
    Width = 446
    Height = 13
    Caption = 
      'Select a folder in the treeview to see what the shell suggests f' +
      'or autocomplete on the folder '
  end
  object CheckBox1: TCheckBox
    Left = 264
    Top = 8
    Width = 201
    Height = 17
    Caption = 'Include Current Directory'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 264
    Top = 24
    Width = 201
    Height = 17
    Caption = 'Include My Computer'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 264
    Top = 40
    Width = 201
    Height = 17
    Caption = 'Include Desktop'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = CheckBox3Click
  end
  object VirtualExplorerTreeview1: TVirtualExplorerTreeview
    Left = 0
    Top = 0
    Width = 257
    Height = 442
    Active = True
    Align = alLeft
    ColumnDetails = cdUser
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    FileSizeFormat = fsfExplorer
    FileSort = fsFileType
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Shell Dlg 2'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintAnimation = hatNone
    HintMode = hmHint
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 3
    TabStop = True
    TreeOptions.AutoOptions = [toAutoScroll]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
    TreeOptions.VETShellOptions = [toContextMenus]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toChangeNotifierThread]
    TreeOptions.VETImageOptions = [toImages, toThreadedImages]
    OnFocusChanged = VirtualExplorerTreeview1FocusChanged
    Columns = <>
  end
  object CheckBox4: TCheckBox
    Left = 264
    Top = 56
    Width = 201
    Height = 17
    Caption = 'Include Favorites'
    TabOrder = 4
    OnClick = CheckBox4Click
  end
  object CheckBox5: TCheckBox
    Left = 264
    Top = 72
    Width = 201
    Height = 17
    Caption = 'Include Only File System Objects'
    TabOrder = 5
    OnClick = CheckBox5Click
  end
  object CheckBox6: TCheckBox
    Left = 264
    Top = 88
    Width = 201
    Height = 17
    Caption = 'Include File Folders'
    Checked = True
    State = cbChecked
    TabOrder = 6
    OnClick = CheckBox6Click
  end
  object CheckBox7: TCheckBox
    Left = 264
    Top = 104
    Width = 201
    Height = 17
    Caption = 'Include Files'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = CheckBox7Click
  end
  object CheckBox8: TCheckBox
    Left = 264
    Top = 120
    Width = 201
    Height = 17
    Caption = 'Include Hidden Objects'
    TabOrder = 8
    OnClick = CheckBox8Click
  end
  object CheckBox9: TCheckBox
    Left = 264
    Top = 136
    Width = 201
    Height = 17
    Caption = 'Recurse into Sub-Folders'
    TabOrder = 9
    OnClick = CheckBox9Click
  end
  object CheckBox10: TCheckBox
    Left = 264
    Top = 152
    Width = 201
    Height = 17
    Caption = 'Sort List'
    TabOrder = 10
    OnClick = CheckBox10Click
  end
  object ListBox1: TListBox
    Left = 264
    Top = 208
    Width = 478
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 11
  end
  object VirtualShellAutoComplete1: TVirtualShellAutoComplete
    CurrentDir = ''
    Left = 528
    Top = 136
  end
end

object Form1: TForm1
  Left = 248
  Top = 141
  Width = 669
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
    661
    446)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 352
    Top = 56
    Width = 158
    Height = 13
    Caption = 'String To Assign To User Storage'
  end
  object Label2: TLabel
    Left = 352
    Top = 168
    Width = 289
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
  end
  object VET: TVirtualExplorerTree
    Left = 0
    Top = 0
    Width = 329
    Height = 446
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
    Header.Font.Name = 'MS Shell Dlg 2'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintMode = hmHint
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 0
    TabStop = True
    TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.VETShellOptions = [toRightAlignSizeColumn, toContextMenus]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toExecuteOnDblClk]
    TreeOptions.VETImageOptions = [toImages]
    Columns = <>
  end
  object Button1: TButton
    Left = 344
    Top = 24
    Width = 217
    Height = 25
    Caption = 'Store String to Selected Node'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 376
    Top = 72
    Width = 201
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Button2: TButton
    Left = 344
    Top = 128
    Width = 217
    Height = 25
    Caption = 'Read User Data from Selected Node'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 352
    Top = 224
    Width = 209
    Height = 25
    Caption = 'Delete User Data from Selected Node'
    TabOrder = 4
    OnClick = Button3Click
  end
end

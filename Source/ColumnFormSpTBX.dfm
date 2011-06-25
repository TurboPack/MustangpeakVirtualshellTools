object FormColumnSettings: TFormColumnSettings
  Left = 364
  Top = 252
  Width = 303
  Height = 372
  BorderIcons = [biSystemMenu]
  Caption = 'Column Settings'
  Color = clBtnFace
  Constraints.MinHeight = 370
  Constraints.MinWidth = 295
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpTBXPanel1: TSpTBXPanel
    Left = 0
    Top = 0
    Width = 287
    Height = 336
    Caption = 'SpTBXPanel1'
    Align = alClient
    TabOrder = 0
    TBXStyleBackground = True
    DesignSize = (
      287
      336)
    object Bevel1: TBevel
      Left = 16
      Top = 280
      Width = 252
      Height = 14
      Anchors = [akLeft, akTop, akRight, akBottom]
      Shape = bsBottomLine
    end
    object Label2: TSpTBXLabel
      Left = 10
      Top = 246
      Width = 149
      Height = 13
      Caption = 'The selected column should be '
      Anchors = [akBottom]
      OnClick = FormCreate
      Alignment = taCenter
    end
    object Label3: TSpTBXLabel
      Left = 211
      Top = 246
      Width = 52
      Height = 13
      Caption = 'pixels wide'
      Anchors = [akBottom]
    end
    object CheckBoxLiveUpdate: TSpTBXCheckBox
      Left = 18
      Top = 268
      Width = 75
      Height = 15
      Caption = 'Live Update'
      Anchors = [akRight, akBottom]
      TabOrder = 2
      OnClick = CheckBoxLiveUpdateClick
    end
    object ButtonOk: TSpTBXButton
      Left = 104
      Top = 304
      Width = 75
      Height = 25
      Caption = '&OK'
      Anchors = [akRight, akBottom]
      TabOrder = 3
      ModalResult = 1
    end
    object ButtonCancel: TSpTBXButton
      Left = 192
      Top = 304
      Width = 75
      Height = 25
      Caption = '&Cancel'
      Anchors = [akRight, akBottom]
      TabOrder = 4
      ModalResult = 2
    end
    object VSTColumnNames: TVirtualStringTree
      Left = 8
      Top = 47
      Width = 273
      Height = 186
      Anchors = [akLeft, akTop, akRight, akBottom]
      CheckImageKind = ckXP
      Header.AutoSizeIndex = 0
      Header.DefaultHeight = 17
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoColumnResize, hoDrag]
      HintAnimation = hatNone
      TabOrder = 5
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoTristateTracking]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toInitOnSave, toToggleOnDblClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages]
      OnChecking = VSTColumnNamesChecking
      OnDragAllowed = VSTColumnNamesDragAllowed
      OnDragOver = VSTColumnNamesDragOver
      OnDragDrop = VSTColumnNamesDragDrop
      OnFocusChanging = VSTColumnNamesFocusChanging
      OnFreeNode = VSTColumnNamesFreeNode
      OnGetText = VSTColumnNamesGetText
      OnInitNode = VSTColumnNamesInitNode
      Columns = <>
    end
    object EditPixelWidth: TSpTBXEdit
      Left = 172
      Top = 244
      Width = 35
      Height = 21
      Anchors = [akBottom]
      TabOrder = 6
      OnExit = EditPixelWidthExit
      OnKeyPress = EditPixelWidthKeyPress
    end
    object Label1: TSpTBXLabel
      Left = 2
      Top = 2
      Width = 283
      Height = 39
      Caption = 
        'Check the columns you would like to make visible in this Folder.' +
        '  Drag and Drop to reorder the columns. '
      Align = alTop
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Wrapping = twWrap
      Alignment = taCenter
    end
  end
end

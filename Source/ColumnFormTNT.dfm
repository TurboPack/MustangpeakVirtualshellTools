object FormColumnSettings: TFormColumnSettings
  Left = 364
  Top = 252
  Width = 299
  Height = 370
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
  DesignSize = (
    283
    334)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 16
    Top = 280
    Width = 256
    Height = 14
    Anchors = [akLeft, akTop, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label2: TTntLabel
    Left = 11
    Top = 246
    Width = 149
    Height = 13
    Alignment = taCenter
    Anchors = [akBottom]
    Caption = 'The selected column should be '
    OnClick = FormCreate
  end
  object Label3: TTntLabel
    Left = 214
    Top = 246
    Width = 52
    Height = 13
    Anchors = [akBottom]
    Caption = 'pixels wide'
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 283
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object Label1: TTntLabel
      Left = 4
      Top = 4
      Width = 275
      Height = 27
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'Check the columns you would like to make visible in this Folder.' +
        '  Drag and Drop to reorder the columns. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
  end
  object CheckBoxLiveUpdate: TTntCheckBox
    Left = 22
    Top = 268
    Width = 258
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Live Update'
    TabOrder = 1
    OnClick = CheckBoxLiveUpdateClick
  end
  object ButtonOk: TTntButton
    Left = 108
    Top = 304
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 2
  end
  object ButtonCancel: TTntButton
    Left = 196
    Top = 304
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object VSTColumnNames: TVirtualStringTree
    Left = 8
    Top = 47
    Width = 265
    Height = 186
    Anchors = [akLeft, akTop, akRight, akBottom]
    CheckImageKind = ckXP
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintAnimation = hatNone
    TabOrder = 4
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
  object EditPixelWidth: TTntEdit
    Left = 175
    Top = 244
    Width = 35
    Height = 21
    Anchors = [akBottom]
    TabOrder = 5
    OnExit = EditPixelWidthExit
    OnKeyPress = EditPixelWidthKeyPress
  end
end

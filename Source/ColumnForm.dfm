object FormColumnSettings: TFormColumnSettings
  Left = 364
  Top = 252
  BorderIcons = [biSystemMenu]
  Caption = 'Column Settings'
  ClientHeight = 331
  ClientWidth = 283
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 283
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object Label1: TLabel
      Left = 4
      Top = 4
      Width = 275
      Height = 27
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'Check the columns you would like to make visible in this Folder.' +
        '  Drag and Drop to reorder the columns. '
      WordWrap = True
    end
  end
  object VSTColumnNames: TVirtualStringTree
    Left = 0
    Top = 35
    Width = 283
    Height = 206
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Height = 17
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoTristateTracking, toAutoChangeScale]
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
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    ExplicitHeight = 186
    Columns = <>
  end
  object pnBottom: TPanel
    Left = 0
    Top = 241
    Width = 283
    Height = 90
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 267
    DesignSize = (
      283
      90)
    object Bevel1: TBevel
      Left = 16
      Top = -23
      Width = 256
      Height = 70
      Anchors = []
      Shape = bsBottomLine
      ExplicitTop = -24
    end
    object Label3: TLabel
      Left = 214
      Top = 4
      Width = 52
      Height = 13
      Anchors = []
      Caption = 'pixels wide'
      ExplicitTop = 3
    end
    object Label2: TLabel
      Left = 16
      Top = 5
      Width = 149
      Height = 13
      Alignment = taCenter
      Anchors = []
      Caption = 'The selected column should be '
      OnClick = FormCreate
      ExplicitTop = 4
    end
    object CheckBoxLiveUpdate: TCheckBox
      Left = 22
      Top = 25
      Width = 258
      Height = 17
      Anchors = []
      Caption = 'Live Update'
      TabOrder = 0
      OnClick = CheckBoxLiveUpdateClick
      ExplicitTop = 21
    end
    object EditPixelWidth: TEdit
      Left = 175
      Top = 1
      Width = 35
      Height = 21
      Anchors = []
      TabOrder = 1
      OnExit = EditPixelWidthExit
      OnKeyPress = EditPixelWidthKeyPress
      ExplicitTop = 0
    end
    object ButtonCancel: TButton
      Left = 196
      Top = 58
      Width = 75
      Height = 25
      Anchors = []
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
      ExplicitTop = 50
    end
    object ButtonOk: TButton
      Left = 108
      Top = 58
      Width = 75
      Height = 25
      Anchors = []
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 3
      ExplicitTop = 50
    end
  end
end

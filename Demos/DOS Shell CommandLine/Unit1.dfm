object Form1: TForm1
  Left = 275
  Top = 125
  Caption = 'Form1'
  ClientHeight = 442
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 388
    Width = 680
    Height = 54
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      680
      54)
    object Label1: TLabel
      Left = 128
      Top = 8
      Width = 427
      Height = 39
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 
        'The handing of the output of the command shell is not fully impl' +
        'emented.  This demo just shows how to use the TVirtualCommandLin' +
        'eRedirector.  To run other service applications use TVirtualRedi' +
        'rector'
      WordWrap = True
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 105
      Height = 25
      Caption = 'Run DOS Service...'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 388
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object RichEdit1: TRichEdit
      Left = 1
      Top = 1
      Width = 678
      Height = 386
      Align = alClient
      Color = clBlack
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      OnKeyDown = RichEdit1KeyDown
    end
  end
  object VirtualCommandLineRedirector1: TVirtualCommandLineRedirector
    OnChildProcessEnd = VirtualCommandLineRedirector1ChildProcessEnd
    OnErrorInput = VirtualCommandLineRedirector1ErrorInput
    OnInput = VirtualCommandLineRedirector1Input
    Left = 40
    Top = 48
  end
end

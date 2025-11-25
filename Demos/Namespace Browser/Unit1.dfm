object Form1: TForm1
  Left = 124
  Top = 193
  Width = 820
  Height = 596
  Caption = 'Namespace Browser Version 1.2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 249
    Top = 41
    Width = 6
    Height = 517
    ResizeStyle = rsUpdate
  end
  object Label39: TLabel
    Left = 32
    Top = 176
    Width = 96
    Height = 13
    Caption = 'Can Extract Async: '
  end
  object Label40: TLabel
    Left = 136
    Top = 176
    Width = 37
    Height = 13
    Caption = 'Label33'
  end
  object VET: TVirtualExplorerTree
    Left = 0
    Top = 41
    Width = 249
    Height = 517
    Active = True
    Align = alLeft
    ColumnDetails = cdUser
    ColumnMenuItemCount = 8
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    ExplorerComboBox = VirtualExplorerCombobox1
    FileObjects = [foFolders, foNonFolders, foHidden]
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
    HintMode = hmHint
    ParentColor = False
    RootFolder = rfDesktop
    TabOrder = 0
    TabStop = True
    TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages, toGhostedIfUnfocused]
    TreeOptions.VETShellOptions = [toRightAlignSizeColumn, toContextMenus]
    TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
    TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toExecuteOnDblClk]
    TreeOptions.VETImageOptions = [toImages, toMarkCutAndCopy]
    OnChange = VETChange
    Columns = <>
  end
  object PageControlShellBrowser: TPageControl
    Left = 255
    Top = 41
    Width = 549
    Height = 517
    ActivePage = TabSheetIShellFolder
    Align = alClient
    TabOrder = 1
    object TabSheetIShellFolder: TTabSheet
      Caption = 'IShellFolder'
      object GroupBoxCapabilities: TGroupBox
        Left = 0
        Top = 0
        Width = 541
        Height = 177
        Align = alTop
        Caption = 'Capabilities'
        TabOrder = 0
        object Label37: TLabel
          Left = 416
          Top = 96
          Width = 60
          Height = 13
          Caption = '[Windows 7]'
        end
        object CheckBoxCanCopy: TCheckBox
          Left = 8
          Top = 40
          Width = 97
          Height = 17
          Caption = 'Can Copy'
          TabOrder = 0
        end
        object CheckBoxCanRename: TCheckBox
          Left = 8
          Top = 120
          Width = 97
          Height = 17
          Caption = 'Can Rename'
          TabOrder = 1
        end
        object CheckBoxCanDelete: TCheckBox
          Left = 8
          Top = 56
          Width = 97
          Height = 17
          Caption = 'Can Delete'
          TabOrder = 2
        end
        object CheckBoxHasPropSheet: TCheckBox
          Left = 128
          Top = 104
          Width = 121
          Height = 17
          Caption = 'Has Property Sheet'
          TabOrder = 3
        end
        object CheckBoxCanLink: TCheckBox
          Left = 8
          Top = 72
          Width = 97
          Height = 17
          Caption = 'Can Link'
          TabOrder = 4
        end
        object CheckBoxCanMove: TCheckBox
          Left = 8
          Top = 104
          Width = 97
          Height = 17
          Caption = 'Can Move'
          TabOrder = 5
        end
        object CheckBoxGhosted: TCheckBox
          Left = 128
          Top = 88
          Width = 97
          Height = 17
          Caption = 'Ghosted'
          TabOrder = 6
        end
        object CheckBoxLink: TCheckBox
          Left = 288
          Top = 40
          Width = 97
          Height = 17
          Caption = 'Link (shortcut)'
          TabOrder = 7
        end
        object CheckBoxReadOnly: TCheckBox
          Left = 288
          Top = 88
          Width = 97
          Height = 17
          Caption = 'Read Only'
          TabOrder = 8
        end
        object CheckBoxShared: TCheckBox
          Left = 288
          Top = 120
          Width = 97
          Height = 17
          Caption = 'Shared'
          TabOrder = 9
        end
        object CheckBoxFileSystem: TCheckBox
          Left = 128
          Top = 56
          Width = 97
          Height = 17
          Caption = 'File System'
          TabOrder = 10
        end
        object CheckBoxFileSysAncestor: TCheckBox
          Left = 128
          Top = 40
          Width = 129
          Height = 17
          Caption = 'File System Ancestor'
          TabOrder = 11
        end
        object CheckBoxFolder: TCheckBox
          Left = 128
          Top = 72
          Width = 97
          Height = 17
          Caption = 'Folder'
          TabOrder = 12
        end
        object CheckBoxRemovable: TCheckBox
          Left = 288
          Top = 104
          Width = 97
          Height = 17
          Caption = 'Removable'
          TabOrder = 13
        end
        object CheckBoxHasSubFolders: TCheckBox
          Left = 128
          Top = 120
          Width = 97
          Height = 17
          Caption = 'Has Sub Folders'
          TabOrder = 14
        end
        object CheckBoxBrowsable: TCheckBox
          Left = 8
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Browsable'
          TabOrder = 15
        end
        object CheckBoxCanMoniker: TCheckBox
          Left = 8
          Top = 88
          Width = 97
          Height = 17
          Caption = 'Can Moniker'
          TabOrder = 16
        end
        object CheckBoxCompressed: TCheckBox
          Left = 8
          Top = 136
          Width = 97
          Height = 17
          Caption = 'Compressed'
          TabOrder = 17
        end
        object CheckBoxDropTarget: TCheckBox
          Left = 8
          Top = 152
          Width = 97
          Height = 17
          Caption = 'Drop Target'
          TabOrder = 18
        end
        object CheckBoxEncrypted: TCheckBox
          Left = 128
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Encrypted'
          TabOrder = 19
        end
        object CheckBoxHidden: TCheckBox
          Left = 128
          Top = 136
          Width = 97
          Height = 17
          Caption = 'Hidden'
          TabOrder = 20
        end
        object CheckBoxHasStorage: TCheckBox
          Left = 128
          Top = 152
          Width = 97
          Height = 17
          Caption = 'Has Storage'
          TabOrder = 21
        end
        object CheckBoxIsSlow: TCheckBox
          Left = 288
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Is Slow'
          TabOrder = 22
        end
        object CheckBoxNewContent: TCheckBox
          Left = 288
          Top = 56
          Width = 97
          Height = 17
          Caption = 'New Content'
          TabOrder = 23
        end
        object CheckBoxNonEnumerated: TCheckBox
          Left = 288
          Top = 72
          Width = 97
          Height = 17
          Caption = 'NonEnumerated'
          TabOrder = 24
        end
        object CheckBoxStorage: TCheckBox
          Left = 288
          Top = 136
          Width = 97
          Height = 17
          Caption = 'Storage'
          TabOrder = 25
        end
        object CheckBoxStorageAncestor: TCheckBox
          Left = 288
          Top = 152
          Width = 113
          Height = 17
          Caption = 'Storage Ancestor'
          TabOrder = 26
        end
        object CheckBoxStream: TCheckBox
          Left = 424
          Top = 24
          Width = 97
          Height = 17
          Caption = 'Stream'
          TabOrder = 27
        end
        object CheckBoxReparsePoint: TCheckBox
          Left = 424
          Top = 40
          Width = 97
          Height = 17
          Caption = 'Repase Point'
          TabOrder = 28
        end
        object CheckBoxInLibrary: TCheckBox
          Left = 424
          Top = 112
          Width = 97
          Height = 17
          Caption = 'Is In Library'
          TabOrder = 29
        end
      end
      object GroupBoxInterfaces: TGroupBox
        Left = 0
        Top = 177
        Width = 541
        Height = 104
        Align = alTop
        Caption = 'Interfaces'
        TabOrder = 1
        object CheckBoxIContextMenu: TCheckBox
          Left = 16
          Top = 16
          Width = 97
          Height = 17
          Caption = 'IContextMenu'
          TabOrder = 0
        end
        object CheckBoxIContextMenu2: TCheckBox
          Left = 16
          Top = 32
          Width = 97
          Height = 17
          Caption = 'IContextMenu2'
          TabOrder = 1
        end
        object CheckboxIContextMenu3: TCheckBox
          Left = 16
          Top = 48
          Width = 97
          Height = 17
          Caption = 'IContextMenu3'
          TabOrder = 2
        end
        object CheckboxIExtractImage: TCheckBox
          Left = 16
          Top = 64
          Width = 97
          Height = 17
          Caption = 'IExtractImage'
          TabOrder = 3
        end
        object CheckBoxIExtractImage2: TCheckBox
          Left = 16
          Top = 80
          Width = 97
          Height = 17
          Caption = 'IExtractImage2'
          TabOrder = 4
        end
        object CheckBoxIDataObject: TCheckBox
          Left = 120
          Top = 16
          Width = 97
          Height = 17
          Caption = 'IDataObject'
          TabOrder = 5
        end
        object CheckBoxIDropTarget: TCheckBox
          Left = 120
          Top = 32
          Width = 97
          Height = 17
          Caption = 'IDropTarget'
          TabOrder = 6
        end
        object CheckBoxIExtractIconA: TCheckBox
          Left = 120
          Top = 48
          Width = 97
          Height = 17
          Caption = 'IExtractIconA'
          TabOrder = 7
        end
        object CheckBoxIShellDetails: TCheckBox
          Left = 120
          Top = 80
          Width = 97
          Height = 17
          Caption = 'IShellDetails'
          TabOrder = 8
        end
        object CheckBoxIShellIcon: TCheckBox
          Left = 232
          Top = 16
          Width = 97
          Height = 17
          Caption = 'IShellIcon'
          TabOrder = 9
        end
        object CheckBoxIShellIconOverlay: TCheckBox
          Left = 232
          Top = 32
          Width = 113
          Height = 17
          Caption = 'IShellIconOverlay'
          TabOrder = 10
        end
        object CheckboxIShellLink: TCheckBox
          Left = 232
          Top = 48
          Width = 97
          Height = 17
          Caption = 'IShellLink'
          TabOrder = 11
        end
        object CheckBoxIQueryInfo: TCheckBox
          Left = 232
          Top = 64
          Width = 97
          Height = 17
          Caption = 'IQueryInfo'
          TabOrder = 12
        end
        object CheckBoxIShellFolder2: TCheckBox
          Left = 232
          Top = 80
          Width = 97
          Height = 17
          Caption = 'IShellFolder2'
          TabOrder = 13
        end
        object CheckBoxIExtractIconW: TCheckBox
          Left = 120
          Top = 64
          Width = 97
          Height = 17
          Caption = 'IExtractIconW'
          TabOrder = 14
        end
        object CheckBoxICategoryProvider: TCheckBox
          Left = 344
          Top = 16
          Width = 113
          Height = 17
          Caption = 'ICategoryProvider'
          TabOrder = 15
        end
        object CheckBoxIBrowserFrameOptions: TCheckBox
          Left = 344
          Top = 32
          Width = 137
          Height = 17
          Caption = 'IBrowserFrameOptions'
          TabOrder = 16
        end
        object CheckBoxIQueryAssociations: TCheckBox
          Left = 344
          Top = 48
          Width = 121
          Height = 17
          Caption = 'IQueryAssociations'
          TabOrder = 17
        end
        object CheckBoxIPropertyStore: TCheckBox
          Left = 344
          Top = 64
          Width = 97
          Height = 17
          Caption = 'IPropertyStore'
          TabOrder = 18
        end
      end
      object GroupBoxNameRelativeToFolder: TGroupBox
        Left = 0
        Top = 281
        Width = 541
        Height = 104
        Align = alTop
        Caption = 'Name Relative To Folder'
        TabOrder = 2
        object Label1: TLabel
          Left = 16
          Top = 16
          Width = 33
          Height = 13
          Caption = 'Normal'
        end
        object Label2: TLabel
          Left = 16
          Top = 32
          Width = 35
          Height = 13
          Caption = 'Parsing'
        end
        object Label3: TLabel
          Left = 16
          Top = 48
          Width = 55
          Height = 13
          Caption = 'Addressbar'
        end
        object Label4: TLabel
          Left = 16
          Top = 64
          Width = 93
          Height = 13
          Caption = 'Parsing Addressbar'
        end
        object Label5: TLabel
          Left = 16
          Top = 80
          Width = 32
          Height = 13
          Caption = 'Editing'
        end
        object LabelNameFolderNormal: TLabel
          Left = 120
          Top = 16
          Width = 115
          Height = 13
          Caption = 'LabelNameFolderNormal'
          PopupMenu = PopupMenu1
        end
        object LabelNameFolderParsing: TLabel
          Left = 120
          Top = 32
          Width = 117
          Height = 13
          Caption = 'LabelNameFolderParsing'
          PopupMenu = PopupMenu1
        end
        object LabelNameFolderAddressbar: TLabel
          Left = 120
          Top = 48
          Width = 137
          Height = 13
          Caption = 'LabelNameFolderAddressbar'
          PopupMenu = PopupMenu1
        end
        object LabelNameFolderParsingAddressbar: TLabel
          Left = 120
          Top = 64
          Width = 172
          Height = 13
          Caption = 'LabelNameFolderParsingAddressbar'
          PopupMenu = PopupMenu1
        end
        object LabelNameFolderEditing: TLabel
          Left = 120
          Top = 80
          Width = 114
          Height = 13
          Caption = 'LabelNameFolderEditing'
          PopupMenu = PopupMenu1
        end
      end
      object GroupBoxNameRelativeToDesktop: TGroupBox
        Left = 0
        Top = 385
        Width = 541
        Height = 105
        Align = alTop
        Caption = 'Name Relative To Desktop'
        TabOrder = 3
        object Label6: TLabel
          Left = 16
          Top = 16
          Width = 33
          Height = 13
          Caption = 'Normal'
        end
        object Label7: TLabel
          Left = 16
          Top = 32
          Width = 35
          Height = 13
          Caption = 'Parsing'
        end
        object Label8: TLabel
          Left = 16
          Top = 48
          Width = 55
          Height = 13
          Caption = 'Addressbar'
        end
        object Label9: TLabel
          Left = 16
          Top = 64
          Width = 93
          Height = 13
          Caption = 'Parsing Addressbar'
        end
        object Label10: TLabel
          Left = 16
          Top = 80
          Width = 32
          Height = 13
          Caption = 'Editing'
        end
        object LabelNameDesktopNormal: TLabel
          Left = 120
          Top = 16
          Width = 124
          Height = 13
          Caption = 'LabelNameDesktopNormal'
          PopupMenu = PopupMenu1
        end
        object LabelNameDesktopParsing: TLabel
          Left = 120
          Top = 32
          Width = 126
          Height = 13
          Caption = 'LabelNameDesktopParsing'
          PopupMenu = PopupMenu1
        end
        object LabelNameDesktopAddressbar: TLabel
          Left = 120
          Top = 48
          Width = 146
          Height = 13
          Caption = 'LabelNameDesktopAddressbar'
          PopupMenu = PopupMenu1
        end
        object LabelNameDesktopParsingAddressbar: TLabel
          Left = 120
          Top = 64
          Width = 181
          Height = 13
          Caption = 'LabelNameDesktopParsingAddressbar'
          PopupMenu = PopupMenu1
        end
        object LabelNameDesktopEditing: TLabel
          Left = 120
          Top = 80
          Width = 123
          Height = 13
          Caption = 'LabelNameDesktopEditing'
          PopupMenu = PopupMenu1
        end
      end
    end
    object TabSheetIcons: TTabSheet
      Caption = 'Icons'
      ImageIndex = 1
      object Label11: TLabel
        Left = 176
        Top = 136
        Width = 117
        Height = 13
        Caption = 'ExtraLarge Image Index'
      end
      object Label12: TLabel
        Left = 176
        Top = 152
        Width = 91
        Height = 13
        Caption = 'Large Image Index'
      end
      object Label13: TLabel
        Left = 176
        Top = 168
        Width = 88
        Height = 13
        Caption = 'Small Image Index'
      end
      object Label14: TLabel
        Left = 176
        Top = 256
        Width = 69
        Height = 13
        Caption = 'Overlay Index'
      end
      object Label17: TLabel
        Left = 176
        Top = 272
        Width = 93
        Height = 13
        Caption = 'Overlay Icon Index'
      end
      object LabelExLargeImageIndex: TLabel
        Left = 344
        Top = 32
        Width = 122
        Height = 13
        Caption = 'LabelExLargeImageIndex'
      end
      object LabelLargeImageIndex: TLabel
        Left = 344
        Top = 48
        Width = 110
        Height = 13
        Caption = 'LabelLargeImageIndex'
      end
      object LabelSmallImageIndex: TLabel
        Left = 344
        Top = 64
        Width = 107
        Height = 13
        Caption = 'LabelSmallImageIndex'
      end
      object LabelExLargeOpenImageIndex: TLabel
        Left = 344
        Top = 136
        Width = 148
        Height = 13
        Caption = 'LabelExLargeOpenImageIndex'
      end
      object LabelLargeOpenImageIndex: TLabel
        Left = 344
        Top = 152
        Width = 136
        Height = 13
        Caption = 'LabelLargeOpenImageIndex'
      end
      object LabelSmallOpenImageIndex: TLabel
        Left = 344
        Top = 168
        Width = 133
        Height = 13
        Caption = 'LabelSmallOpenImageIndex'
      end
      object Label26: TLabel
        Left = 176
        Top = 32
        Width = 117
        Height = 13
        Caption = 'ExtraLarge Image Index'
      end
      object Label27: TLabel
        Left = 176
        Top = 48
        Width = 91
        Height = 13
        Caption = 'Large Image Index'
      end
      object Label28: TLabel
        Left = 176
        Top = 64
        Width = 88
        Height = 13
        Caption = 'Small Image Index'
      end
      object LabelOverlayIndex: TLabel
        Left = 344
        Top = 256
        Width = 91
        Height = 13
        Caption = 'LabelOverlayIndex'
      end
      object LabelOverlayIconIndex: TLabel
        Left = 344
        Top = 272
        Width = 112
        Height = 13
        Caption = 'LabelOverlayIconIndex'
      end
      object GroupBoxIconNormal: TGroupBox
        Left = 8
        Top = 8
        Width = 161
        Height = 89
        Caption = 'Normal Icons'
        TabOrder = 0
        object ImageNormalExtraLarge: TImage
          Left = 9
          Top = 25
          Width = 48
          Height = 48
        end
        object ImageNormalLarge: TImage
          Left = 65
          Top = 41
          Width = 32
          Height = 32
        end
        object ImageNormalSmall: TImage
          Left = 105
          Top = 57
          Width = 16
          Height = 16
        end
      end
      object GroupBoxIconsOpen: TGroupBox
        Left = 8
        Top = 112
        Width = 161
        Height = 89
        Caption = 'Open Icons'
        TabOrder = 1
        object ImageOpenExtraLarge: TImage
          Left = 9
          Top = 25
          Width = 48
          Height = 48
        end
        object ImageOpenSmall: TImage
          Left = 105
          Top = 57
          Width = 16
          Height = 16
        end
        object ImageOpenLarge: TImage
          Left = 65
          Top = 41
          Width = 32
          Height = 32
        end
      end
      object GroupBoxIconOverlays: TGroupBox
        Left = 8
        Top = 216
        Width = 161
        Height = 97
        Caption = 'Overlays'
        TabOrder = 2
        object ImageExtraLargeOverlay: TImage
          Left = 9
          Top = 25
          Width = 48
          Height = 48
        end
        object ImageLargeOverlay: TImage
          Left = 65
          Top = 41
          Width = 32
          Height = 32
        end
        object ImageSmallOverlay: TImage
          Left = 105
          Top = 57
          Width = 16
          Height = 16
        end
      end
    end
    object TabSheetColumnDetails: TTabSheet
      Caption = 'Column Details'
      ImageIndex = 2
      DesignSize = (
        541
        489)
      object Label16: TLabel
        Left = 0
        Top = 0
        Width = 541
        Height = 13
        Align = alTop
        Caption = ' '
      end
      object Label15: TLabel
        Left = 16
        Top = 8
        Width = 74
        Height = 13
        Caption = 'Extracted with:'
      end
      object ListViewDetails: TListView
        Left = 8
        Top = 64
        Width = 529
        Height = 416
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <>
        GridLines = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object CheckBoxIShellDetailsGetDetailsOf: TCheckBox
        Left = 104
        Top = 24
        Width = 153
        Height = 17
        Caption = 'IShellDetails.GetDetailsOf'
        TabOrder = 1
      end
      object CheckBoxIShellFolder2GetDetailsOf: TCheckBox
        Left = 104
        Top = 8
        Width = 161
        Height = 17
        Caption = 'IShellFolder2.GetDetailsOf'
        TabOrder = 2
      end
      object CheckBoxDefaultGetDetailsOf: TCheckBox
        Left = 104
        Top = 40
        Width = 217
        Height = 17
        Caption = '"Default" Details through other means'
        TabOrder = 3
      end
    end
    object TabSheetExtractImage: TTabSheet
      Caption = 'Images'
      ImageIndex = 3
      object ImageExtractImage: TImage
        Left = 16
        Top = 32
        Width = 250
        Height = 250
      end
      object Label18: TLabel
        Left = 8
        Top = 296
        Width = 90
        Height = 13
        Caption = 'ExtractImage Path'
      end
      object LabelExtractImagePath: TLabel
        Left = 32
        Top = 312
        Width = 112
        Height = 13
        Caption = 'LabelExtractImagePath'
      end
      object CheckBoxExtractImageEnable: TCheckBox
        Left = 296
        Top = 32
        Width = 73
        Height = 17
        Caption = 'Enabled'
        TabOrder = 0
      end
    end
    object TabSheetQueryInfo: TTabSheet
      Caption = 'QueryInfo'
      ImageIndex = 4
      object GroupBoxQueryInfo: TGroupBox
        Left = 0
        Top = 0
        Width = 549
        Height = 113
        Align = alTop
        Caption = 'Query Info'
        TabOrder = 0
        object LabelQueryInfo: TLabel
          Left = 8
          Top = 24
          Width = 75
          Height = 13
          Caption = 'LabelQueryInfo'
        end
      end
    end
    object TabSheetCatagories: TTabSheet
      Caption = 'Catagories'
      ImageIndex = 5
      object Splitter2: TSplitter
        Left = 0
        Top = 273
        Width = 549
        Height = 6
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        ResizeStyle = rsUpdate
      end
      object Splitter3: TSplitter
        Left = 0
        Top = 410
        Width = 549
        Height = 6
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        ResizeStyle = rsUpdate
      end
      object Splitter4: TSplitter
        Left = 0
        Top = 81
        Width = 549
        Height = 6
        Cursor = crVSplit
        Align = alTop
        ResizeStyle = rsUpdate
      end
      object Panel1: TPanel
        Left = 0
        Top = 87
        Width = 549
        Height = 186
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          541
          186)
        object Label20: TLabel
          Left = 8
          Top = 6
          Width = 135
          Height = 13
          Caption = 'Category Info by Column ID'
        end
        object ListViewCategoriesByColumnID: TListView
          Left = 7
          Top = 24
          Width = 513
          Height = 154
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              Caption = 'Column'
            end
            item
              Caption = 'MapColumnToSCID - fmtid'
              Width = 250
            end
            item
              Caption = 'MapColumnToSCID - pid'
              Width = 150
            end
            item
              Caption = 'CanCategorizeOnSCID'
              Width = 100
            end
            item
              Caption = 'CategoryForSCID'
              Width = 250
            end
            item
              Caption = 'GetCategoryName'
              Width = 200
            end>
          GridLines = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 279
        Width = 541
        Height = 131
        Align = alTop
        TabOrder = 1
        DesignSize = (
          541
          131)
        object Label21: TLabel
          Left = 8
          Top = 4
          Width = 115
          Height = 13
          Caption = 'Standard Category Info'
        end
        object ListViewStandardCategories: TListView
          Left = 8
          Top = 22
          Width = 521
          Height = 97
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              Caption = 'Standard Category'
              Width = 110
            end
            item
              Caption = 'Category GUID'
              Width = 250
            end
            item
              Caption = 'GetCategoryName'
              Width = 160
            end
            item
              Caption = 'Categorizer.GetDescription'
              Width = 250
            end>
          GridLines = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 416
        Width = 541
        Height = 73
        Align = alClient
        TabOrder = 2
        DesignSize = (
          541
          73)
        object Label19: TLabel
          Left = 8
          Top = 4
          Width = 146
          Height = 13
          Caption = 'Category Info by Enumeration'
        end
        object ListViewCategoryByEnum: TListView
          Left = 8
          Top = 20
          Width = 521
          Height = 41
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              Caption = 'Category GUID'
              Width = 250
            end
            item
              Caption = 'GetCategoryName'
              Width = 250
            end>
          GridLines = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 541
        Height = 81
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 3
        DesignSize = (
          541
          81)
        object Label22: TLabel
          Left = 8
          Top = 0
          Width = 83
          Height = 13
          Caption = 'Default Category'
        end
        object ListviewDefaultCategory: TListView
          Left = 7
          Top = 16
          Width = 521
          Height = 65
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              Caption = 'MapColumnToSCID - fmtid'
              Width = 250
            end
            item
              Caption = 'MapColumnToSCID - pid'
              Width = 150
            end
            item
              Caption = 'CanCategorizeOnSCID'
              Width = 100
            end
            item
              Caption = 'CategoryForSCID'
              Width = 250
            end
            item
              Caption = 'GetCategoryName'
              Width = 200
            end>
          GridLines = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'IExtractIcon'
      ImageIndex = 6
      object Bevel2: TBevel
        Left = 8
        Top = 304
        Width = 513
        Height = 73
      end
      object Bevel1: TBevel
        Left = 8
        Top = 112
        Width = 513
        Height = 161
      end
      object Label23: TLabel
        Left = 8
        Top = 32
        Width = 145
        Height = 13
        Caption = 'IExtractIcon.GetIconLocation '
      end
      object Label24: TLabel
        Left = 24
        Top = 128
        Width = 51
        Height = 13
        Caption = 'szIconFile:'
      end
      object Label25: TLabel
        Left = 24
        Top = 144
        Width = 43
        Height = 13
        Caption = 'piIndex: '
      end
      object Label29: TLabel
        Left = 24
        Top = 160
        Width = 32
        Height = 13
        Caption = 'Flags: '
      end
      object Label30: TLabel
        Left = 88
        Top = 128
        Width = 37
        Height = 13
        Caption = 'Label30'
      end
      object Label31: TLabel
        Left = 88
        Top = 144
        Width = 37
        Height = 13
        Caption = 'Label31'
      end
      object Label45: TLabel
        Left = 8
        Top = 56
        Width = 26
        Height = 13
        Caption = 'Input'
      end
      object Label34: TLabel
        Left = 264
        Top = 184
        Width = 30
        Height = 13
        Caption = 'Result'
      end
      object Label32: TLabel
        Left = 8
        Top = 112
        Width = 34
        Height = 13
        Caption = 'Output'
      end
      object Label33: TLabel
        Left = 16
        Top = 280
        Width = 102
        Height = 13
        Caption = 'IExtractIcon.Extract '
      end
      object Image1: TImage
        Left = 24
        Top = 328
        Width = 32
        Height = 32
      end
      object Image2: TImage
        Left = 64
        Top = 336
        Width = 16
        Height = 16
      end
      object Label35: TLabel
        Left = 88
        Top = 336
        Width = 37
        Height = 13
        Caption = 'Label35'
      end
      object Label36: TLabel
        Left = 8
        Top = 304
        Width = 34
        Height = 13
        Caption = 'Output'
      end
      object CheckListBox1: TCheckListBox
        Left = 64
        Top = 164
        Width = 121
        Height = 89
        ItemHeight = 13
        TabOrder = 0
      end
      object CheckBoxGIL_FORSHELL: TCheckBox
        Left = 16
        Top = 72
        Width = 113
        Height = 17
        Caption = 'GIL_FORSHELL'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = CheckBoxGIL_xxxClick
      end
      object CheckBoxGIL_DEFAULTICON: TCheckBox
        Left = 16
        Top = 88
        Width = 121
        Height = 17
        Caption = 'GIL_DEFAULTICON'
        TabOrder = 2
        OnClick = CheckBoxGIL_xxxClick
      end
      object CheckBoxGIL_ASYNC: TCheckBox
        Left = 144
        Top = 72
        Width = 97
        Height = 17
        Caption = 'GIL_ASYNC'
        Checked = True
        State = cbChecked
        TabOrder = 3
        OnClick = CheckBoxGIL_xxxClick
      end
      object CheckBoxGIL_FORSHORTCUT: TCheckBox
        Left = 144
        Top = 88
        Width = 129
        Height = 17
        Caption = 'GIL_FORSHORTCUT'
        TabOrder = 4
        OnClick = CheckBoxGIL_xxxClick
      end
      object CheckBoxGIL_OPENICON: TCheckBox
        Left = 280
        Top = 72
        Width = 121
        Height = 17
        Caption = 'GIL_OPENICON'
        TabOrder = 5
        OnClick = CheckBoxGIL_xxxClick
      end
      object CheckBoxS_OK: TCheckBox
        Left = 272
        Top = 200
        Width = 97
        Height = 17
        Caption = 'S_OK'
        TabOrder = 6
      end
      object CheckBoxE_PENDING: TCheckBox
        Left = 272
        Top = 216
        Width = 217
        Height = 17
        Caption = 'E_PENDING (Can extract Async)'
        TabOrder = 7
      end
      object CheckBoxFailure: TCheckBox
        Left = 272
        Top = 232
        Width = 97
        Height = 17
        Caption = 'Failure Code'
        TabOrder = 8
      end
      object CheckBoxIExtractIconWAvailable: TCheckBox
        Left = 8
        Top = 8
        Width = 185
        Height = 17
        Caption = 'IExtractIconW Available'
        TabOrder = 9
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'IShellDetails'
      ImageIndex = 7
      object TreeViewShellDetails: TTreeView
        Left = 32
        Top = 32
        Width = 225
        Height = 425
        Indent = 19
        TabOrder = 0
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 804
    Height = 41
    Align = alTop
    TabOrder = 2
    object CheckBoxThreadedImages: TCheckBox
      Left = 8
      Top = 4
      Width = 113
      Height = 17
      Caption = 'Threaded Images'
      TabOrder = 0
      OnClick = CheckBoxThreadedImagesClick
    end
    object VirtualExplorerCombobox1: TVirtualExplorerCombobox
      Left = 144
      Top = 8
      Width = 641
      Active = True
      TabOrder = 1
      Path = 'VirtualExplorerCombobox1'
      VirtualExplorerTree = VET
    end
  end
  object XPManifest1: TXPManifest
    Left = 184
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 627
    Top = 458
    object CopytoClipboard1: TMenuItem
      Caption = 'Copy to Clipboard'
      OnClick = CopytoClipboard1Click
    end
  end
end

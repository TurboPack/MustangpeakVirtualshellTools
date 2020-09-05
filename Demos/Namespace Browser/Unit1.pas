unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, XPMan, ExtCtrls, VirtualTrees, VirtualExplorerTree,
  StdCtrls, MPShellUtilities, MPCommonObjects, ActiveX, ShlObj,
  MPShellTypes, MPCommonUtilities, Clipbrd,
  ComObj, CheckLst, Menus;

const
  CategoryNameList: array[0..7] of string = (
    'Alphabetical',
    'DriveSize',
    'DriveType',
    'FreeSpace',
    'Size',
    'Time',
    'Merged',
    'Default'
  );

type
  TForm1 = class(TForm)
    VET: TVirtualExplorerTree;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label17: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Splitter1: TSplitter;
    PageControlShellBrowser: TPageControl;
    XPManifest1: TXPManifest;
    TabSheetIShellFolder: TTabSheet;
    TabSheetIcons: TTabSheet;
    TabSheetColumnDetails: TTabSheet;
    TabSheetExtractImage: TTabSheet;
    TabSheetQueryInfo: TTabSheet;
    CheckBoxCanCopy: TCheckBox;
    CheckBoxCanRename: TCheckBox;
    CheckBoxCanDelete: TCheckBox;
    CheckBoxHasPropSheet: TCheckBox;
    CheckBoxCanLink: TCheckBox;
    CheckBoxCanMove: TCheckBox;
    CheckBoxIContextMenu: TCheckBox;
    CheckBoxIContextMenu2: TCheckBox;
    CheckboxIContextMenu3: TCheckBox;
    CheckboxIExtractImage: TCheckBox;
    CheckBoxIExtractImage2: TCheckBox;
    CheckBoxIDataObject: TCheckBox;
    CheckBoxIDropTarget: TCheckBox;
    CheckBoxIExtractIconA: TCheckBox;
    CheckBoxIShellDetails: TCheckBox;
    CheckBoxIShellIcon: TCheckBox;
    CheckBoxIShellIconOverlay: TCheckBox;
    CheckboxIShellLink: TCheckBox;
    CheckBoxIQueryInfo: TCheckBox;
    CheckBoxIShellFolder2: TCheckBox;
    GroupBoxInterfaces: TGroupBox;
    CheckBoxIExtractIconW: TCheckBox;
    CheckBoxGhosted: TCheckBox;
    CheckBoxLink: TCheckBox;
    CheckBoxReadOnly: TCheckBox;
    CheckBoxShared: TCheckBox;
    CheckBoxFileSystem: TCheckBox;
    CheckBoxFileSysAncestor: TCheckBox;
    CheckBoxFolder: TCheckBox;
    CheckBoxRemovable: TCheckBox;
    CheckBoxHasSubFolders: TCheckBox;
    GroupBoxCapabilities: TGroupBox;
    CheckBoxBrowsable: TCheckBox;
    CheckBoxCanMoniker: TCheckBox;
    CheckBoxCompressed: TCheckBox;
    CheckBoxDropTarget: TCheckBox;
    CheckBoxEncrypted: TCheckBox;
    CheckBoxHidden: TCheckBox;
    CheckBoxHasStorage: TCheckBox;
    CheckBoxIsSlow: TCheckBox;
    CheckBoxNewContent: TCheckBox;
    CheckBoxNonEnumerated: TCheckBox;
    CheckBoxStorage: TCheckBox;
    CheckBoxStorageAncestor: TCheckBox;
    CheckBoxStream: TCheckBox;
    GroupBoxNameRelativeToFolder: TGroupBox;
    GroupBoxNameRelativeToDesktop: TGroupBox;
    LabelNameFolderNormal: TLabel;
    LabelNameFolderParsing: TLabel;
    LabelNameFolderAddressbar: TLabel;
    LabelNameFolderParsingAddressbar: TLabel;
    LabelNameFolderEditing: TLabel;
    LabelNameDesktopNormal: TLabel;
    LabelNameDesktopParsing: TLabel;
    LabelNameDesktopAddressbar: TLabel;
    LabelNameDesktopParsingAddressbar: TLabel;
    LabelNameDesktopEditing: TLabel;
    GroupBoxIconNormal: TGroupBox;
    GroupBoxIconsOpen: TGroupBox;
    ImageNormalExtraLarge: TImage;
    ImageNormalLarge: TImage;
    ImageNormalSmall: TImage;
    ImageOpenExtraLarge: TImage;
    ImageOpenSmall: TImage;
    ImageOpenLarge: TImage;
    GroupBoxIconOverlays: TGroupBox;
    ImageExtraLargeOverlay: TImage;
    ImageLargeOverlay: TImage;
    ImageSmallOverlay: TImage;
    LabelExLargeImageIndex: TLabel;
    LabelLargeImageIndex: TLabel;
    LabelSmallImageIndex: TLabel;
    LabelExLargeOpenImageIndex: TLabel;
    LabelLargeOpenImageIndex: TLabel;
    LabelSmallOpenImageIndex: TLabel;
    LabelOverlayIndex: TLabel;
    LabelOverlayIconIndex: TLabel;
    ListViewDetails: TListView;
    Label16: TLabel;
    Label15: TLabel;
    CheckBoxIShellDetailsGetDetailsOf: TCheckBox;
    CheckBoxIShellFolder2GetDetailsOf: TCheckBox;
    CheckBoxDefaultGetDetailsOf: TCheckBox;
    ImageExtractImage: TImage;
    Label18: TLabel;
    LabelExtractImagePath: TLabel;
    GroupBoxQueryInfo: TGroupBox;
    LabelQueryInfo: TLabel;
    CheckBoxExtractImageEnable: TCheckBox;
    TabSheetCatagories: TTabSheet;
    CheckBoxICategoryProvider: TCheckBox;
    Panel1: TPanel;
    Splitter2: TSplitter;
    Label20: TLabel;
    ListViewCategoriesByColumnID: TListView;
    Panel2: TPanel;
    ListViewStandardCategories: TListView;
    Label21: TLabel;
    Splitter3: TSplitter;
    Panel3: TPanel;
    Label19: TLabel;
    ListViewCategoryByEnum: TListView;
    Panel4: TPanel;
    Label22: TLabel;
    Splitter4: TSplitter;
    ListviewDefaultCategory: TListView;
    Panel5: TPanel;
    CheckBoxThreadedImages: TCheckBox;
    CheckBoxIBrowserFrameOptions: TCheckBox;
    CheckBoxIQueryAssociations: TCheckBox;
    TabSheet1: TTabSheet;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label29: TLabel;
    CheckListBox1: TCheckListBox;
    Label30: TLabel;
    Label31: TLabel;
    Bevel1: TBevel;
    Label39: TLabel;
    Label40: TLabel;
    CheckBoxGIL_FORSHELL: TCheckBox;
    CheckBoxGIL_DEFAULTICON: TCheckBox;
    CheckBoxGIL_ASYNC: TCheckBox;
    CheckBoxGIL_FORSHORTCUT: TCheckBox;
    CheckBoxGIL_OPENICON: TCheckBox;
    Label45: TLabel;
    CheckBoxS_OK: TCheckBox;
    CheckBoxE_PENDING: TCheckBox;
    CheckBoxFailure: TCheckBox;
    Label34: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label35: TLabel;
    Bevel2: TBevel;
    Label36: TLabel;
    CheckBoxIExtractIconWAvailable: TCheckBox;
    TabSheet2: TTabSheet;
    TreeViewShellDetails: TTreeView;
    CheckBoxReparsePoint: TCheckBox;
    PopupMenu1: TPopupMenu;
    CopytoClipboard1: TMenuItem;
    CheckBoxIPropertyStore: TCheckBox;
    VirtualExplorerCombobox1: TVirtualExplorerCombobox;
    CheckBoxInLibrary: TCheckBox;
    Label37: TLabel;
    procedure VETChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxThreadedImagesClick(Sender: TObject);
    procedure CheckBoxGIL_xxxClick(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FillInfo;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function LVCFMTToStr(Format: LongWord): string;
begin
  Result := '';
  if (Format and LVCFMT_CENTER) or (Format and LVCFMT_RIGHT) = 0 then
    Result := Result + ' LVCFMT_LEFT';
  if Format and LVCFMT_CENTER <> 0 then
    Result := Result + ' LVCFMT_CENTER';
  if Format and LVCFMT_RIGHT <> 0 then
    Result := Result + ' LVCFMT_RIGHT';
  if Format and LVCFMT_COL_HAS_IMAGES <> 0 then
    Result := Result + ' LVCFMT_COL_HAS_IMAGES';
end;

{ TForm1 }

procedure TForm1.FillInfo;

const
  GIL_FORSHORTCUT = $0080;
  GIL_DEFAULTICON = $0040;

var
  Node: PVirtualNode;
  NS: TNamespace;
  Icon: TIcon;
  i: Integer;
  Item: TListItem;
  Column: TListColumn;
  EnumGUID: IEnumGUID;
  GUID: TGUID;
  Fetched: Longword;
  WS: string;
  CategoryList: array of TGUID;
  Categorizer: ICategorizer;
  ColumnID: TSHColumnID;
  IconFile: string;
  IconFileA: AnsiString;
  iIndex: INteger;
  pwFlags: Cardinal;
  Res: HRESULT;
  SmallIcon, LargeIcon: HICON;
  DetailData: TAGShellDetails;
  TreeNode: TTreeNode;

  sx: string;
begin
  Node := VET.GetFirstSelected;
  if VET.ValidateNamespace(Node, NS) then
  begin
    CheckBoxCanCopy.Checked := NS.CanCopy;
    CheckBoxCanRename.Checked := NS.CanRename;
    CheckBoxCanDelete.Checked := NS.CanDelete;
    CheckBoxHasPropSheet.Checked := NS.HasPropSheet;
    CheckBoxCanLink.Checked := NS.CanLink;
    CheckBoxCanMove.Checked := NS.CanMove;
    CheckBoxGhosted.Checked := NS.Ghosted;
    CheckBoxLink.Checked := NS.Link;
    CheckBoxReadOnly.Checked := NS.ReadOnly;
    CheckBoxShared.Checked := NS.Share;
    CheckBoxFileSystem.Checked := NS.FileSystem;
    CheckBoxFileSysAncestor.Checked := NS.FileSysAncestor;
    CheckBoxFolder.Checked := NS.Folder;
    CheckBoxRemovable.Checked := NS.Removable;
    CheckBoxHasSubFolders.Checked := NS.HasSubFolder;
    CheckBoxBrowsable.Checked := NS.Browsable;
    CheckBoxCanMoniker.Checked := NS.CanMoniker;
    CheckBoxCompressed.Checked := NS.Compressed;
    CheckBoxDropTarget.Checked := NS.DropTarget;
    CheckBoxEncrypted.Checked := NS.Encrypted;
    CheckBoxHidden.Checked := NS.Hidden;
    CheckBoxHasStorage.Checked := NS.HasStorage;
    CheckBoxIsSlow.Checked := NS.IsSlow;
    CheckBoxNewContent.Checked := NS.NewContent;
    CheckBoxNonEnumerated.Checked := NS.NonEnumerated;
    CheckBoxStorage.Checked := NS.Storage;
    CheckBoxStorageAncestor.Checked := NS.StorageAncestor;
    CheckBoxStream.Checked := NS.Stream;
    CheckBoxReparsePoint.Checked := NS.ReparsePoint;

    CheckBoxIContextMenu.Checked := Assigned(NS.ContextMenuInterface);
    CheckBoxIContextMenu2.Checked := Assigned(NS.ContextMenu2Interface);
    CheckboxIContextMenu3.Checked := Assigned(NS.ContextMenu3Interface);
    CheckboxIExtractImage.Checked := Assigned(NS.ExtractImage.ExtractImageInterface);
    CheckBoxIExtractImage2.Checked := Assigned(NS.ExtractImage.ExtractImage2Interface);
    CheckBoxIDataObject.Checked := Assigned(NS.DataObjectInterface);
    CheckBoxIDropTarget.Checked := Assigned(NS.DropTargetInterface);
    CheckBoxIExtractIconA.Checked := Assigned(NS.ExtractIconAInterface);
    CheckBoxIExtractIconW.Checked := Assigned(NS.ExtractIconWInterface);
    CheckBoxIShellDetails.Checked := Assigned(NS.ShellDetailsInterface);
    CheckBoxIShellIcon.Checked := Assigned(NS.ShellIconInterface);
    CheckboxIShellLink.Checked := Assigned(NS.ShellLink);
    CheckBoxIShellIconOverlay.Checked := Assigned(NS.ShellIconOverlayInterface);
    CheckBoxIQueryInfo.Checked := Assigned(NS.QueryInfoInterface);
    CheckBoxIShellFolder2.Checked := Assigned(NS.ShellFolder2);
    CheckBoxICategoryProvider.Checked := Assigned(NS.CategoryProviderInterface);
    CheckBoxIBrowserFrameOptions.Checked := Assigned(NS.BrowserFrameOptionsInterface);
    CheckBoxIQueryAssociations.Checked := Assigned(NS.QueryAssociationsInterface);
    CheckBoxIPropertyStore.Checked := Assigned(NS.PropertyStoreInterface);
    CheckBoxInLibrary.Checked := NS.IsLibraryChild;

    Label30.Caption := '';
    Label31.Caption := '';
    CheckListBox1.Items.Clear;
    CheckboxE_PENDING.Checked := False;
    CheckboxS_OK.Checked := False;
    CheckboxFailure.Checked := False;
    CheckBoxIExtractIconWAvailable.Checked := Assigned(NS.ExtractIconWInterface);

    TreeViewShellDetails.Items.BeginUpdate;
    try
      TreeViewShellDetails.Items.Clear;
      if Assigned(NS.ShellDetailsInterface) then
      begin
        i := 0;
        ZeroMemory(@DetailData, SizeOf(DetailData));
        while (NS.ShellDetailsInterface.GetDetailsOf(nil, i, DetailData) = S_OK) and (i < 1000) do
        begin
          TreeNode := TreeViewShellDetails.Items.AddChild(nil, 'Column: ' + IntToStr(i));
          TreeViewShellDetails.Items.AddChild(TreeNode, 'Format: ' +  LVCFMTToStr(DetailData.Fmt));
          TreeViewShellDetails.Items.AddChild(TreeNode, 'cxChar: ' +  IntToStr(DetailData.cxChar));
          TreeViewShellDetails.Items.AddChild(TreeNode, 'Caption: ' +  StrRetToStr(DetailData.str, nil));
          ZeroMemory(@DetailData, SizeOf(DetailData));
          Inc(i);
        end;
      end else
      begin
        if Assigned(NS.ShellFolder2) then
        begin
          i := 0;
          NS.DetailsOf(i) ;
          ZeroMemory(@DetailData, SizeOf(DetailData));
          while (NS.ShellFolder2.GetDetailsOf(nil, i, DetailData) = S_OK) and (i < 1000) do
          begin
            TreeNode := TreeViewShellDetails.Items.AddChild(nil, 'Column: ' + IntToStr(i));
            TreeViewShellDetails.Items.AddChild(TreeNode, 'Format: ' +  LVCFMTToStr(DetailData.Fmt));
            TreeViewShellDetails.Items.AddChild(TreeNode, 'cxChar: ' +  IntToStr(DetailData.cxChar));
            TreeViewShellDetails.Items.AddChild(TreeNode, 'Caption: ' +  StrRetToStr(DetailData.str, nil));
            ZeroMemory(@DetailData, SizeOf(DetailData));
            Inc(i);
          end;
        end
      end;
      TreeViewShellDetails.FullExpand;
    finally
      TreeViewShellDetails.Items.EndUpdate
    end;

    if Assigned(NS.ExtractIconWInterface) then
    begin
      SetLength(IconFile, 260);
      ZeroMemory(@IconFile[1], Length(IconFile) * 2);
      iIndex := -1;
      pwFlags := 0;

      if CheckboxGIL_FORSHELL.Checked then
        pwFlags := pwFlags or GIL_FORSHELL;
      if CheckboxGIL_DEFAULTICON.Checked then
        pwFlags := pwFlags or GIL_DEFAULTICON;
      if CheckboxGIL_ASYNC.Checked then
        pwFlags := pwFlags or GIL_ASYNC;
      if CheckboxGIL_OPENICON.Checked then
        pwFlags := pwFlags or GIL_OPENICON;
      if CheckboxGIL_FORSHORTCUT.Checked then
        pwFlags := pwFlags or GIL_FORSHORTCUT;

      Res := NS.ExtractIconWInterface.GetIconLocation(pwFlags, PWideChar(IconFile), Length(IconFile), iIndex, pwFlags);

      Label30.Caption := IconFile;
      Label31.Caption := IntToStr(iIndex) + '   (Hex = ' + IntToHex(iIndex, 8) + ')';
      CheckListBox1.Items.Clear;
      if pwFlags and GIL_SIMULATEDOC <> 0 then
        CheckListBox1.Items.Add('GIL_SIMULATEDOC');
      if pwFlags and GIL_PERINSTANCE <> 0 then
        CheckListBox1.Items.Add('GIL_PERINSTANCE');
      if pwFlags and GIL_PERCLASS <> 0 then
        CheckListBox1.Items.Add('GIL_PERCLASS');
      if pwFlags and GIL_NOTFILENAME <> 0 then
        CheckListBox1.Items.Add('GIL_NOTFILENAME');
      if pwFlags and GIL_DONTCACHE <> 0 then
        CheckListBox1.Items.Add('GIL_DONTCACHE');

      if Res = E_PENDING then
        CheckboxE_PENDING.Checked := True
      else
      if Res = S_OK then
        CheckboxS_OK.Checked := True
      else
        CheckboxFailure.Checked := True;


      SmallIcon := 0;
      LargeIcon := 0;
      Res := NS.ExtractIconWInterface.Extract(PWideChar(IconFile), iIndex, LargeIcon, SmallIcon, MakeLong(32, 16));
      if Res = NOERROR then
        Label35.Caption := 'Interface Extracted Images'
      else
        Label35.Caption := 'Interface said "Extract it yourself!"';

      Image1.Canvas.Brush.Color := clWhite;
      Image1.Canvas.FillRect(Image1.ClientRect);
      Image2.Canvas.FillRect(Image2.ClientRect);
      Icon := TIcon.Create;
      try
        if LargeIcon > 0 then
        begin
          Icon.Handle := LargeIcon;
          Image1.Canvas.Draw(0, 0, Icon);
          Icon.Handle := 0;
        end;
        if SmallIcon > 0 then
        begin
          Icon.Handle := SmallIcon;
          Image2.Canvas.Draw(0, 0, Icon);
          Icon.Handle := 0;
        end
      finally
        Icon.Free
      end

    end else
    if Assigned(NS.ExtractIconAInterface) then
    begin
      SetLength(IconFileA, 260);
      ZeroMemory(@IconFileA[1], Length(IconFileA));
      iIndex := -1;
      pwFlags := 0;

      if CheckboxGIL_FORSHELL.Checked then
        pwFlags := pwFlags or GIL_FORSHELL;
      if CheckboxGIL_DEFAULTICON.Checked then
        pwFlags := pwFlags or GIL_DEFAULTICON;
      if CheckboxGIL_ASYNC.Checked then
        pwFlags := pwFlags or GIL_ASYNC;
      if CheckboxGIL_OPENICON.Checked then
        pwFlags := pwFlags or GIL_OPENICON;
      if CheckboxGIL_FORSHORTCUT.Checked then
        pwFlags := pwFlags or GIL_FORSHORTCUT;

      Res := NS.ExtractIconAInterface.GetIconLocation(pwFlags, PAnsiChar(IconFileA), Length(IconFileA), iIndex, pwFlags);

      Label30.Caption := IconFileA;
      Label31.Caption := IntToStr(iIndex) + '   (Hex = ' + IntToHex(iIndex, 8) + ')';
      CheckListBox1.Items.Clear;
      if pwFlags and GIL_SIMULATEDOC <> 0 then
        CheckListBox1.Items.Add('GIL_SIMULATEDOC');
      if pwFlags and GIL_PERINSTANCE <> 0 then
        CheckListBox1.Items.Add('GIL_PERINSTANCE');
      if pwFlags and GIL_PERCLASS <> 0 then
        CheckListBox1.Items.Add('GIL_PERCLASS');
      if pwFlags and GIL_NOTFILENAME <> 0 then
        CheckListBox1.Items.Add('GIL_NOTFILENAME');
      if pwFlags and GIL_DONTCACHE <> 0 then
        CheckListBox1.Items.Add('GIL_DONTCACHE');

      if Res = E_PENDING then
        CheckboxE_PENDING.Checked := True
      else
      if Res = S_OK then
        CheckboxS_OK.Checked := True
      else
        CheckboxFailure.Checked := True;


      SmallIcon := 0;
      LargeIcon := 0;
      Res := NS.ExtractIconAInterface.Extract(PAnsiChar((IconFileA)), iIndex, LargeIcon, SmallIcon, MakeLong(32, 16));
      if Res = NOERROR then
        Label35.Caption := 'Interface Extracted Images'
      else
        Label35.Caption := 'Interface said "Extract it yourself!"';

      Image1.Canvas.Brush.Color := clWhite;
      Image1.Canvas.FillRect(Image1.ClientRect);
      Image2.Canvas.FillRect(Image2.ClientRect);
      Icon := TIcon.Create;
      try
        if LargeIcon > 0 then
        begin
          Icon.Handle := LargeIcon;
          Image1.Canvas.Draw(0, 0, Icon);
          Icon.Handle := 0;
        end;
        if SmallIcon > 0 then
        begin
          Icon.Handle := SmallIcon;
          Image2.Canvas.Draw(0, 0, Icon);
          Icon.Handle := 0;
        end
      finally
        Icon.Free
      end

    end;



    LabelNameFolderNormal.Caption := NS.NameInFolder;
    LabelNameFolderParsing.Caption := NS.NameForParsingInFolder;
    LabelNameFolderAddressbar.Caption := NS.NameAddressbarInFolder;
    LabelNameFolderParsingAddressbar.Caption := NS.NameParseAddressInFolder;
    LabelNameFolderEditing.Caption := NS.NameForEditingInFolder;
    LabelNameDesktopNormal.Caption := NS.NameNormal;
    LabelNameDesktopParsing.Caption := NS.NameForParsing;
    LabelNameDesktopAddressbar.Caption := NS.NameAddressbar;
    LabelNameDesktopParsingAddressbar.Caption := NS.NameParseAddress;
    LabelNameDesktopEditing.Caption := NS.NameForEditing;


    Icon := TIcon.Create;
    try
      if ExtraLargeSysImages <> nil then
      begin
        ExtraLargeSysImages.GetIcon(NS.GetIconIndex(False, icLarge), Icon);
        ImageNormalExtraLarge.Picture.Icon := Icon;
        ExtraLargeSysImages.GetIcon(NS.GetIconIndex(True, icLarge), Icon);
        ImageOpenExtraLarge.Picture.Icon := Icon;
        if NS.OverlayIconIndex > -1 then
        begin
          ExtraLargeSysImages.GetIcon(NS.OverlayIconIndex, Icon);
          ImageExtraLargeOverlay.Picture.Icon := Icon;
        end else
          ImageExtraLargeOverlay.Picture.Icon := nil;

        LabelExLargeImageIndex.Caption := IntToStr(NS.GetIconIndex(False, icLarge));
        LabelExLargeOpenImageIndex.Caption := IntToStr(NS.GetIconIndex(True, icLarge));
      end;
      if LargeSysImages <> nil then
      begin
        LargeSysImages.GetIcon(NS.GetIconIndex(False, icLarge), Icon);
        ImageNormalLarge.Picture.Icon := Icon;
        LargeSysImages.GetIcon(NS.GetIconIndex(True, icLarge), Icon);
        ImageOpenLarge.Picture.Icon := Icon;
        if NS.OverlayIconIndex > -1 then
        begin
          LargeSysImages.GetIcon(NS.OverlayIconIndex, Icon);
          ImageLargeOverlay.Picture.Icon := Icon;
        end else
          ImageLargeOverlay.Picture.Icon := nil;

        LabelLargeImageIndex.Caption := IntToStr(NS.GetIconIndex(False, icLarge));
        LabelLargeOpenImageIndex.Caption := IntToStr(NS.GetIconIndex(True, icLarge));
      end;
      if SmallSysImages <> nil then
      begin
        SmallSysImages.GetIcon(NS.GetIconIndex(False, icSmall), Icon);
        ImageNormalSmall.Picture.Icon := Icon;
        SmallSysImages.GetIcon(NS.GetIconIndex(True, icSmall), Icon);
        ImageOpenSmall.Picture.Icon := Icon;
        if NS.OverlayIconIndex > -1 then
        begin
          SmallSysImages.GetIcon(NS.OverlayIconIndex, Icon);
          ImageSmallOverlay.Picture.Icon := Icon;
        end else
          ImageSmallOverlay.Picture.Icon := nil;

        LabelSmallImageIndex.Caption := IntToStr(NS.GetIconIndex(False, icSmall));
        LabelSmallOpenImageIndex.Caption := IntToStr(NS.GetIconIndex(True, icSmall));
      end;

      LabelOverlayIndex.Caption := IntToStr(NS.OverlayIndex);
      LabelOverlayIconIndex.Caption := IntToStr(NS.OverlayIconIndex);

      ListViewDetails.Items.Clear;
      ListViewDetails.Columns.Clear;

      Column := ListViewDetails.Columns.Add;
      Column.Caption := 'Column';
      Column.Width := 50;
      Column := ListViewDetails.Columns.Add;
      Column.Caption := 'Detail Title';
      Column.Width := 140;
      Column := ListViewDetails.Columns.Add;
      Column.Caption := 'Detail';
      Column.Width := 250;
      Column := ListViewDetails.Columns.Add;
      Column.Caption := 'Alignment';
      Column.Width := 100;

      for i := 0 to NS.DetailsSupportedColumns - 1 do
      begin
        Item := ListViewDetails.Items.Add;
        Item.Caption := IntToStr(i);
        if Assigned(NS.Parent) then
          Item.SubItems.Add(NS.Parent.DetailsColumnTitle(i))
        else
          Item.SubItems.Add(' ');
        Item.SubItems.Add(NS.DetailsOf(i));
        case NS.DetailsAlignment(i) of
          taCenter: Item.SubItems.Add('Center');
          taLeftJustify: Item.SubItems.Add('Left');
          taRightJustify: Item.SubItems.Add('Right');
      //    tiContainsImage: Item.SubItems.Add('Contains Image');
        end
      end;

      CheckBoxIShellFolder2GetDetailsOf.Checked := False;
      CheckBoxIShellDetailsGetDetailsOf.Checked := False;
      CheckBoxIShellFolder2GetDetailsOf.Checked := Assigned(NS.ShellFolder2);
      if not CheckBoxIShellFolder2GetDetailsOf.Checked then
        CheckBoxIShellDetailsGetDetailsOf.Checked := Assigned(NS.ShellDetailsInterface);

      if Assigned(NS.ExtractImage.ExtractImageInterface) then
      begin
        if CheckBoxExtractImageEnable.Checked then
        begin
          NS.ExtractImage.Width := ImageExtractImage.Width;
          NS.ExtractImage.Height := ImageExtractImage.Height;
          NS.ExtractImage.ColorDepth := 32;
          LabelExtractImagePath.Caption := NS.ExtractImage.ImagePath;
          ImageExtractImage.Picture.Bitmap := NS.ExtractImage.Image
        end else
          LabelExtractImagePath.Caption := 'Extraction Not Enabled';
      end else
        LabelExtractImagePath.Caption := 'IExtractImage not Supported';

      if Assigned(NS.QueryInfoInterface) then
        LabelQueryInfo.Caption := NS.InfoTip
      else
        LabelQueryInfo.Caption := 'IQueryInfo Not Supported';
    finally
      Icon.Free
    end;


    ListViewStandardCategories.Items.BeginUpdate;
    ListViewCategoriesByColumnID.Items.BeginUpdate;
    ListViewCategoryByEnum.Items.BeginUpdate;
    ListViewDefaultCategory.Items.BeginUpdate;
    try
      ListViewStandardCategories.Items.Clear;
      ListViewCategoriesByColumnID.Clear;
      ListViewCategoryByEnum.Clear;
      ListViewDefaultCategory.Clear;

      if Assigned(NS.CategoryProviderInterface) then
      begin
        SetLength(WS, 256);

        // Find the dEfault Category
        ZeroMemory(@ColumnID, SizeOf(ColumnID));
        GUID := GUID_NULL;
        if Succeeded(NS.CategoryProviderInterface.GetDefaultCategory(GUID, ColumnID)) then
        begin
          Item := ListviewDefaultCategory.Items.Add;
          Item.Caption := (GUIDToString(ColumnID.fmtid));
          Item.SubItems.Add(IntToStr(ColumnID.pid));

          if Succeeded(NS.CategoryProviderInterface.CanCategorizeOnSCID(ColumnID)) then
            begin
              Item.SubItems.Add('True');
              if Succeeded(NS.CategoryProviderInterface.GetCategoryForSCID(ColumnID, GUID)) then
              begin
                Item.SubItems.Add(GUIDToString(GUID));
                ZeroMemory(@WS[1], Length(WS) * 2);
                if Succeeded(NS.CategoryProviderInterface.GetCategoryName(GUID, PWideChar(WS), 128)) then
                  Item.SubItems.Add(WS)
                else begin
                  Item.SubItems.Add('[Not Available]');
                end
              end else
              begin
                Item.SubItems.Add('[Not Available]');
                Item.SubItems.Add('[Not Available]');
              end
            end else
            begin
              Item.SubItems.Add('False');
              Item.SubItems.Add('[Not Available]');
              Item.SubItems.Add('[Not Available]');
              Item.SubItems.Add('[Not Available]');
            end;
          end;

        // Use IShellFolder2 to Extract Category info though the Columns
        if Assigned(NS.ShellFolder2) then
        begin
          i := 0;
          ZeroMemory(@ColumnID, SizeOf(ColumnID));
          GUID := GUID_NULL;
          while Succeeded(NS.ShellFolder2.MapColumnToSCID(i, ColumnID)) do
          begin
            Item := ListViewCategoriesByColumnID.Items.Add;
            Item.Caption := IntToStr(i);
            Item.SubItems.Add(GUIDToString(ColumnID.fmtid));
            Item.SubItems.Add(IntToStr(ColumnID.pid));
            if Succeeded(NS.CategoryProviderInterface.CanCategorizeOnSCID(ColumnID)) then
            begin
              Item.SubItems.Add('True');
              if Succeeded(NS.CategoryProviderInterface.GetCategoryForSCID(ColumnID, GUID)) then
              begin
               Item.SubItems.Add(GUIDToString(GUID));
               ZeroMemory(@WS[1], Length(WS) * 2);
               if Succeeded(NS.CategoryProviderInterface.GetCategoryName(GUID, PWideChar(WS), 128)) then
                 Item.SubItems.Add(WS)
               else begin
                 Item.SubItems.Add('[Not Available]');
               end
              end else
              begin
                Item.SubItems.Add('[Not Available]');
                Item.SubItems.Add('[Not Available]');
              end
            end else
            begin
              Item.SubItems.Add('False');
              Item.SubItems.Add('[Not Available]');
              Item.SubItems.Add('[Not Available]');
              Item.SubItems.Add('[Not Available]');
            end;
            ZeroMemory(@ColumnID, SizeOf(ColumnID));
            GUID := GUID_NULL;
            Inc(i)
          end
        end;

        // Get any custom categories through enumeration
        NS.CategoryProviderInterface.EnumCategories(EnumGUID);
        if Assigned(EnumGUID) then
        begin
          while EnumGUID.Next(1, GUID, Fetched) = NOERROR do
          begin
            Item := ListViewCategoryByEnum.Items.Add;
            Item.Caption := GUIDToString(GUID);
              if Succeeded(NS.CategoryProviderInterface.GetCategoryName(GUID, PWideChar(WS), 256)) then
                Item.SubItems.Add(WS)
              else
                Item.SubItems.Add('[Not Available]');
          end
        end;

        SetLength(CategoryList, 8);
        CategoryList[0] := CLSID_AlphabeticalCategorizer;
        CategoryList[1] := CLSID_DriveSizeCategorizer;
        CategoryList[2] := CLSID_DriveTypeCategorizer;
        CategoryList[3] := CLSID_FreeSpaceCategorizer;
        CategoryList[4] := CLSID_SizeCategorizer;
        CategoryList[5] := CLSID_TimeCategorizer;
        CategoryList[6] := CLSID_MergedCategorizer;
        CategoryList[7] := CLSID_DefCategoryProvider;

        for i := 0 to Length(CategoryList) - 1 do
        begin
          ZeroMemory(@WS[1], Length(WS) * 2);
          Item := ListViewStandardCategories.Items.Add;
          Item.Caption := CategoryNameList[i];
          Item.SubItems.Add(GUIDToString(CategoryList[i]));
          if Succeeded(NS.CategoryProviderInterface.GetCategoryName(CategoryList[i], PWideChar(WS), 256)) then
          begin
            Item.SubItems.Add(WS);
            if Succeeded(NS.CategoryProviderInterface.CreateCategory(CategoryList[i], IID_ICategorizer, Categorizer)) then
            begin
              Categorizer.GetDescription(PWideChar(WS), 256);
              Item.SubItems.Add(WS);
            end else
            begin
              Item.SubItems.Add('[Not Available]');
            end
          end else
          begin
            Item.SubItems.Add('[Not Available]');
            Item.SubItems.Add('[Not Available]');
          end
        end
      end
    finally
      ListViewDefaultCategory.Items.EndUpdate;
      ListViewCategoryByEnum.Items.EndUpdate;
      ListViewStandardCategories.Items.EndUpdate;
      ListViewCategoriesByColumnID.Items.EndUpdate
    end
  end
end;

procedure TForm1.VETChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  FillInfo
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  VET.Selected[VET.GetFirst] := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // PageControlShellBrowser.DoubleBuffered := True;
 // Form1.DoubleBuffered := True
end;

procedure TForm1.CheckBoxThreadedImagesClick(Sender: TObject);
begin
  if CheckBoxThreadedImages.Checked then
    VET.TreeOptions.VETImageOptions := VET.TreeOptions.VETImageOptions + [toThreadedImages]
  else
    VET.TreeOptions.VETImageOptions := VET.TreeOptions.VETImageOptions - [toThreadedImages]
end;

procedure TForm1.CheckBoxGIL_xxxClick(Sender: TObject);
begin
  FillInfo
end;

procedure TForm1.CopytoClipboard1Click(Sender: TObject);
begin
  Clipboard.Clear;
  Clipboard.SetTextBuf(  PChar((((Sender as TMenuItem).GetParentMenu as TPopupMenu).PopupComponent as TLabel).Caption));
end;

end.

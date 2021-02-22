unit InfoForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MPShellUtilities, ComCtrls, ExtCtrls, ImgList, ShlObj, ShellAPI,
  ActiveX, ComObj, ToolWin, System.ImageList;

type
  TFormInfo = class(TForm)
    PageContol1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ImageListSmall: TImageList;
    ImageListLarge: TImageList;
    TabSheet4: TTabSheet;
    Label21: TLabel;
    TabSheet5: TTabSheet;
    Label22: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    GroupBox9: TGroupBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox13: TCheckBox;
    GroupBox7: TGroupBox;
    CheckBox29: TCheckBox;
    CheckBox30: TCheckBox;
    CheckBox31: TCheckBox;
    CheckBox32: TCheckBox;
    CheckBox33: TCheckBox;
    CheckBox34: TCheckBox;
    CheckBox35: TCheckBox;
    CheckBox36: TCheckBox;
    CheckBox37: TCheckBox;
    GroupBox8: TGroupBox;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label51: TLabel;
    Label50: TLabel;
    Label49: TLabel;
    GroupBox10: TGroupBox;
    Label24: TLabel;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Label1: TLabel;
    GroupBox13: TGroupBox;
    ListBox1: TListBox;
    GroupBox14: TGroupBox;
    ListBox2: TListBox;
    GroupBox15: TGroupBox;
    GroupBox16: TGroupBox;
    Label7: TLabel;
    Label18: TLabel;
    GroupBox17: TGroupBox;
    GroupBox18: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    GroupBox19: TGroupBox;
    Image3: TImage;
    Image4: TImage;
    GroupBox20: TGroupBox;
    Label62: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image5: TImage;
    Label6: TLabel;
    CheckBox38: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateInfo(NS: TNamespace);
  end;

var
  FormInfo: TFormInfo;

implementation

{$R *.DFM}

{ TFormInfo }

procedure TFormInfo.UpdateInfo(NS: TNamespace);
var
  Count, Index: Integer;
  Icon: TIcon;
begin
  // IShellDetails Info
  if NS.AdvDetailsSupported then
  begin
    Count := NS.DetailsSupportedColumns;
    Label1.Caption := 'Folder Supports ' + IntToStr(Count) + ' Columns';
    ListBox1.Enabled := True;
    ListBox1.Items.Clear;
    for Index := 0 to Count - 1 do
      ListBox1.Items.Add( NS.DetailsColumnTitle(Index));
  end else
  begin
    ListBox1.Items.Clear;
    ListBox1.Enabled := False;
    Label1.Caption := 'Folder IShellDetails and IShellFolder2 Unsupported';
  end;

  if NS.AdvDetailsSupported then
  begin
    Count := NS.Parent.DetailsSupportedColumns;
    Label6.Caption := 'Parent Supports ' + IntToStr(Count) + ' Columns';
    ListBox2.Enabled := True;
    ListBox2.Items.Clear;
    for Index := 0 to Count - 1 do
      ListBox2.Items.Add( NS.DetailsOf(Index))
  end else
  begin
    ListBox2.Items.Clear;
    ListBox2.Enabled := False;
    Label6.Caption := 'Parent IShellDetails and IShellFolder2 Unsupported';
  end;

  // IShellFolder info
  CheckBox2.Checked := NS.CanCopy;
  CheckBox3.Checked := NS.CanDelete;
  CheckBox4.Checked := NS.CanLink;
  CheckBox5.Checked := NS.CanMove;
  CheckBox6.Checked := NS.CanRename;
  CheckBox7.Checked := NS.DropTarget;
  CheckBox8.Checked := NS.HasPropSheet;
  CheckBox9.Checked := NS.Ghosted;
  CheckBox10.Checked := NS.Link;
  CheckBox11.Checked := NS.ReadOnly;
  CheckBox12.Checked := NS.Share;
  CheckBox13.Checked := NS.HasSubFolder;
  CheckBox14.Checked := NS.FileSystem;
  CheckBox15. Checked := NS.FileSysAncestor;
  CheckBox16.Checked := NS.Folder;
  CheckBox17.Checked := NS.Removable;

  Label11.Caption := NS.NameNormal;
  Label13.Caption := NS.NameForParsing;
  Label14.Caption := NS.NameAddressbar;
  Label17.Caption := NS.NameParseAddress;
  Label34.Caption := NS.NameForEditing;

  Label25.Caption := NS.NameInFolder;
  Label28.Caption := NS.NameForParsingInFolder;
  Label26.Caption := NS.NameAddressbarInFolder;
  Label27.Caption := NS.NameParseAddressInFolder;
  Label35.Caption := NS.NameForEditingInFolder;

  // Supported COM interfaces
  CheckBox38.Checked := Assigned(NS.ShellFolder2);
  CheckBox18.Checked := Assigned(NS.ContextMenuInterface);
  CheckBox19.Checked := Assigned(NS.ContextMenu2Interface);
  CheckBox20.Checked := Assigned(NS.DataObjectInterface);
  CheckBox21.Checked := Assigned(NS.DropTargetInterface);
  CheckBox22.Checked := Assigned(NS.ExtractIconAInterface) or Assigned(NS.ExtractIconWInterface);
  CheckBox24.Checked := Assigned(NS.ShellDetailsInterface);
  CheckBox23.Checked := Assigned(NS.QueryInfoInterface);
  CheckBox25.Checked := Assigned(NS.ContextMenu3Interface);
  CheckBox28.Checked := Assigned(NS.ShellLink) and Assigned(NS.ShellLink.ShellLinkWInterface);
  CheckBox26.Checked := Assigned(NS.ExtractImage) and Assigned(NS.ExtractImage.ExtractImageInterface);
  CheckBox27.Checked := Assigned(NS.ExtractImage) and Assigned(NS.ExtractImage.ExtractImage2Interface);
  CheckBox1.Checked := Assigned(NS.ShellIconInterface);


  // GetDataFromIDList and FindFirst info (info on physical file folders
  CheckBox29.Checked := NS.Archive;
  CheckBox30.Checked := NS.Compressed;
  CheckBox31.Checked := NS.Directory;
  CheckBox32.Checked := NS.Hidden;
  CheckBox33.Checked := NS.Normal;
  CheckBox34.Checked := NS.OffLine;
  CheckBox35.Checked := NS.ReadOnlyFile;
  CheckBox36.Checked := NS.SystemFile;
  CheckBox37.Checked := NS.Temporary;

  Label41.Caption := NS.CreationTime;
  Label42.Caption := NS.LastAccessTime;
  Label43.Caption := NS.LastWriteTime;
  Label44.Caption := NS.SizeOfFile;
  Label45.Caption := NS.SizeOfFileKB;

  // Icon Info (SHGetFileInfo)
  Icon := TIcon.Create;
  try
    ImageListSmall.GetIcon(NS.GetIconIndex(False, icSmall), Icon);
    Image1.Picture.Icon := Icon;
    ImageListSmall.GetIcon(NS.GetIconIndex(True, icSmall), Icon);
    Image3.Picture.Icon := Icon;
    ImageListLarge.GetIcon(NS.GetIconIndex(False, icLarge), Icon);
    Image2.Picture.Icon := Icon;
    ImageListLarge.GetIcon(NS.GetIconIndex(True, icLarge), Icon);
    Image4.Picture.Icon := Icon;
  finally
    Icon.Free;
  end;
  Label24.Caption := NS.FileType;


  // IExtractImage Info (If someone knows how to make this work please let me know)
  Label18.Caption := NS.ExtractImage.ImagePath;
  Image5.Picture.Bitmap.Assign(nil);
  Image5.Width := 0;
  Image5.Height := 0;
  if not Assigned(NS.ExtractImage.ExtractImageInterface) then
    Label18.Caption := 'IExtractImage not supported!'
  else
   if Label18.Caption = '' then
     Label18.Caption := 'Image Path not available'
  else
    if FileExists(Label18.Caption) then
    begin
      Image5.Picture.Bitmap.Assign(NS.ExtractImage.Image);
      Image5.Width := Image5.Picture.Bitmap.Width;
      Image5.Height := Image5.Picture.Bitmap.Height;
    end;


  // IQueryInfo
  Label62.Caption := NS.InfoTip;
  if not Assigned(NS.QueryInfoInterface) then
    Label62.Caption := 'IQueryInfo not supported!'
  else
  if Label62.Caption = '' then
    Label62.Caption := 'No Tip available!';
end;

procedure TFormInfo.FormCreate(Sender: TObject);
var
  Info: TSHFILEINFO;
begin
  ImageListSmall.Handle := SHGetFileInfo('c:\', 0, Info, SizeOf(Info),
    SHGFI_SYSICONINDEX or SHGFI_SHELLICONSIZE or SHGFI_SMALLICON);
  ImageListLarge.Handle := SHGetFileInfo('c:\', 0, Info, SizeOf(Info),
    SHGFI_SYSICONINDEX or SHGFI_LARGEICON or SHGFI_SHELLICONSIZE);
  ImageListSmall.ShareImages := True;
  ImageListLarge.ShareImages := True;
end;

end.

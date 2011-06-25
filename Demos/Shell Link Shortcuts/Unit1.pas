unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, VirtualExplorerTree, MPShellUtilities, ExtCtrls, StdCtrls, Buttons,
  MPCommonUtilities;

type
  TForm1 = class(TForm)
    VirtualExplorerTree1: TVirtualExplorerTree;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    RadioGroup1: TRadioGroup;
    BitBtn1: TBitBtn;
    VirtualShellLink1: TVirtualShellLink;
    procedure VirtualExplorerTree1EnumFolder(
      Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
      var AllowAsChild: Boolean);
    procedure VirtualExplorerTree1Change(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function ShowCmdToStr(Cmd: TCmdShow): WideString;
begin
  case Cmd of
    swHide: Result := 'SW_HIDE';
    swMaximize: Result := 'SW_MAXIMIZE';
    swMinimize: Result := 'SW_MINIMIZE';
    swRestore: Result := 'SW_RESTORE';
    swShow: Result := 'SW_SHOW';
    swShowDefault: Result := 'SW_SHOWDEFAULT';
    swShowMinimized: Result := 'SW_SHOWMINIMIZED';
    swShowMinNoActive: Result := 'SW_SHOWMINNOACTIVE';
    swShowNA: Result := 'SW_SHOWNA';
    swShowNoActive: Result := 'SW_SHOWNOACTIVATE';
    swShowNormal: Result := 'SW_SHOWNORMAL';
  end;
end;

procedure TForm1.VirtualExplorerTree1EnumFolder(
  Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
  var AllowAsChild: Boolean);
begin
  if not Namespace.Folder then
    AllowAsChild := ExtractFileExt(Namespace.NameParseAddress) = '.lnk';
end;

procedure TForm1.VirtualExplorerTree1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  NS: TNamespace;
begin
  if (Sender as TCustomVirtualExplorerTree).ValidateNamespace(Node, NS) then
    if not NS.Folder and NS.Link then
    begin
      VirtualShellLink1.ReadLink(NS.NameParseAddress);

      Edit1.Text := VirtualShellLink1.FileName;
      Edit2.Text := VirtualShellLink1.TargetPath;
      Edit3.Text := VirtualShellLink1.Arguments;
      Edit4.Text := VirtualShellLink1.WorkingDirectory;
      Edit5.Text := VirtualShellLink1.Description;
      Edit6.Text := UpCase( Chr(VirtualShellLink1.HotKey));
      CheckBox1.Checked := hkmAlt in VirtualShellLink1.HotKeyModifiers;
      CheckBox2.Checked := hkmControl in VirtualShellLink1.HotKeyModifiers;
      CheckBox3.Checked := hkmExtendedKey in VirtualShellLink1.HotKeyModifiers;
      CheckBox4.Checked := hkmShift in VirtualShellLink1.HotKeyModifiers;
      Edit8.Text := VirtualShellLink1.IconLocation;
      if Edit8.Text <> '' then
        Edit9.Text := IntToStr(VirtualShellLink1.IconIndex)
      else
        Edit9.Text := '';
      case VirtualShellLink1.ShowCmd of
        swHide: RadioGroup1.ItemIndex := 0;
        swMaximize: RadioGroup1.ItemIndex := 1;
        swMinimize: RadioGroup1.ItemIndex := 2;
        swRestore: RadioGroup1.ItemIndex := 3;
        swShow: RadioGroup1.ItemIndex := 4;
        swShowDefault: RadioGroup1.ItemIndex := 5;
        swShowMinimized: RadioGroup1.ItemIndex := 6;
        swShowMinNoActive: RadioGroup1.ItemIndex := 7;
        swShowNA: RadioGroup1.ItemIndex := 8;
        swShowNoActive: RadioGroup1.ItemIndex := 9;
        swShowNormal: RadioGroup1.ItemIndex := 10;
      end;

    end else
    begin
      Edit1.Text := '';
      Edit2.Text := '';
      Edit3.Text := '';
      Edit4.Text := '';
      Edit5.Text := '';
      Edit6.Text := '';
      CheckBox1.Checked := False;
      CheckBox2.Checked := False;
      CheckBox3.Checked := False;
      CheckBox4.Checked := False;
      Edit8.Text := '';
      Edit9.Text := '';
      RadioGroup1.ItemIndex := -1;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  CheckBox1.Checked := False;
  CheckBox2.Checked := False;
  CheckBox3.Checked := False;
  CheckBox4.Checked := False;
  Edit8.Text := '';
  Edit9.Text := '';
  RadioGroup1.ItemIndex := -1;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  S: string;
  WriteFile: Boolean;
  ParamsOK: Boolean;
begin
  WriteFile := True;
  S := 'You are about to modify an existing link file:' + #13#10 +
      Edit1.Text + #13#10 +  'Continue?';
  if FileExists(Edit1.Text) then
  begin
    if MessageBox(0, PChar( S), 'Warning', MB_OKCANCEL or MB_ICONWARNING) = IDCANCEL  then
      WriteFile := False;
  end;
  if WriteFile then
  begin
    ParamsOK := True;
    VirtualShellLink1.FileName := Edit1.Text;
    VirtualShellLink1.TargetPath := Edit2.Text;
    VirtualShellLink1.Arguments := Edit3.Text;
    VirtualShellLink1.WorkingDirectory := Edit4.Text;
    VirtualShellLink1.Description := Edit5.Text;

    if Length(Edit6.Text) > 1 then
    begin
      ShowMessage('Hot Key invalid');
      ParamsOK := False;
    end else
    if Length(Edit6.Text) = 1 then
      VirtualShellLink1.HotKey := Ord(Edit6.Text[1]);

    VirtualShellLink1.HotKeyModifiers := [];
    if CheckBox1.Checked then
      VirtualShellLink1.HotKeyModifiers := VirtualShellLink1.HotKeyModifiers + [hkmAlt];
    if CheckBox2.Checked then
      VirtualShellLink1.HotKeyModifiers := VirtualShellLink1.HotKeyModifiers + [hkmControl];
    if CheckBox3.Checked then
      VirtualShellLink1.HotKeyModifiers := VirtualShellLink1.HotKeyModifiers + [hkmExtendedKey];
    if CheckBox4.Checked then
      VirtualShellLink1.HotKeyModifiers := VirtualShellLink1.HotKeyModifiers + [hkmShift];

    VirtualShellLink1.IconLocation := Edit8.Text;

    try
      if Edit9.Text <> '' then
        VirtualShellLink1.IconIndex := StrToInt(Edit9.Text)
      else
        Edit9.Text := '';
    except
      ShowMessage('Icon index is invalid');
      ParamsOK := False;
    end;

    case RadioGroup1.ItemIndex of
      0: VirtualShellLink1.ShowCmd := swHide;
      1: VirtualShellLink1.ShowCmd := swMaximize;
      2: VirtualShellLink1.ShowCmd := swMinimize;
      3: VirtualShellLink1.ShowCmd := swRestore;
      4: VirtualShellLink1.ShowCmd := swShow;
      5: VirtualShellLink1.ShowCmd := swShowDefault;
      6: VirtualShellLink1.ShowCmd := swShowMinimized;
      7: VirtualShellLink1.ShowCmd := swShowMinNoActive;
      8: VirtualShellLink1.ShowCmd := swShowNA;
      9: VirtualShellLink1.ShowCmd := swShowNoActive;
      10: VirtualShellLink1.ShowCmd := swShowNormal;
    end;

    if ParamsOK then
      VirtualShellLink1.WriteLink(VirtualShellLink1.FileName);
  end;
end;

end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VirtualExplorerTree, VirtualTrees, ExtCtrls, Menus,
  VirtualShellUtilities, VirtualShellNewMenu,
  TB2Dock, TB2Toolbar, TB2Item, TBX;

type
  TForm1 = class(TForm)
    RadioGroupFileName: TRadioGroup;
    Edit1: TEdit;
    ExplorerListview1: TVirtualExplorerListview;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label2: TLabel;
    VirtualShellNewMenu1: TVirtualShellNewMenu;
    TBXToolbar1: TTBXToolbar;
    TBXSubmenuItem1: TTBXSubmenuItem;
    procedure VirtualShellNewMenu1AddMenuItem(Sender: TPopupMenu;
      const NewMenuItem: TVirtualShellNewItem; var Allow: Boolean);
    procedure VirtualShellNewMenu1CreateNewFile(Sender: TMenu;
      const NewMenuItem: TVirtualShellNewItem; var Path, FileName: String;
      var Allow: Boolean);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TBXSubmenuItem1Popup(Sender: TTBCustomItem; FromLink: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Loaded; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.VirtualShellNewMenu1AddMenuItem(Sender: TPopupMenu;
  const NewMenuItem: TVirtualShellNewItem; var Allow: Boolean);
begin
  { Here Menu Items can be filtered dynamiclly }
end;

procedure TForm1.VirtualShellNewMenu1CreateNewFile(Sender: TMenu;
  const NewMenuItem: TVirtualShellNewItem; var Path, FileName: String;
  var Allow: Boolean);
begin
  { Here we MUST return the path the file is to be created in }
  Path := ExplorerListview1.RootFolderNamespace.NameForParsing;
  if RadioGroupFileName.ItemIndex = 1 then
    FileName := Edit1.Text;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  VirtualShellNewMenu1.CombineLikeItems := CheckBox1.Checked;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  VirtualShellNewMenu1.UseShellImages := CheckBox2.Checked;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  VirtualShellNewMenu1.WarnOnOverwrite := CheckBox3.Checked;
end;

procedure TForm1.Loaded;
begin
  inherited;
  CheckBox3.Checked := VirtualShellNewMenu1.WarnOnOverwrite;
  CheckBox2.Checked := VirtualShellNewMenu1.UseShellImages;
  CheckBox1.Checked := VirtualShellNewMenu1.CombineLikeItems;
  CheckBox4.Checked := VirtualShellNewMenu1.NewFolderItem;
  CheckBox5.Checked := VirtualShellNewMenu1.NewShortcutItem;
end;

procedure TForm1.TBXSubmenuItem1Popup(Sender: TTBCustomItem; FromLink: Boolean);
begin
  // Just call this method when the SubmenuItem is about to be showed.
  // To add unicode support use TSpTBXItem instead:
  // VirtualSendToMenu1.Populate_TB2000(Sender, TSpTBXItem);
  VirtualShellNewMenu1.Populate_TB2000(Sender, TTBXItem);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Application.HintPause := 10000;
  ExplorerListview1.Active := True;
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  VirtualShellNewMenu1.NewFolderItem := CheckBox4.Checked;
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
   VirtualShellNewMenu1.NewShortcutItem := CheckBox5.Checked;
end;

end.

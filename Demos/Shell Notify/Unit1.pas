unit Unit1;

// You must define VIRTUALNOTIFYDEBUG in
// Projects>Options>Conditional Defines to Compile

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VirtualExplorerTree, VirtualTrees, ExtCtrls, Menus, ShlObj,
  VirtualShellNewMenu, MPShellUtilities, VirtualShellNotifier,
  ToolWin, VirtualShellToolBar, VirtualResources,
  {$IFDEF TNTSUPPORT}
  TntSysUtils, TntClasses,
  {$ENDIF}
  MPCommonUtilities,
  MPShellTypes,
  ComCtrls;

// Undefine the following to enable the Kernel Shell Notifiers
//{$DEFINE KernelNotifier}

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
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
    ExplorerComboBox1: TVirtualExplorerCombobox;
    VirtualShellNewMenu1: TVirtualShellNewMenu;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure VirtualShellNewMenu1AddMenuItem(Sender: TPopupMenu;
      const NewMenuItem: TVirtualShellNewItem; var Allow: Boolean);
    procedure VirtualShellNewMenu1CreateNewFile(Sender: TMenu;
      const NewMenuItem: TVirtualShellNewItem; var Path, FileName: String;
      var Allow: Boolean);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure ExplorerListview1ShellNotify(
      Sender: TCustomVirtualExplorerTree; ShellEvent: TVirtualShellEvent);
    procedure ExplorerListview1RootChanging(
      Sender: TCustomVirtualExplorerTree; const NewValue: TRootFolder;
      const CurrentNamespace, Namespace: TNamespace; var Allow: Boolean);
    procedure ExplorerListview1Change(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure ExplorerListview1Updating(Sender: TBaseVirtualTree;
      State: TVTUpdateState);
  private
    { Private declarations }
  public
    { Public declarations }
    NotifyCount: integer;
    NotifyBlocks: integer;
    
    procedure Loaded; override;
    procedure RegisterNotifier;
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt.x := Button1.Left;
  Pt.y := Button1.Top + Button1.Height;
  Pt := ClientToScreen(Pt);
  VirtualShellNewMenu1.Popup(Pt.x, Pt.y);
end;

procedure TForm1.VirtualShellNewMenu1AddMenuItem(Sender: TPopupMenu;
  const NewMenuItem: TVirtualShellNewItem; var Allow: Boolean);
begin
  { Here Menu Items can be filter dynamiclly }
end;

procedure TForm1.VirtualShellNewMenu1CreateNewFile(Sender: TMenu;
  const NewMenuItem: TVirtualShellNewItem; var Path, FileName: String;
  var Allow: Boolean);
begin
  { Here we MUST return the path the file is to be created in }
  Path := ExplorerComboBox1.Path;
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.HintPause := 1000;
  ExplorerComboBox1.EditNamespace := DesktopFolder;
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

procedure TForm1.ExplorerListview1ShellNotify(
  Sender: TCustomVirtualExplorerTree; ShellEvent: TVirtualShellEvent);
begin
  Form2.AddEvent(ShellEvent);
end;

procedure TForm1.ExplorerListview1RootChanging(
  Sender: TCustomVirtualExplorerTree; const NewValue: TRootFolder;
  const CurrentNamespace, Namespace: TNamespace; var Allow: Boolean);
begin
  {$IFDEF KernelNotifier}
  if DirExistsW(Namespace.NameForParsing) then
    ChangeNotifier.NotifyWatchFolder(ExplorerListview1, Namespace.NameForParsing)
  else
    ChangeNotifier.NotifyWatchFolder(ExplorerListview1, '')
  {$ENDIF KernelNotifier}
end;

procedure TForm1.RegisterNotifier;
begin
  {$IFDEF KernelNotifier}
  ChangeNotifier.RegisterKernelChangeNotify(ExplorerListview1, AllKernelNotifiers);
  // Register some special Folders that the thread will be able to generate
  // notification PIDLs for Virtual Folders too.
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_DESKTOP);
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_PERSONAL);
  ChangeNotifier.RegisterKernelSpecialFolderWatch(CSIDL_COMMON_DOCUMENTS);
  {$ENDIF KernelNotifier}
end;

procedure TForm1.ExplorerListview1Change(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  StatusBar1.Panels[1].Text := ' ' + IntToStr(ExplorerListview1.SelectedCount) + ' Selected Objects';
end;

procedure TForm1.ExplorerListview1Updating(Sender: TBaseVirtualTree;
  State: TVTUpdateState);
begin
  StatusBar1.Panels[0].Text := ' ' + IntToStr(ExplorerListview1.RootNode.ChildCount) + ' Total Objects';
end;

end.

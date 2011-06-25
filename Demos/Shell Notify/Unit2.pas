unit Unit2;

interface

// You must define VIRTUALNOTIFYDEBUG in
// Projects>Options>Conditional Defines to Compile

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, VirtualExplorerTree, MPShellUtilities, ToolWin, VirtualShellNotifier,
  StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    TreeView1: TTreeView;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    CheckBox1: TCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddEvent(ShellEvent: TVirtualShellEvent);
    procedure DebugNotifyHook(Sender: TObject);
    procedure RefreshDebugGUI;

  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

{ TForm2 }

procedure TForm2.AddEvent(ShellEvent: TVirtualShellEvent);
var
  NS1, NS2: TNamespace;
  Node, Node2, Node3: TTreeNode;
begin
  with ShellEvent do
  begin
    if Assigned(PIDL1) then
    begin
      NS1 := TNamespace.Create(PIDL1, nil);
      NS1.FreePIDLOnDestroy := False;
    end else
      NS1 := nil;
    if Assigned(PIDL2) then
    begin
      NS2 := TNamespace.Create(PIDL2, nil);
      NS2.FreePIDLOnDestroy := False;
    end else
      NS2 := nil;
    Node := Treeview1.Items.AddChild(nil, VirtualShellNotifyEventToStr(ShellEvent.ShellNotifyEvent));

    Node2 := Treeview1.Items.AddChild(Node, 'Item 1');
    if Assigned(NS1) then
    begin
      Node3 := Treeview1.Items.AddChild(Node2, 'PIDL 1 = ' + IntToStr( Integer(PIDL1)));
      Treeview1.Items.AddChild(Node3, 'ItemID Count = ' + IntToStr( PIDLMgr.IDCount(PIDL1)));
      Treeview1.Items.AddChild(Node3, 'Path = ' + NS1.NameParseAddress);
    end else
      Treeview1.Items.AddChild(Node2, 'PIDL1 = nil');

    Node3 := Treeview1.Items.AddChild(Node2, 'DWORD 1 = ' + IntToStr( DoubleWord1));
    Treeview1.Items.AddChild(Node3, 'Drive ID = ' + FreeSpaceNotifyToDrive(DoubleWord1));

    Node2 := Treeview1.Items.AddChild(Node, 'Item 2');
    if Assigned(NS2) then
    begin
      Node3 := Treeview1.Items.AddChild(Node2, 'PIDL 2 = ' + IntToStr( Integer(PIDL2)));
      Treeview1.Items.AddChild(Node3, 'ItemID Count = ' + IntToStr( PIDLMgr.IDCount(PIDL2)));
      Treeview1.Items.AddChild(Node3, 'Path = ' + NS2.NameParseAddress);
    end else
      Treeview1.Items.AddChild(Node2, 'PIDL2 = nil');
    Node3 := Treeview1.Items.AddChild(Node2, 'DWORD 2 = ' + IntToStr( DoubleWord2));
    Treeview1.Items.AddChild(Node3, 'Drive ID = ' + FreeSpaceNotifyToDrive(DoubleWord2));
    NS1.Free;
    NS2.Free;
  end;
end;

procedure TForm2.DebugNotifyHook;
begin
  if CheckBox1.Checked then
    RefreshDebugGUI
end;

procedure TForm2.ToolButton1Click(Sender: TObject);
begin
  Treeview1.Items.Clear
end;

procedure TForm2.ToolButton2Click(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Treeview1.Items.Count - 1 do
  begin
    if Treeview1.Items[i].Level = 0 then
      Treeview1.Items[i].Text := '----' + Treeview1.Items[i].Text
  end;
end;

procedure TForm2.ToolButton3Click(Sender: TObject);
begin
  Treeview1.Items.BeginUpdate;
  try
    Treeview1.FullCollapse
  finally
    Treeview1.Items.EndUpdate
  end
end;

procedure TForm2.ToolButton4Click(Sender: TObject);
begin
  Treeview1.Items.BeginUpdate;
  try
    Treeview1.FullExpand
  finally
    Treeview1.Items.EndUpdate
  end
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.OnChange := DebugNotifyHook
  {$ENDIF}
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.ShellEvents := 0;
  NotifyDebug.EventListObjects := 0;
  NotifyDebug.KernelEvents := 0;
  NotifyDebug.EventObjects := 0;
  NotifyDebug.PeakKernelEvents := 0;
  NotifyDebug.PeakShellEvents := 0;
  NotifyDebug.PeakEventObjects := 0;
  NotifyDebug.PeakEventListObjects := 0;
  RefreshDebugGUI
  {$ENDIF}
end;

procedure TForm2.RefreshDebugGUI;
begin
  {$IFDEF VIRTUALNOTIFYDEBUG}
  Label5.Caption := IntToStr(NotifyDebug.PeakShellEvents);
  Label6.Caption := IntToStr(NotifyDebug.PeakKernelEvents);
  Label7.Caption := IntToStr(NotifyDebug.PeakEventObjects);
  Label8.Caption := IntToStr(NotifyDebug.EventObjects);
  Label9.Caption := IntToStr(NotifyDebug.PeakEventListObjects);
  Label10.Caption := IntToStr(NotifyDebug.EventListObjects);
  {$ENDIF}
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  {$IFDEF VIRTUALNOTIFYDEBUG}
  RefreshDebugGUI
  {$ENDIF}
end;

procedure TForm2.FormHide(Sender: TObject);
begin
  {$IFDEF VIRTUALNOTIFYDEBUG}
  NotifyDebug.OnChange := nil
  {$ENDIF}
end;

end.

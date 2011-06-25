unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualShellAutoComplete, VirtualTrees,
  VirtualExplorerTree;

type
  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    VirtualShellAutoComplete1: TVirtualShellAutoComplete;
    VirtualExplorerTreeview1: TVirtualExplorerTreeview;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    Label1: TLabel;
    ListBox1: TListBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure VirtualExplorerTreeview1FocusChanged(
      Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accCurrentDir]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accCurrentDir]
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accMyComputer]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accMyComputer]
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accDesktop]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accDesktop]
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accFavorites]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accFavorites]
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accFileSysOnly]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accFileSysOnly]
end;

procedure TForm1.CheckBox6Click(Sender: TObject);
begin
  if CheckBox6.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accFileSysDirs]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accFileSysDirs]
end;

procedure TForm1.CheckBox7Click(Sender: TObject);
begin
  if CheckBox7.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accFileSysFiles]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accFileSysFiles]
end;

procedure TForm1.CheckBox8Click(Sender: TObject);
begin
  if CheckBox8.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accHidden]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accHidden]
end;

procedure TForm1.CheckBox9Click(Sender: TObject);
begin
  if CheckBox9.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accRecursive]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accRecursive]
end;

procedure TForm1.CheckBox10Click(Sender: TObject);
begin
  if CheckBox10.Checked then
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents + [accSortList]
  else
    VirtualShellAutoComplete1.Contents := VirtualShellAutoComplete1.Contents - [accSortList]
end;

procedure TForm1.VirtualExplorerTreeview1FocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  OldCursor: TCursor;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  try
    VirtualShellAutoComplete1.CurrentDir := VirtualExplorerTreeview1.SelectedPath;
    VirtualShellAutoComplete1.Refresh;
    ListBox1.Items := VirtualShellAutoComplete1.Strings;
  finally
    Screen.Cursor := OldCursor
  end

end;

end.

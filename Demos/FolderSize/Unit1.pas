unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualExplorerTree, VirtualTrees, MPShellUtilities, Menus, StdCtrls,
  Printers, Extctrls;

type
  TSizeFormatType = (sfByte, sfKB, sfMB, sfGB, sfAuto);

  TForm1 = class(TForm)
    VirtualExplorerTree1: TVirtualExplorerTree;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    Memo1: TMemo;
    Bevel1: TBevel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    procedure VirtualExplorerTree1GetVETText(
      Sender: TCustomVirtualExplorerTree; Column: TColumnIndex;
    Node: PVirtualNode; Namespace: TNamespace; var Text: string);
    procedure VirtualExplorerTree1BeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure VirtualExplorerTree1Expanded(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FSizeFormat: TSizeFormatType;
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Helpers }
function BytesToKB(Size: Int64): Int64;
begin
  //This is how Win Explorer calculates it
  Result := Size div 1024;
  if (Size mod 1024 <> 0) then Result := Result + 1;
end;

function FormatBytes(Size: Int64; FormatType: TSizeFormatType = sfAuto; Precision: integer = 2): string;
var
  D: double;
const
  FormatArray: array [TSizeFormatType] of string = ('bytes', 'KB', 'MB', 'GB', '');
begin
  Result := '';
  D := Size;
  Case FormatType of
    sfAuto:
      begin
        FormatType := sfKB;  //start from KB
        D := BytesToKB(Size);
        while (D > 1024) and (FormatType < sfAuto) do begin
          D := D / 1024;
          FormatType := Succ(FormatType);
        end;
      end;
    sfByte: D := Size;
    sfKB:   D := BytesToKB(Size);
    sfMB:   D := BytesToKB(Size) / 1024;
    sfGB:   D := BytesToKB(Size) / 1024 / 1024;
  end;

  if FormatType <= sfKB then  //use the precision only for MB and GB
    Precision := 0;
  Result := Format('%.'+ IntToStr(Precision) + 'n ' + FormatArray[FormatType], [D]);
end;

function IsFloppyW(FileFolder: string): boolean;
begin
  Result := Char(FileFolder[1]) in ['A', 'a', 'B', 'b'];
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Form }

procedure TForm1.VirtualExplorerTree1GetVETText(
      Sender: TCustomVirtualExplorerTree; Column: TColumnIndex;
      Node: PVirtualNode; Namespace: TNamespace; var Text: string);
begin
  if Column = 1 then
    if Namespace.Folder and Namespace.FileSystem and (Namespace.Tag > 0) then
      Text := FormatBytes(Namespace.FolderSize(False), FSizeFormat)
    else
      Text := '';
end;

procedure TForm1.VirtualExplorerTree1BeforeCellPaint(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  NS: TNamespace;
  I, PercentageSize: integer;
  ColorStep: Word;
begin
  if (Column = 1) and VirtualExplorerTree1.ValidateNamespace(Node, NS) then
  begin
    if NS.Folder and NS.FileSystem and (NS.Tag > 0) then
    begin
      InflateRect(CellRect, -1, -1);
      DrawEdge(TargetCanvas.Handle, CellRect, EDGE_SUNKEN, BF_ADJUST or BF_RECT);
      PercentageSize := (CellRect.Right - CellRect.Left) * NS.Tag div 100;

      if CheckBox2.Checked then
      begin
        ColorStep := Round((CellRect.Right - CellRect.Left) / $FF);
        TargetCanvas.Brush.Color := $0000FF;
        for I := CellRect.Right downto CellRect.Left do
        begin
          if CellRect.Right - CellRect.Left <= PercentageSize then
            TargetCanvas.FillRect(CellRect);
          Dec(CellRect.Right);
          TargetCanvas.Brush.Color := TargetCanvas.Brush.Color - ColorStep + (ColorStep + $FF);
        end;
      end else
      begin
        CellRect.Right := CellRect.Left + PercentageSize;
        if NS.Tag = 100 then
          TargetCanvas.Brush.Color := clRed
        else
          TargetCanvas.Brush.Color := clLime;
        TargetCanvas.FillRect(CellRect);
      end;
    end;
  end;
end;

procedure TForm1.VirtualExplorerTree1Expanded(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Total: Int64;
  Child: PVirtualNode;
  NS: TNamespace;
  RecurseFolders, ReadFloppy, ReadRemovable: Boolean;
begin
  RecurseFolders := CheckBox1.Checked;
  ReadFloppy := CheckBox3.Checked;
  ReadRemovable := CheckBox4.Checked;

  Total := 0;

  //Process the Desktop folder, set it to 100%, we only have 1 root :)
  if TVirtualExplorerTree(Sender).ValidateNamespace(Node, NS) then
    if NS.IsDesktop then
      NS.Tag := 100;

  //Work with the children
  Child := Node.FirstChild;
  if TVirtualExplorerTree(Sender).ValidateNamespace(Child, NS) then
  begin
    while Assigned(Child) do
    begin
      if TVirtualExplorerTree(Sender).ValidateNamespace(Child, NS) then
      begin
        if NS.Folder and NS.FileSystem and (ReadRemovable or not NS.Removable) and (ReadFloppy or not IsFloppyW(NS.NameForParsing)) then
          Total := Total + NS.FolderSize(False, RecurseFolders);
      end;
      Child := Child.NextSibling
    end;

    if Total > 0 then begin
      Child := Node.FirstChild;
      while Assigned(Child) do
      begin
        if TVirtualExplorerTree(Sender).ValidateNamespace(Child, NS) then
          if NS.Folder and NS.FileSystem and (ReadRemovable or not NS.Removable) and (ReadFloppy or not IsFloppyW(NS.NameForParsing)) then
            if NS.FolderSize(False) > 0 then
            begin
              NS.Tag := NS.FolderSize(False) * 100 div Total; //get the percentage
              if NS.Tag = 0 then
                NS.Tag := 1; //Force the painting
            end;
        Child := Child.NextSibling
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //default options
  FSizeFormat := sfMB;
  Combobox1.ItemIndex := 2;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  //We need to recreate the tree to clear the Nodes Namespace.Tag property
  VirtualExplorerTree1.RefreshTree;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  VirtualExplorerTree1.Invalidate;
end;

procedure TForm1.ComboBox1Click(Sender: TObject);
begin
  if Combobox1.ItemIndex > -1 then
  begin
    FSizeFormat := TSizeFormatType(Combobox1.ItemIndex);
    VirtualExplorerTree1.Invalidate;
  end;
end;

end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, VirtualExplorerTree, VirtualTrees, MPShellUtilities,
  StdCtrls;

type
  TForm1 = class(TForm)
    VirtualExplorerListview1: TVirtualExplorerListview;
    procedure ExplorerListview1GetVETText(
      Sender: TCustomVirtualExplorerTree; Column: TColumnIndex;
      Node: PVirtualNode; Namespace: TNamespace; var Text: WideString);
    procedure ExplorerListview1HeaderRebuild(Sender: TCustomVirtualExplorerTree;
      Header: TVTHeader);
    procedure ExplorerListview1CustomColumnCompare(
      Sender: TCustomVirtualExplorerTree; Column: TColumnIndex; Node1,
      Node2: PVirtualNode; var Result: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    CustomIndex: integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ExplorerListview1GetVETText(
  Sender: TCustomVirtualExplorerTree; Column: TColumnIndex; Node: PVirtualNode;
  Namespace: TNamespace; var Text: WideString);
var
  NS: TNamespace;
begin    
  if Sender.ValidateNamespace(Node, NS) then
  begin
    if Column = CustomIndex then
      Text :=   ExtractFileExt(NS.NameParseAddress);
    if Column = CustomIndex + 1 then
      Text := 'CustomColumn 2'
  end;
end;

procedure TForm1.ExplorerListview1HeaderRebuild(
  Sender: TCustomVirtualExplorerTree; Header: TVTHeader);
var
  NewColumn: TVETColumn;
begin
  CustomIndex := Header.Columns.Count;
  NewColumn := TVETColumn(Header.Columns.Add);
  NewColumn.ColumnDetails := cdCustom;
  NewColumn.Text := 'Extension';
  NewColumn.Width := 60;

  NewColumn := TVETColumn( Header.Columns.Add);
  NewColumn.ColumnDetails := cdCustom;
  NewColumn.Text := 'Second Custom';
end;

procedure TForm1.ExplorerListview1CustomColumnCompare(
  Sender: TCustomVirtualExplorerTree; Column: TColumnIndex; Node1,
  Node2: PVirtualNode; var Result: Integer);
var
  NS1, NS2: TNamespace;
  s1, s2: string;
begin
  if Sender.ValidateNamespace(Node1, NS1) and Sender.ValidateNamespace(Node2, NS2) then
  begin
    if Column = CustomIndex then
    begin
    { Win9x compatible }
      s1 := ExtractFileExt(NS1.NameParseAddress);
      s2 := ExtractFileExt(NS2.NameParseAddress);
      Result := lstrcmp(PChar(s1), PChar(s2));
      { If equal use the name ordering as a secondary sort }
      if Result = 0 then
      begin
        s1 := NS1.NameNormal;
        s2 := NS2.NameNormal;
        Result := lstrcmp(PChar(s1), PChar(s2));
      end;
    end
  end;
end;

end.

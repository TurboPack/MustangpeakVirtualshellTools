unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPCommonObjects, EasyListview, VirtualExplorerEasyListview, Menus,
  MPShellUtilities;

type
  TForm1 = class(TForm)
    VirtualExplorerEasyListview1: TVirtualExplorerEasyListview;
    procedure VirtualExplorerEasyListview1CustomColumnAdd(
      Sender: TCustomVirtualExplorerEasyListview;
      AddColumnProc: TELVAddColumnProc);
    procedure VirtualExplorerEasyListview1CustomColumnCompare(
      Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn;
      Group: TEasyGroup; Item1, Item2: TExplorerItem;
      var CompareResult: Integer);
    procedure VirtualExplorerEasyListview1CustomColumnGetCaption(
      Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn;
      Item: TExplorerItem; var Caption: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.VirtualExplorerEasyListview1CustomColumnAdd(
  Sender: TCustomVirtualExplorerEasyListview;
  AddColumnProc: TELVAddColumnProc);
var
  Column: TExplorerColumn;
begin
  Column := AddColumnProc;
  Column.Caption := 'Custom Column';
  Column.Width := 120;
  Column.Alignment := taRightJustify;
  Column.Visible := True;
end;

procedure TForm1.VirtualExplorerEasyListview1CustomColumnCompare(
  Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn;
  Group: TEasyGroup; Item1, Item2: TExplorerItem;
  var CompareResult: Integer);
begin
  // sort on something silly like the item pointers
  CompareResult := Integer( Item1) - Integer( Item2);
  if Column.SortDirection = esdDescending then
    CompareResult := -CompareResult;
end;

procedure TForm1.VirtualExplorerEasyListview1CustomColumnGetCaption(
  Sender: TCustomVirtualExplorerEasyListview; Column: TExplorerColumn;
  Item: TExplorerItem; var Caption: string);
begin
  // Something silly and unique
  Caption := IntToStr( Integer(Item))
end;

end.

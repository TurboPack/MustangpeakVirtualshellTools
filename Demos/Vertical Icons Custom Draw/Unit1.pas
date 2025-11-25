unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPCommonObjects, EasyListview, VirtualExplorerEasyListview;

type
  TForm1 = class(TForm)
    VirtualExplorerEasyListview1: TVirtualExplorerEasyListview;
    procedure VirtualExplorerEasyListview1CustomGrid(
      Sender: TCustomEasyListview; Group: TEasyGroup;
      ViewStyle: TEasyListStyle; var Grid: TEasyGridGroupClass);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  // Make a grid that is layed out like the List View but has the cell sizing of
  // the Icon View
  TVerticalIconGridGroup = class(TEasyGridListGroup)
  protected
    function GetCellSize: TEasyCellSize; override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  TCustomVirtualExplorerEasyListviewHack = class(TCustomVirtualExplorerEasyListview);

{ TVerticalIconGridGroup }
function TVerticalIconGridGroup.GetCellSize: TEasyCellSize;
begin
  Result := TCustomVirtualExplorerEasyListviewHack(OwnerListview).CellSizes.Icon;
end;

procedure TForm1.VirtualExplorerEasyListview1CustomGrid(
  Sender: TCustomEasyListview; Group: TEasyGroup;
  ViewStyle: TEasyListStyle; var Grid: TEasyGridGroupClass);
begin
  // Map the Icon style to the Vertical Icon List Style
  if ViewStyle = elsIcon then
    Grid := TVerticalIconGridGroup;
end;

end.

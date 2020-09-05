unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MPCommonObjects, EasyListview, VirtualExplorerEasyListview,
  MPShellUtilities, SHlObj, ExtCtrls;

type
  TForm1 = class(TForm)
    LV: TVirtualExplorerEasyListview;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    function LVItemCompare(Sender: TCustomEasyListview; Column: TEasyColumn;
      Group: TEasyGroup; Item1, Item2: TEasyItem;
      var DoDefault: Boolean): Integer;
    procedure LVRootRebuild(Sender: TCustomVirtualExplorerEasyListview);
    procedure LVItemGetCaption(Sender: TCustomEasyListview; Item: TEasyItem;
      Column: Integer; var Caption: string);
    procedure ComboBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FZombieItem: TExplorerItem;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Helpers }

function GetPrevNamespace(NS: TNamespace): TNamespace;
var
  PIDL: PItemIDList;
begin
  Result := nil;
  if Assigned(NS) and (not NS.IsDesktop) then begin
    PIDL := PIDLMgr.CopyPIDL(NS.AbsolutePIDL);
    PIDLMgr.StripLastID(PIDL);
    Result := TNamespace.Create(PIDL, nil);
    Result.FreePIDLOnDestroy := True; // TNamespace will destroy the PIDL
  end;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ LV }

procedure TForm1.ComboBox1Click(Sender: TObject);
begin
  LV.View := TEasyListStyle(Combobox1.ItemIndex);
end;

function TForm1.LVItemCompare(Sender: TCustomEasyListview; Column: TEasyColumn;
  Group: TEasyGroup; Item1, Item2: TEasyItem; var DoDefault: Boolean): Integer;
// Place the ZombieItem on the top of the listview
begin
  Result := 0;
  if Assigned(FZombieItem) then
    if FZombieItem = Item1 then begin
      Result := -1;
      DoDefault := False;
    end else
    if FZombieItem = Item2 then begin
      Result := 1;
      DoDefault := False;
    end;
end;

procedure TForm1.LVItemGetCaption(Sender: TCustomEasyListview; Item: TEasyItem;
  Column: Integer; var Caption: string);
// Change the caption of the ZombieItem
begin
  if Assigned(FZombieItem) and (FZombieItem = Item) and (Column = 0) then
    Caption := '[..]';
end;

procedure TForm1.LVRootRebuild(Sender: TCustomVirtualExplorerEasyListview);
var
  NS: TNamespace;
begin
  FZombieItem := nil;
  // First we should create the Namespace that will represent the '..' dir.
  // Simply get the parent level namespace
  NS := GetPrevNamespace(LV.RootFolderNamespace);
  if Assigned(NS) then begin
    // Now create the ZombieNode and sort the tree
    FZombieItem := LV.AddCustomItem(nil, NS, True);
    LV.SortList;
  end;
end;

end.

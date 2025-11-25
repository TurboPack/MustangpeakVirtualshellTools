unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, ImgList, ComCtrls, ToolWin, ExtCtrls,
  StdCtrls, VirtualTrees, VirtualExplorerTree, MPShellUtilities,
  VirtualShellHistory, MPCommonObjects, MPCommonUtilities;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    VirtualExplorerTreeview1: TVirtualExplorerTreeview;
    VirtualExplorerListview1: TVirtualExplorerListview;
    Splitter1: TSplitter;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    ActionList1: TActionList;
    aBack: TAction;
    aNext: TAction;
    aHistory: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    VirtualStringTree1: TVirtualStringTree;
    VirtualShellHistory: TVirtualShellHistory;
    TabSheet3: TTabSheet;
    EditMenuWidth: TEdit;
    Label1: TLabel;
    EditHistoryDepth: TEdit;
    Label2: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label3: TLabel;
    CheckBoxUseImages: TCheckBox;
    CheckBoxLargeImages: TCheckBox;
    Label4: TLabel;
    EditImageBorder: TEdit;
    ComboBoxEllipsisPosition: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    ComboBoxLabelStyle: TComboBox;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    PopUpMRU: TPopupMenu;
    VirtualShellMRU1: TVirtualShellMRU;
    procedure aBackExecute(Sender: TObject);
    procedure aNextExecute(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree1FocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure CheckBoxUseImagesClick(Sender: TObject);
    procedure EditHistoryDepthKeyPress(Sender: TObject; var Key: Char);
    procedure EditHistoryDepthExit(Sender: TObject);
    procedure EditImageBorderExit(Sender: TObject);
    procedure EditImageBorderKeyPress(Sender: TObject; var Key: Char);
    procedure EditMenuWidthKeyPress(Sender: TObject; var Key: Char);
    procedure EditMenuWidthExit(Sender: TObject);
    procedure ComboBoxLabelStyleChange(Sender: TObject);
    procedure ComboBoxEllipsisPositionChange(Sender: TObject);
    procedure CheckBoxLargeImagesClick(Sender: TObject);
    procedure PopUpMRUPopup(Sender: TObject);
    procedure VirtualShellHistoryChange(Sender: TBaseVirtualShellPersistent;
      ItemIndex: Integer; ChangeType: TVSHChangeType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Helpers }

function GetChildByIndex(ParentNode: PVirtualNode; ChildIndex: Cardinal): PVirtualNode;
var
  N: PVirtualNode;
  Count: Cardinal;
begin
  Result := nil;
  Count := ParentNode.ChildCount;
  if ChildIndex > Count then exit;

  if ChildIndex <= Count div 2 then begin
    N := ParentNode.FirstChild;
    while Assigned(N) do
      if N.Index = ChildIndex then begin
        Result := N;
        break;
      end
      else
        N := N.NextSibling;
  end
  else begin
    N := ParentNode.LastChild;
    while Assigned(N) do
      if N.Index = ChildIndex then begin
        Result := N;
        break;
      end
      else
        N := N.PrevSibling;
  end;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Form }

procedure TForm1.FormShow(Sender: TObject);
begin
  VirtualStringTree1.Images := LargeSysImages;

  VirtualExplorerTreeview1.Active := True;
  VirtualExplorerListview1.Active := True;

  PageControl1.ActivePageIndex := 0;
  ComboBoxLabelStyle.ItemIndex := 0;
  ComboBoxEllipsisPosition.ItemIndex := 0;
  EditMenuWidth.Text := IntToStr(VirtualShellHistory.MenuOptions.MaxWidth);
  EditImageBorder.Text := IntToStr(VirtualShellHistory.MenuOptions.ImageBorder);
  EditHistoryDepth.Text := IntToStr(VirtualShellHistory.Levels);

  VirtualShellMRU1.LoadFromRegistry(HKEY_CURRENT_USER, '\Software\VirtualShellTools\MRU');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  VirtualShellMRU1.SaveToRegistry(HKEY_CURRENT_USER, '\Software\VirtualShellTools\MRU');
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Actions }

procedure TForm1.aBackExecute(Sender: TObject);
begin
  VirtualShellHistory.Back;
end;

procedure TForm1.aNextExecute(Sender: TObject);
begin
  VirtualShellHistory.Next;
end;

procedure TForm1.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  //Update the button actions
  aBack.Enabled := VirtualShellHistory.ItemIndex > -1;          //if the ItemIndex is valid
  aNext.Enabled := VirtualShellHistory.ItemIndex < VirtualShellHistory.Count-1; //if the ItemIndex is not the last item
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Options }

procedure TForm1.CheckBoxUseImagesClick(Sender: TObject);
begin
  CheckBoxLargeImages.Enabled := CheckBoxUseImages.Checked;
  EditImageBorder.Enabled := CheckBoxUseImages.Checked;
  VirtualShellHistory.MenuOptions.Images := CheckBoxUseImages.Checked;
  VirtualShellHistory.MenuOptions.LargeImages := CheckBoxLargeImages.Checked;
  VirtualShellHistory.MenuOptions.ImageBorder := StrToInt(EditImageBorder.Text);
end;

procedure TForm1.CheckBoxLargeImagesClick(Sender: TObject);
begin
  VirtualShellHistory.MenuOptions.LargeImages := CheckBoxLargeImages.Checked;
end;

procedure TForm1.EditHistoryDepthKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    VirtualShellHistory.Levels := StrToInt(EditHistoryDepth.Text);
    Key := #0
  end
end;

procedure TForm1.EditHistoryDepthExit(Sender: TObject);
begin
  VirtualShellHistory.Levels := StrToInt(EditHistoryDepth.Text);
end;

procedure TForm1.EditImageBorderKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    VirtualShellHistory.MenuOptions.ImageBorder := StrToInt(EditImageBorder.Text);
    Key := #0
  end
end;

procedure TForm1.EditImageBorderExit(Sender: TObject);
begin
  VirtualShellHistory.MenuOptions.ImageBorder := StrToInt(EditImageBorder.Text);
end;

procedure TForm1.EditMenuWidthKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    VirtualShellHistory.MenuOptions.MaxWidth := StrToInt(EditMenuWidth.Text);
    Key := #0
  end
end;

procedure TForm1.EditMenuWidthExit(Sender: TObject);
begin
  VirtualShellHistory.MenuOptions.MaxWidth := StrToInt(EditMenuWidth.Text);
end;

procedure TForm1.ComboBoxLabelStyleChange(Sender: TObject);
begin
  VirtualShellHistory.MenuOptions.TextType := TVSHMenuTextType(ComboBoxLabelStyle.ItemIndex)
end;

procedure TForm1.ComboBoxEllipsisPositionChange(Sender: TObject);
begin
  VirtualShellHistory.MenuOptions.EllipsisPlacement := TShortenStringEllipsis(ComboBoxEllipsisPosition.ItemIndex)
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Recreate a History list with a VirtualStringTree }

procedure TForm1.VirtualShellHistoryChange(Sender: TBaseVirtualShellPersistent;
  ItemIndex: Integer; ChangeType: TVSHChangeType);
var
  N: PVirtualNode;
begin
  if not Assigned(VirtualStringTree1) then
    Exit;

  case ChangeType of
    hctAdded:
      VirtualStringTree1.RootNodeCount := VirtualShellHistory.Count;
    hctDeleted:
      VirtualStringTree1.RootNodeCount := VirtualShellHistory.Count;
    hctSelected:
      begin
        N := GetChildByIndex(VirtualStringTree1.RootNode, ItemIndex);
        VirtualStringTree1.Selected[N] := true;
        VirtualStringTree1.FocusedNode := N;
      end;
  end;
  VirtualStringTree1.Invalidate;
end;

procedure TForm1.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  if Assigned(Node) then
    CellText := VirtualShellHistory[Node.Index].NameInFolder;
end;

procedure TForm1.VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Assigned(Node) and (Kind in [ikSelected, ikNormal]) then
    ImageIndex := VirtualShellHistory[Node.Index].GetIconIndex(Kind = ikSelected, icLarge, true);
end;

procedure TForm1.VirtualStringTree1FocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if Assigned(Node) then
    VirtualShellHistory.ItemIndex := Node.Index;
end;

//WMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWMWM
{ Popups }

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
  VirtualShellHistory.FillPopupMenu(PopupMenu1, fpdNewestToOldest, 'Clear');
end;

procedure TForm1.PopupMenu2Popup(Sender: TObject);
begin
  VirtualShellHistory.FillPopupMenu(PopupMenu2, fpdOldestToNewest, 'Clear');
end;

procedure TForm1.PopUpMRUPopup(Sender: TObject);
begin
  VirtualShellMRU1.FillPopupMenu(PopUpMRU, fpdNewestToOldest, 'Clear MRU...');
end;

end.

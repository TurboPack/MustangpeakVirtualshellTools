{*****************************************************}
{                                                     }
{        Virtual Shell History With TBX Demo          }
{                                                     }
{  Requires TB2000                                    }
{           TBX                                       }
{                                                     }
{  Based on TB2000 Demo by Robert Lee                 }
{                                                     }
{  Updated by Aaron Chan and François Rivierre        }
{                                                     }
{ NOTE:                                               }
{  You must set the conditional defines in            }
{  VirtualShellHistory.pas, edit the dpk file and     }
{  then recompile the VSTools package to enable the   }
{  Toolbar 2000 extensions in VST.                    }
{                                                     }
{  Look in the (%VSTool)\Include\VSToolsAddIns.inc    }
{  for more information                               }
{                                                     }
{*****************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, ImgList, ComCtrls, ToolWin, ExtCtrls,
  StdCtrls, VirtualTrees, VirtualExplorerTree, VirtualShellUtilities,
  VirtualShellHistory, MPCommonObjects, MPCommonUtilities,
  TB2Dock, TB2Toolbar, TB2Item, TBX;

type
  TForm1 = class(TForm)
    VirtualExplorerTreeview1: TVirtualExplorerTreeview;
    VirtualExplorerListview1: TVirtualExplorerListview;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    ActionList1: TActionList;
    aBack: TAction;
    aNext: TAction;
    aHistory: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    VirtualStringTree1: TVirtualStringTree;
    VirtualShellHistory: TVirtualShellHistory;
    VirtualShellMRU1: TVirtualShellMRU;
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
    TBDock1: TTBDock;
    TBrowseToolbar: TTBXToolbar;
    t1Back: TTBXSubmenuItem;
    t1Next: TTBXSubmenuItem;
    t1MRU: TTBXSubmenuItem;
    TMenuToolbar: TTBXToolbar;
    t2Browse: TTBXSubmenuItem;
    TBSeparatorItem1: TTBXSeparatorItem;
    TBGroupItem1: TTBGroupItem;
    TBSeparatorItem2: TTBXSeparatorItem;
    t2Exit: TTBXItem;
    aExit: TAction;
    mBack: TTBXSubmenuItem;
    mNext: TTBXSubmenuItem;
    procedure aBackExecute(Sender: TObject);
    procedure aNextExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction;
      var Handled: Boolean);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
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
    procedure aExitExecute(Sender: TObject);
    procedure t1BackPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure t1NextPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure t1MRUPopup(Sender: TTBCustomItem; FromLink: Boolean);
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
  if ChildIndex > Count then Exit;

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

procedure TForm1.aExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  //Update the button actions
  aBack.Enabled := VirtualShellHistory.ItemIndex > 0;          //if the ItemIndex is valid
  aNext.Enabled := VirtualShellHistory.ItemIndex < VirtualShellHistory.Count-1; //if the ItemIndex is not the last item
  t1MRU.Enabled := VirtualShellMRU1.Count > 0;
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
        VirtualStringTree1.Selected[N] := True;
        VirtualStringTree1.FocusedNode := N;
      end;
  end;
  VirtualStringTree1.Invalidate;
end;

procedure TForm1.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
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

procedure TForm1.PopUpMRUPopup(Sender: TObject);
begin
  VirtualShellMRU1.FillPopupMenu(PopUpMRU, fpdNewestToOldest);
end;

procedure TForm1.t1BackPopup(Sender: TTBCustomItem; FromLink: Boolean);
begin
  // This event handler is shared between the menu and toolbar menuitems
  // To add unicode support use TSpTBXItem instead:
  // VirtualShellHistory.FillPopupMenu_TB2000(t1Back, TSpTBXItem, fpdNewestToOldest);
  VirtualShellHistory.FillPopupMenu_TB2000(t1Back, TTBXItem, fpdNewestToOldest);
end;

procedure TForm1.t1NextPopup(Sender: TTBCustomItem; FromLink: Boolean);
begin
  // This event handler is shared between the menu and toolbar menuitems
  // To add unicode support use TSpTBXItem instead:
  // VirtualShellHistory.FillPopupMenu_TB2000(t1Next, TSpTBXItem, fpdOldestToNewest);
  VirtualShellHistory.FillPopupMenu_TB2000(t1Next, TTBXItem, fpdOldestToNewest);
end;

procedure TForm1.t1MRUPopup(Sender: TTBCustomItem; FromLink: Boolean);
begin
  // Use the MRU to fill this menu
  // To add unicode support use TSpTBXItem instead:
  // VirtualShellMRU1.FillPopupMenu_TB2000(t1MRU, TSpTBXItem, fpdNewestToOldest, True, 'Clear MRU...');
  VirtualShellMRU1.FillPopupMenu_TB2000(t1MRU, TTBXItem, fpdNewestToOldest, 'Clear MRU...');
end;

end.

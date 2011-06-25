unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MPCommonObjects, EasyListview, VirtualExplorerEasyListview,
  MPCommonUtilities, MPShellUtilities;

type
  TForm1 = class(TForm)
    VirtualExplorerEasyListview1: TVirtualExplorerEasyListview;
    procedure VirtualExplorerEasyListview1ContextMenuShow(
      Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace;
      Menu: HMENU; var Allow: Boolean);
    procedure VirtualExplorerEasyListview1ContextMenuCmd(
      Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace;
      Verb: WideString; MenuItemID: Integer; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    CustomMenuID: Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.VirtualExplorerEasyListview1ContextMenuShow(
  Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace;
  Menu: HMENU; var Allow: Boolean);
begin
  // Add to the end;
  CustomMenuID := AddContextMenuItem(Menu, '-', -1);
  CustomMenuID := AddContextMenuItem(Menu, 'Custom Menu', -1);
end;

procedure TForm1.VirtualExplorerEasyListview1ContextMenuCmd(
  Sender: TCustomVirtualExplorerEasyListview; Namespace: TNamespace;
  Verb: WideString; MenuItemID: Integer; var Handled: Boolean);
begin
  if MenuItemID = CustomMenuID then
  begin
    beep;
  end
end;

end.

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, VirtualExplorerEasyListModeview, VirtualTrees,
  VirtualExplorerTree, StdCtrls, ComCtrls, MPCommonObjects, EasyListview,
  VirtualExplorerEasyListview;

type
  TForm1 = class(TForm)
    VirtualExplorerCombobox1: TVirtualExplorerCombobox;
    VirtualColumnModeView1: TVirtualColumnModeView;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure VirtualExplorerCombobox1Change(Sender: TObject);
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

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  VirtualColumnModeView1.Active := CheckBox1.Checked
end;

procedure TForm1.VirtualExplorerCombobox1Change(Sender: TObject);
begin
  VirtualColumnModeView1.Path := VirtualExplorerCombobox1.EditNamespace.Clone(True)
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 // VirtualColumnModeView1.Color := clWindow;
end;

end.
 
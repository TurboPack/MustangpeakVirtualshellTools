unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MPCommonObjects, EasyListview,
  VirtualExplorerEasyListview, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    VirtualExplorerEasyListview1: TVirtualExplorerEasyListview;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    ComboBox1: TComboBox;
    Splitter1: TSplitter;
    VirtualDropStack1: TVirtualDropStack;
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
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
  VirtualDropStack1.ShowHint := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  VirtualDropStack1.Items.Clear
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ComboBox1.ItemIndex := 0;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  VirtualDropStack1.View := TEasyListStyle(ComboBox1.ItemIndex)
end;

end.

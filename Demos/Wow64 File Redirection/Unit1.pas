unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, MPCommonObjects, EasyListview,
  VirtualExplorerEasyListview, MPCommonUtilities;

type
  TForm1 = class(TForm)
    VirtualExplorerEasyListview1: TVirtualExplorerEasyListview;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure CheckBox1Click(Sender: TObject);
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
  Wow64Enabled := CheckBox1.Checked;
  VirtualExplorerEasyListview1.Rebuild(True);
end;

end.

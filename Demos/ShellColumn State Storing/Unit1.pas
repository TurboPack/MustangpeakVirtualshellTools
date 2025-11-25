unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualExplorerTree, VirtualTrees, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    ExplorerTreeview1: TVirtualExplorerTreeview;
    Splitter1: TSplitter;
    ExplorerListview1: TVirtualExplorerListview;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ExplorerListview1.Storage.SaveToFile('Storage.dat');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ExplorerListview1.Storage.LoadFromFile('Storage.dat');
  ExplorerListview1.RefreshTree
end;

end.

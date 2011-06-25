program VirtualExplorer;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Virtual Explorer Demo for VirtualShellTools';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

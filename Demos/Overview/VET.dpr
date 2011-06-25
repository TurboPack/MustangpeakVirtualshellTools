program VET;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  InfoForm in 'InfoForm.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormInfo, FormInfo);
  Application.Run;
end.

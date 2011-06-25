program ExplorerCheckboxes;





uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  InfoForm in 'InfoForm.pas' {FormInfo},
  VirtualCheckboxesSynchronizer in 'VirtualCheckboxesSynchronizer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.


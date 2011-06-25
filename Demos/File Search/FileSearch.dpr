program FileSearch;

uses
  Forms,
  uWndSearchFiles in 'uWndSearchFiles.pas' {WndSearchFiles};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TWndSearchFiles, WndSearchFiles);
  Application.Run;
end.

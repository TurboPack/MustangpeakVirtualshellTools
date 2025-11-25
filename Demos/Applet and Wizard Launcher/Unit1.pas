unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AppletsAndWizards, Buttons, ExtCtrls, VirtualTrees,
  VirtualExplorerTree, MPShellUtilities;

type
  TForm1 = class(TForm)
    RadioGroupAccessability: TRadioGroup;
    RadioGroupInstallUninstall: TRadioGroup;
    RadioGroupScreenSettings: TRadioGroup;
    GroupBox1: TGroupBox;
    VET1: TVirtualExplorerTree;
    RadioGroupMiscWizards: TRadioGroup;
    RadioGroupInternet: TRadioGroup;
    RadioGroupRegional: TRadioGroup;
    RadioGroupControlPanel: TRadioGroup;
    RadioGroupMultiMedia: TRadioGroup;
    RadioGroupNetworkShare: TRadioGroup;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    RadioGroupSysSettings: TRadioGroup;
    Button10: TButton;
    RadioGroupTimeDate: TRadioGroup;
    Button11: TButton;
    RadioGroupModem: TRadioGroup;
    Button12: TButton;
    RadioGroupMiscApplet: TRadioGroup;
    Button13: TButton;
    GroupBox2: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton3: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton4: TSpeedButton;
    CheckBoxRootMyComputer: TCheckBox;
    Label5: TLabel;
    SpeedButton5: TSpeedButton;
    RadioGroupRunFile: TRadioGroup;
    Button14: TButton;
    Label6: TLabel;
    Bevel1: TBevel;
    SpeedButton6: TSpeedButton;
    Label7: TLabel;
    VirtualRunFileDialog1: TVirtualRunFileDialog;
    procedure VET1EnumFolder(
      Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
      var AllowAsChild: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure VET1DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure RunFileDialog1RunFile(RunFile, WorkingDirectory: String;
      var Result: TRunFileResult);
    procedure SpeedButton6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.VET1EnumFolder(
  Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
  var AllowAsChild: Boolean);
var
  s: string;
begin
  s := ExtractFileExt(AnsiLowerCaseFileName(Namespace.NameNormal));
  AllowAsChild := Pos('scr', s) <> 0;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Applets.NetworkShare( TShareWizard(RadioGroupNetworkShare.ItemIndex));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Applets.InternetSettingsDialog(RadioGroupInternet.ItemIndex);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Applets.RegionalSettingsDialog(RadioGroupRegional.ItemIndex);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Applets.AddRemoveProgramsDialog(RadioGroupInstallUninstall.ItemIndex);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Applets.AccessabilityDialog(RadioGroupAccessability.ItemIndex);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Applets.DisplayPropertiesDialog(RadioGroupScreenSettings.ItemIndex);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Applets.ControlPanel( TControlPanel(RadioGroupControlPanel.ItemIndex));
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  Applets.MultimediaSettingsDialog(RadioGroupMultiMedia.ItemIndex);
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Applets.MicrosoftApps( TMicrosoftApp(RadioGroupMiscWizards.ItemIndex));
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  Applets.SystemSettingsDialog( RadioGroupSysSettings.ItemIndex);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  Applets.TimeDateDialog( RadioGroupTimeDate.ItemIndex);
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  Applets.ModemSettingsDialog(TModemSettings( RadioGroupModem.ItemIndex));
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  Applets.MiscApplets( TMiscApplets( RadioGroupMiscApplet.ItemIndex));
end;

procedure TForm1.VET1DblClick(Sender: TObject);
var
  NS: TNamespace;
begin
  if (VET1.SelectedCount > 0) and VET1.ValidateNamespace(VET1.GetFirstSelected, NS) then
  Applets.InstallScreenSaver(NS.NameNormal);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Applets.SHFormatDrive('a');
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  Path: string;
  IconIndex: Longword;
begin
  Path := 'shell32.dll';
  Applets.SHPickIconDialog(Path, IconIndex);
  ShowMessage('Icon in : ' + Path + #13#10 + 'Index = ' + IntToStr(IconIndex));
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  Applets.SHRunFileDialog(0, 0, 'c:\', 'RunFile Dialog', 'Choose a file to run.', [roCalDirectory]);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  if CheckBoxRootMyComputer.Checked then
  begin
    { To use the Filter an *EXISTING* file must be used, you can't use wildcards}
    { To use a sample file do this:                                             }

    //   NS := TNamespace.CreateFromFileName('C:\MyDir\SomeFile.txt');
    //   Applets.SHFindFiles(DrivesFolder, NS);
    //   NS.Free;

    { DrivesFolder is global don't free it }
    Applets.SHFindFiles(DrivesFolder, nil);
  end else
    Applets.SHFindFiles(nil, nil);
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  Applets.SHFindComputer
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt.x := Button14.Left;
  Pt.y := Button14.Top;
  Pt := ClientToScreen(Pt);
  VirtualRunFileDialog1.Caption := 'Run Me!';
  VirtualRunFileDialog1.Description := 'Pick something to Run';
  VirtualRunFileDialog1.Position := Pt;
  VirtualRunFileDialog1.Run;
end;

procedure TForm1.RunFileDialog1RunFile(RunFile, WorkingDirectory: String;
  var Result: TRunFileResult);
begin
  Result := TRunFileResult( RadioGroupRunFile.ItemIndex);
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  Applets.CreateNewShortcut('C:\');
end;

end.

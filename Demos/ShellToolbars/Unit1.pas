unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShlObj, Buttons, ToolWin, ComCtrls, VirtualShellToolBar,
  ExtCtrls, VirtualTrees, VirtualExplorerTree, Menus, StdCtrls, MPShellUtilities;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Button4: TButton;
    Button5: TButton;
    RadioGroup1: TRadioGroup;
    CheckBox3: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    DriveToolbar1: TVirtualDriveToolbar;
    ShellToolbar1: TVirtualShellToolbar;
    ExplorerListview1: TVirtualExplorerListview;
    ExplorerTreeview1: TVirtualExplorerTreeview;
    Splitter1: TSplitter;
    SpecialFolderToolbar1: TVirtualSpecialFolderToolbar;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetToolbarsOptions(Include: boolean; Op: TVirtualToolbarOptions; CaptionOp: TCaptionOptions);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  ShellToolbarDataFile = 'Test.dat';
  ShellToolbarDataFile1 = 'Test1.dat';
  ShellToolbarDataFile2 = 'Test2.dat';

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit3.Text := IntToStr(ShellToolbar1.ButtonMargin);
  Edit4.Text := IntToStr(ShellToolbar1.ButtonSpacing);


{  if FileExistsW(ShellToolbarDataFile) then
   ShellToolbar1.ReadFromFile(ShellToolbarDataFile);

  if FileExistsW(ShellToolbarDataFile1) then
   ShellToolbar2.ReadFromFile(ShellToolbarDataFile1);

  if FileExistsW(ShellToolbarDataFile2) then
   ShellToolbar3.ReadFromFile(ShellToolbarDataFile2);

  if ShellToolbar1.AutoSize then
  begin
    ShellToolbar1.AutoSize := False;
    ShellToolbar1.AutoSize := True
  end         }
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
{  ShellToolbar1.WriteToFile(ShellToolbarDataFile);
  ShellToolbar2.WriteToFile(ShellToolbarDataFile1);
  ShellToolbar3.WriteToFile(ShellToolbarDataFile2);     }
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  ShellToolbar1.AutoSize := Checkbox1.Checked;
  DriveToolbar1.AutoSize := Checkbox1.Checked;
  SpecialFolderToolbar1.AutoSize := Checkbox1.Checked;
end;

procedure TForm1.CheckBox7Click(Sender: TObject);
begin
  SetToolbarsOptions(CheckBox7.Checked, [toEqualWidth], []);
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  SetToolbarsOptions(CheckBox2.Checked, [toFlat], []);
end;

procedure TForm1.CheckBox4Click(Sender: TObject);
begin
  SetToolbarsOptions(CheckBox4.Checked, [toTransparent], []);
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  SetToolbarsOptions(CheckBox3.Checked, [toTile], []);
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
  SetToolbarsOptions(CheckBox5.Checked, [], [coFolderName]);
end;

procedure TForm1.CheckBox6Click(Sender: TObject);
begin
  SetToolbarsOptions(CheckBox6.Checked, [], [coNoExtension]);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ShellToolbar1.ButtonMargin := StrToInt(Edit3.Text);
  SpecialFolderToolbar1.ButtonMargin := StrToInt(Edit3.Text);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  ShellToolbar1.ButtonSpacing := StrToInt(Edit4.Text);
  SpecialFolderToolbar1.ButtonSpacing := StrToInt(Edit4.Text);
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    0: ShellToolbar1.ButtonLayout := Buttons.blGlyphTop;
    1: ShellToolbar1.ButtonLayout := Buttons.blGlyphBottom;
    2: ShellToolbar1.ButtonLayout := Buttons.blGlyphLeft;
    3: ShellToolbar1.ButtonLayout := Buttons.blGlyphRight;
  end;

  DriveToolbar1.ButtonLayout := ShellToolbar1.ButtonLayout;
  SpecialFolderToolbar1.ButtonLayout := ShellToolbar1.ButtonLayout;
end;

procedure TForm1.SetToolbarsOptions(Include: boolean; Op: TVirtualToolbarOptions; CaptionOp: TCaptionOptions);
begin
  if Include then begin
     ShellToolbar1.Options := ShellToolbar1.Options + Op;
     DriveToolbar1.Options := DriveToolbar1.Options + Op;
     SpecialFolderToolbar1.Options := SpecialFolderToolbar1.Options + Op;

     ShellToolbar1.ButtonCaptionOptions := ShellToolbar1.ButtonCaptionOptions + CaptionOp;
     SpecialFolderToolbar1.ButtonCaptionOptions := SpecialFolderToolbar1.ButtonCaptionOptions + CaptionOp;
  end
  else begin
     ShellToolbar1.Options := ShellToolbar1.Options - Op;
     DriveToolbar1.Options := DriveToolbar1.Options - Op;
     SpecialFolderToolbar1.Options := SpecialFolderToolbar1.Options - Op;

     ShellToolbar1.ButtonCaptionOptions := ShellToolbar1.ButtonCaptionOptions - CaptionOp;
     SpecialFolderToolbar1.ButtonCaptionOptions := SpecialFolderToolbar1.ButtonCaptionOptions - CaptionOp;
  end;
end;

end.

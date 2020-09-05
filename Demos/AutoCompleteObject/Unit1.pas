unit Unit1;

// Demo of how to custom popuplate the Autocomple drop down

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, VirtualExplorerTree, ExtCtrls, VirtualTrees;

type
  TForm1 = class(TForm)
    ExplorerTreeview1: TVirtualExplorerTreeview;
    ExplorerListview1: TVirtualExplorerListview;
    ExplorerComboBox1: TVirtualExplorerCombobox;
    CheckBoxCustom: TCheckBox;
    Label1: TLabel;
    procedure ExplorerComboBox1AutoCompleteUpdateList(Sender: TObject;
      const CurrentEditContents: string; EnumList: TStringList;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.ExplorerComboBox1AutoCompleteUpdateList(Sender: TObject;
  const CurrentEditContents: string; EnumList: TStringList;
  var Handled: Boolean);
begin
  if CheckBoxCustom.Checked then
  begin
    Handled := True; // We are handling the autocomplete list
    EnumList.Add('C:\');
    EnumList.Add('C:\Windows');
    EnumList.Add('C:\Windows\System');
    EnumList.Add('C:\WinNT');
    EnumList.Add('C:\WinNT\System32');
    EnumList.Add('D:\');
    EnumList.Add('Control Panel');
    EnumList.Add('Recycle Bin');
  end;
end;

end.

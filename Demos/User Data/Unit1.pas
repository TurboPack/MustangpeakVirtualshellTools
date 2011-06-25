unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees, VirtualExplorerTree, MPShellUtilities;

type
  TForm1 = class(TForm)
    VET: TVirtualExplorerTree;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Label2: TLabel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


  // User Defined Per node Storage override this and use the Storage class in VET or the Global
  TMyUserDataStorage = class(TUserDataStorage)
  private
    FUserString: string;
  public
    //You should override these 3 methods in your application:
    procedure LoadFromStream(S: TStream; Version: integer = VETStreamStorageVer; ReadVerFromStream: Boolean = False); override;
    procedure SaveToStream(S: TStream; Version: integer = VETStreamStorageVer; WriteVerToStream: Boolean = False); override;
    procedure Assign(Source: TPersistent); override;

    property UserString: string read FUserString write FUserString;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TMyUserDataStorage }

procedure TMyUserDataStorage.Assign(Source: TPersistent);
begin
  if Source is TMyUserDataStorage then
    UserString := TMyUserDataStorage(Source).UserString;
  inherited;
end;

procedure TMyUserDataStorage.LoadFromStream(S: TStream; Version: integer;
  ReadVerFromStream: Boolean);
var
  Count: Integer;
begin
  inherited;
  S.read(Count, SizeOf(Count));
  SetLength(FUserString, Count);
  S.read(PChar(FUserString)^, Count)
end;

procedure TMyUserDataStorage.SaveToStream(S: TStream; Version: integer;
  WriteVerToStream: Boolean);
var
  Count: Integer;
begin
  inherited;
  Count := Length(FUserString);
  S.Write(Count, SizeOf(Count));
  S.Write(PChar(FUserString)^, Count)
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  NS: TNamespace;
  SNode: TNodeSTorage;
begin
  if VET.ValidateNamespace(VET.GetFirstSelected, NS) then
  begin
    SNode := VET.Storage.Store(NS.AbsolutePIDL, [stUser]);
    if Assigned(SNode) then
    begin
      SNode.Storage.UserData := TMyUserDataStorage.Create;
      TMyUserDataStorage(SNode.Storage.UserData).UserString := Edit1.Text
    end
  end
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  NS: TNamespace;
  SNode: TNodeSTorage;
begin
  if VET.ValidateNamespace(VET.GetFirstSelected, NS) then
     if VET.Storage.Find(NS.AbsolutePIDL, [stUser], SNode) then
       Label2.Caption := TMyUserDataStorage( SNode.Storage.UserData).UserString
     else
       ShowMessage('No User Data has been assiged to this node')
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  NS: TNamespace;
  SNode: TNodeSTorage;
begin
  if VET.ValidateNamespace(VET.GetFirstSelected, NS) then
     if VET.Storage.Find(NS.AbsolutePIDL, [stUser], SNode) then
     begin
       SNode.Storage.UserData.Free;
       SNode.Storage.UserData := nil;
       VET.Storage.Delete(NS.AbsolutePIDL, [stUser]);
     end else
       ShowMessage('No User Data has been assiged to this node')
end;

end.

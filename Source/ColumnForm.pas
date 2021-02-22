unit ColumnForm;

// Version 2.4.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------
//
// Modifications by Francois Rivierre, 2005-11-28, to allow runtime
// customization of internal strings.
//
//----------------------------------------------------------------------------

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  StdCtrls, ExtCtrls, VirtualTrees,
  ActiveX;

type
  TVETUpdate = procedure(Sender: TObject) of object;

type
  TFormColumnSettings = class(TForm)
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    EditPixelWidth: TEdit;
    CheckBoxLiveUpdate: TCheckBox;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    VSTColumnNames: TVirtualStringTree;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure VSTColumnNamesInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VSTColumnNamesChecking(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var NewState: TCheckState; var Allowed: Boolean);
    procedure VSTColumnNamesDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure VSTColumnNamesDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTColumnNamesDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer;
      Mode: TDropMode);
    procedure EditPixelWidthKeyPress(Sender: TObject; var Key: Char);
    procedure VSTColumnNamesFocusChanging(Sender: TBaseVirtualTree;
      OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure EditPixelWidthExit(Sender: TObject);
    procedure VSTColumnNamesFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure CheckBoxLiveUpdateClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VSTColumnNamesGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
  private
    FDragNode: PVirtualNode;
    FOnVETUpdate: TVETUpdate;
  private
    { Private declarations }
    property DragNode: PVirtualNode read FDragNode write FDragNode;
  public
    { Public declarations }
    property OnVETUpdate: TVETUpdate read FOnVETUpdate write FOnVETUpdate;
  end;

  PColumnData = ^TColumnData;
  TColumnData = packed record
    Title: string;
    Enabled: Boolean;
    Width: integer;
    ColumnIndex: integer;
  end;

var
  FormColumnSettings: TFormColumnSettings;

implementation

// < FR added 11-28-05 >
uses VirtualResources;
// </ FR added 11-28-05 >

{$R *.DFM}

procedure TFormColumnSettings.FormCreate(Sender: TObject);
begin
  VSTColumnNames.NodeDataSize := SizeOf(TColumnData);
end;

procedure TFormColumnSettings.VSTColumnNamesInitNode(
  Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  ColData: PColumnData;
begin
  ColData := PColumnData( Sender.GetNodeData(Node));
  Node.CheckType := ctCheckBox;
  if ColData.Enabled then
    Node.CheckState := csCheckedNormal
end;

procedure TFormColumnSettings.VSTColumnNamesChecking(
  Sender: TBaseVirtualTree; Node: PVirtualNode; var NewState: TCheckState;
  var Allowed: Boolean);
var
  ColData: PColumnData;
begin
  ColData := PColumnData( Sender.GetNodeData(Node));
  ColData.Enabled := NewState = csCheckedNormal;
  if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
    OnVetUpdate(Self);
  Allowed := True;
end;

procedure TFormColumnSettings.VSTColumnNamesDragOver(
  Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState;
  State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer;
  var Accept: Boolean);
begin
  Accept := True;
end;

procedure TFormColumnSettings.VSTColumnNamesDragAllowed(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := True;
  DragNode := Node;
end;

procedure TFormColumnSettings.VSTColumnNamesDragDrop(
  Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint;
  var Effect: Integer; Mode: TDropMode);
var
  i, TargetIndex, SourceIndex: integer;
  ChildNode: PVirtualNode;
begin
  ChildNode := VSTColumnNames.GetFirst;
  i := 0;
  TargetIndex := 0;
  SourceIndex := 0;
  while Assigned(ChildNode) do
  begin
    if ChildNode = VSTColumnNames.DropTargetNode then
      TargetIndex := i;
    if ChildNode = DragNode then
      SourceIndex := i;
    Inc(i);
    ChildNode := ChildNode.NextSibling
  end;
  if TargetIndex > SourceIndex then
    VSTColumnNames.MoveTo(DragNode, VSTColumnNames.DropTargetNode, amInsertAfter, False)
  else
    VSTColumnNames.MoveTo(DragNode, VSTColumnNames.DropTargetNode, amInsertBefore, False);
  if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
    OnVetUpdate(Self);
  DragNode := nil;
  Effect := DROPEFFECT_NONE;
end;

procedure TFormColumnSettings.EditPixelWidthKeyPress(Sender: TObject;
  var Key: Char);
var
  ColData: PColumnData;
  Node: PVirtualNode;
begin
  if ((Key < #48) or (Key > #57)) and not((Key = #8) or (Key = #13)) then
  begin
    beep;
    Key := #0;
  end;
  if (Key = #13) then
  begin
    Node := VSTColumnNames.GetFirstSelected;
    if Assigned(Node) then
    begin
      ColData := PColumnData( VSTColumnNames.GetNodeData(Node));
      ColData.Width := StrToInt(EditPixelWidth.Text);
      if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
        OnVetUpdate(Self);
    end;
    Key := #0;
  end
end;

procedure TFormColumnSettings.VSTColumnNamesFocusChanging(
  Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn,
  NewColumn: TColumnIndex; var Allowed: Boolean);
var
  ColData: PColumnData;
begin
  if Assigned(OldNode) then
  begin
    ColData := PColumnData( Sender.GetNodeData(OldNode));
    ColData.Width := StrToInt(EditPixelWidth.Text);
  end;
  if Assigned(NewNode) then
  begin
    ColData := PColumnData( Sender.GetNodeData(NewNode));
    EditPixelWidth.Text := IntToStr(ColData.Width);
  end;
  Allowed := True
end;

procedure TFormColumnSettings.EditPixelWidthExit(Sender: TObject);
var
  ColData: PColumnData;
  Node: PVirtualNode;
begin
  Node := VSTColumnNames.GetFirstSelected;
  if Assigned(Node) then
  begin
    ColData := PColumnData( VSTColumnNames.GetNodeData(Node));
    ColData.Width := StrToInt(EditPixelWidth.Text);
  end;
  if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
    OnVetUpdate(Self);
end;

procedure TFormColumnSettings.VSTColumnNamesFreeNode(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  ColData: PColumnData;
begin
  ColData := PColumnData( Sender.GetNodeData(Node));
  Finalize(ColData^);
end;

procedure TFormColumnSettings.CheckBoxLiveUpdateClick(Sender: TObject);
begin
  if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
    OnVetUpdate(Self);
end;

procedure TFormColumnSettings.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and not EditPixelWidth.Focused then
    ButtonOK.Click
  else
  if (Key = #27) then
    ButtonCancel.Click
end;

procedure TFormColumnSettings.FormResize(Sender: TObject);
const
  TextMargin = 4;
var
  B: integer;
begin
  B := (Width - (Label2.Width + Label3.Width + EditPixelWidth.Width)) div 2;
  Label2.Left := B - 2 * TextMargin;
  EditPixelWidth.Left := (Label2.Left + Label2.Width) + TextMargin;
  Label3.Left := (EditPixelWidth.Left + EditPixelWidth.Width) + TextMargin;
  CheckBoxLiveUpdate.Left := Label2.Left;
end;

// < FR added 11-28-05 >
// Here we load the strings variables. This allow runtime customization.
procedure TFormColumnSettings.FormShow(Sender: TObject);
begin
  Caption := STR_COLUMNDLG_CAPTION;
  Label1.Caption := STR_COLUMNDLG_LABEL1;
  Label2.Caption := STR_COLUMNDLG_LABEL2;
  Label3.Caption := STR_COLUMNDLG_LABEL3;
  CheckBoxLiveUpdate.Caption := STR_COLUMNDLG_CHECKBOXLIVEUPDATE;
  ButtonOk.Caption := STR_COLUMNDLG_BUTTONOK;
  ButtonCancel.Caption := STR_COLUMNDLG_BUTTONCANCEL;
end;
// </ FR added 11-28-05 >

procedure TFormColumnSettings.VSTColumnNamesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  ColData: PColumnData;
begin
  ColData := PColumnData( Sender.GetNodeData(Node));
  CellText := ColData.Title
end;

end.

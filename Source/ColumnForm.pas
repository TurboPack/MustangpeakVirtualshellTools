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
  TVETUpdate = procedure(ASender: TObject) of object;

type
  TFormColumnSettings = class(TForm)
    Bevel1: TBevel;
    ButtonCancel: TButton;
    ButtonOk: TButton;
    CheckBoxLiveUpdate: TCheckBox;
    EditPixelWidth: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    pnBottom: TPanel;
    VSTColumnNames: TVirtualStringTree;
    procedure CheckBoxLiveUpdateClick(ASender: TObject);
    procedure EditPixelWidthExit(ASender: TObject);
    procedure EditPixelWidthKeyPress(ASender: TObject; var AKey: Char);
    procedure FormCreate(ASender: TObject);
    procedure FormKeyPress(ASender: TObject; var AKey: Char);
    procedure FormResize(ASender: TObject);
    procedure FormShow(ASender: TObject);
    procedure VSTColumnNamesChecking(ASender: TBaseVirtualTree; ANode: PVirtualNode; var ANewState: TCheckState; var AAllowed: Boolean);
    procedure VSTColumnNamesDragAllowed(ASender: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex; var AAllowed: Boolean);
    procedure VSTColumnNamesDragDrop(ASender: TBaseVirtualTree; ASource: TObject; ADataObject: IDataObject; AFormats: TFormatArray; AShift: TShiftState; APoint: TPoint; var AEffect: Integer; AMode: TDropMode);
    procedure VSTColumnNamesDragOver(ASender: TBaseVirtualTree; ASource: TObject; AShift: TShiftState; AState: TDragState; APoint: TPoint; AMode: TDropMode; var AEffect: Integer; var AAccept: Boolean);
    procedure VSTColumnNamesFocusChanging(ASender: TBaseVirtualTree; AOldNode, NewNode: PVirtualNode; AOldColumn, ANewColumn: TColumnIndex; var AAllowed: Boolean);
    procedure VSTColumnNamesFreeNode(ASender: TBaseVirtualTree; ANode: PVirtualNode);
    procedure VSTColumnNamesGetText(ASender: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex; ATextType: TVSTTextType; var ACellText: string);
    procedure VSTColumnNamesInitNode(ASender: TBaseVirtualTree; AParentNode, ANode: PVirtualNode; var AInitialStates: TVirtualNodeInitStates);
  strict private
    FDragNode: PVirtualNode;
    FOnVETUpdate: TVETUpdate;
    property DragNode: PVirtualNode read FDragNode write FDragNode;
  public
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

{$R *.dfm}

uses
  VirtualResources;

{ TFormColumnSettings }

procedure TFormColumnSettings.CheckBoxLiveUpdateClick(ASender: TObject);
begin
  if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
    OnVetUpdate(Self);
end;

procedure TFormColumnSettings.EditPixelWidthExit(ASender: TObject);
var
  lColData: PColumnData;
  lNode: PVirtualNode;
begin
  lNode := VSTColumnNames.GetFirstSelected;
  if Assigned(lNode) then
  begin
    lColData := PColumnData(VSTColumnNames.GetNodeData(lNode));
    lColData.Width := MulDiv(StrToInt(EditPixelWidth.Text), CurrentPPI, Screen.DefaultPixelsPerInch);
  end;
  if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
    OnVetUpdate(Self);
end;

procedure TFormColumnSettings.EditPixelWidthKeyPress(ASender: TObject; var AKey: Char);
var
  lColData: PColumnData;
  lNode: PVirtualNode;
begin
  if ((AKey < #48) or (AKey > #57)) and not((AKey = #8) or (AKey = #13)) then
  begin
    Beep;
    AKey := #0;
  end;
  if (AKey = #13) then
  begin
    lNode := VSTColumnNames.GetFirstSelected;
    if Assigned(lNode) then
    begin
      lColData := PColumnData( VSTColumnNames.GetNodeData(lNode));
      lColData.Width := MulDiv(StrToInt(EditPixelWidth.Text), CurrentPPI, Screen.DefaultPixelsPerInch);
      if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
        OnVetUpdate(Self);
    end;
    AKey := #0;
  end
end;

procedure TFormColumnSettings.FormCreate(ASender: TObject);
begin
  VSTColumnNames.NodeDataSize := SizeOf(TColumnData);
end;

procedure TFormColumnSettings.FormKeyPress(ASender: TObject; var AKey: Char);
begin
  if (AKey = #13) and not EditPixelWidth.Focused then
    ButtonOK.Click
  else
  if (AKey = #27) then
    ButtonCancel.Click
end;

procedure TFormColumnSettings.FormResize(ASender: TObject);
const
  cTextMargin = 4;
var
  lWidth: Integer;
  lTextMargin: Integer;
begin
  lTextMargin := MulDiv(cTextMargin, CurrentPPI, Screen.DefaultPixelsPerInch);
  lWidth := (Width - (Label2.Width + Label3.Width + EditPixelWidth.Width)) div 2;
  Label2.Left := lWidth - 2 * lTextMargin;
  EditPixelWidth.Left := (Label2.Left + Label2.Width) + lTextMargin;
  Label3.Left := (EditPixelWidth.Left + EditPixelWidth.Width) + lTextMargin;
  CheckBoxLiveUpdate.Left := Label2.Left;
end;

// Here we load the strings variables. This allow runtime customization.
procedure TFormColumnSettings.FormShow(ASender: TObject);
begin
  Caption := STR_COLUMNDLG_CAPTION;
  Label1.Caption := STR_COLUMNDLG_LABEL1;
  Label2.Caption := STR_COLUMNDLG_LABEL2;
  Label3.Caption := STR_COLUMNDLG_LABEL3;
  CheckBoxLiveUpdate.Caption := STR_COLUMNDLG_CHECKBOXLIVEUPDATE;
  ButtonOk.Caption := STR_COLUMNDLG_BUTTONOK;
  ButtonCancel.Caption := STR_COLUMNDLG_BUTTONCANCEL;
end;

procedure TFormColumnSettings.VSTColumnNamesChecking(ASender: TBaseVirtualTree; ANode: PVirtualNode; var ANewState: TCheckState; var AAllowed: Boolean);
var
  lColData: PColumnData;
begin
  lColData := PColumnData(ASender.GetNodeData(ANode));
  lColData.Enabled := ANewState = csCheckedNormal;
  if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
    OnVetUpdate(Self);
  AAllowed := True;
end;

procedure TFormColumnSettings.VSTColumnNamesDragAllowed(ASender: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex; var AAllowed: Boolean);
begin
  AAllowed := True;
  DragNode := ANode;
end;

procedure TFormColumnSettings.VSTColumnNamesDragDrop(ASender: TBaseVirtualTree; ASource: TObject; ADataObject: IDataObject; AFormats: TFormatArray; AShift: TShiftState; APoint: TPoint; var AEffect: Integer; AMode: TDropMode);
var
  lChildNode: PVirtualNode;
  lCount: Integer;
  lSourceIndex: Integer;
  lTargetIndex: Integer;
begin
  lChildNode := VSTColumnNames.GetFirst;
  lCount := 0;
  lTargetIndex := 0;
  lSourceIndex := 0;
  while Assigned(lChildNode) do
  begin
    if lChildNode = VSTColumnNames.DropTargetNode then
      lTargetIndex := lCount;
    if lChildNode = DragNode then
      lSourceIndex := lCount;
    Inc(lCount);
    lChildNode := lChildNode.NextSibling
  end;
  if lTargetIndex > lSourceIndex then
    VSTColumnNames.MoveTo(DragNode, VSTColumnNames.DropTargetNode, amInsertAfter, False)
  else
    VSTColumnNames.MoveTo(DragNode, VSTColumnNames.DropTargetNode, amInsertBefore, False);
  if CheckBoxLiveUpdate.Checked and Assigned(OnVETUpdate) then
    OnVetUpdate(Self);
  DragNode := nil;
  AEffect := DROPEFFECT_NONE;
end;

procedure TFormColumnSettings.VSTColumnNamesDragOver(ASender: TBaseVirtualTree; ASource: TObject; AShift: TShiftState; AState: TDragState; APoint: TPoint; AMode: TDropMode; var AEffect: Integer; var AAccept: Boolean);
begin
  AAccept := True;
end;

procedure TFormColumnSettings.VSTColumnNamesFocusChanging(ASender: TBaseVirtualTree; AOldNode, NewNode: PVirtualNode; AOldColumn, ANewColumn: TColumnIndex; var AAllowed: Boolean);
var
  lColData: PColumnData;
begin
  if Assigned(AOldNode) then
  begin
    lColData := PColumnData( ASender.GetNodeData(AOldNode));
    lColData.Width := MulDiv(StrToInt(EditPixelWidth.Text), CurrentPPI, Screen.DefaultPixelsPerInch);
  end;
  if Assigned(NewNode) then
  begin
    lColData := PColumnData( ASender.GetNodeData(NewNode));
    EditPixelWidth.Text := MulDiv(lColData.Width, Screen.DefaultPixelsPerInch, CurrentPPI).ToString;
  end;
  AAllowed := True
end;

procedure TFormColumnSettings.VSTColumnNamesFreeNode(ASender: TBaseVirtualTree; ANode: PVirtualNode);
var
  lColData: PColumnData;
begin
  lColData := PColumnData(ASender.GetNodeData(ANode));
  Finalize(lColData^);
end;

procedure TFormColumnSettings.VSTColumnNamesGetText(ASender: TBaseVirtualTree; ANode: PVirtualNode; AColumn: TColumnIndex; ATextType: TVSTTextType; var ACellText: string);
var
  lColData: PColumnData;
begin
  lColData := PColumnData(ASender.GetNodeData(ANode));
  ACellText := lColData.Title
end;

procedure TFormColumnSettings.VSTColumnNamesInitNode(ASender: TBaseVirtualTree; AParentNode, ANode: PVirtualNode; var AInitialStates: TVirtualNodeInitStates);
var
  lColData: PColumnData;
begin
  lColData := PColumnData(ASender.GetNodeData(ANode));
  ANode.CheckType := ctCheckBox;
  if lColData.Enabled then
    ANode.CheckState := csCheckedNormal
end;

end.

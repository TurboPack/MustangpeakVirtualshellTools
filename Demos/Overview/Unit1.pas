Unit Unit1;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  VirtualTrees,
  VirtualExplorerTree,
  StdCtrls,
  FileCtrl,
  ExtCtrls,
  MPShellUtilities,
  Buttons,
  ExtDlgs,
  InfoForm, Menus;

Const
  ViewsConfigFile = 'Views.dat';

Type
  TDemoColor = (
    dcDropTargetBorder,
    dcDropTargetFill,
    dcHilightBorder,
    dcHilightFill,
    dcGridLine,
    dcHotTrack,
    dcSelectFill,
    dcSelectBorder,
    dcTreeLine
    );

Type
  TTextType = (
    ttGlobal,
    ttFolders,
    ttNonFolders,
    ttCompressed
    );

Type
  TForm1 = Class(TForm)
    PageControl1: TPageControl;
    TabSheetFolders: TTabSheet;
    TabSheetOptions: TTabSheet;
    TabSheetContextMenus: TTabSheet;
    GroupBoxRootFolder: TGroupBox;
    ComboBoxRootFolder: TComboBox;
    CheckBoxCustomRoot: TCheckBox;
    EditCustomRootFolderPath: TEdit;
    GroupBoxFilter: TGroupBox;
    CheckBoxFilter: TCheckBox;
    EditFilter: TEdit;
    GroupBoxFileObject: TGroupBox;
    CheckBoxFolderObject: TCheckBox;
    CheckBoxNonFolderObject: TCheckBox;
    CheckBoxHiddenObject: TCheckBox;
    GroupBoxBrowseTo: TGroupBox;
    EditBrowseTo: TEdit;
    CheckBoxBrowseToExpand: TCheckBox;
    CheckBoxBrowseToCollapseAll: TCheckBox;
    CheckBoxBrowseToSelect: TCheckBox;
    ButtonBrowseTo: TButton;
    CheckBoxBrowseToFocusVET: TCheckBox;
    GroupBoxShellOptions: TGroupBox;
    CheckBoxContextMenu: TCheckBox;
    CheckBoxImages: TCheckBox;
    CheckBoxFoldersExpandable: TCheckBox;
    CheckBoxDblClkExecute: TCheckBox;
    CheckBoxDragDrop: TCheckBox;
    CheckBoxChangeNotifierThread: TCheckBox;
    CheckBoxImageThread: TCheckBox;
    CheckBoxHideRootFolder: TCheckBox;
    CheckBoxAnimateExpand: TCheckBox;
    CheckBoxHideRecycleBin: TCheckBox;
    CheckBoxQueryInfoHint: TCheckBox;
    CheckBoxAutoScroll: TCheckBox;
    CheckBoxAutoExpand: TCheckBox;
    CheckBoxAutoDropExpand: TCheckBox;
    ComboBoxHintAnimation: TComboBox;
    LabelHintAnimation: TLabel;
    CheckBoxAutoScrollOnExpand: TCheckBox;
    CheckBoxEditable: TCheckBox;
    CheckBoxMultiSelect: TCheckBox;
    CheckBoxLargeImages: TCheckBox;
    TabSheetColumns: TTabSheet;
    GroupBoxDisableContextItem: TGroupBox;
    CheckBoxDisableCopy: TCheckBox;
    CheckBoxDisableCut: TCheckBox;
    CheckBoxDisableDelete: TCheckBox;
    CheckBoxDisableProperties: TCheckBox;
    Panel1: TPanel;
    GroupBoxCustomMenuItem: TGroupBox;
    GroupBoxContextMenuHelpStrings: TGroupBox;
    CheckBoxCustomMenuItem: TCheckBox;
    EditCustomMenuItem: TEdit;
    LabelContextMenuHelpString: TLabel;
    CheckBoxDisableRename: TCheckBox;
    CheckBoxDisableLink: TCheckBox;
    RadioGroupColumnType: TRadioGroup;
    GroupBoxColumnOptions: TGroupBox;
    CheckBoxShellHeaderMenu: TCheckBox;
    CheckBoxCustomColumn: TCheckBox;
    RadioGroupFileSizeFormat: TRadioGroup;
    TabSheetColumnVisual: TTabSheet;
    GroupBoxColumnVisualAttribs: TGroupBox;
    RadioGroupHeaderStyle: TRadioGroup;
    CheckBoxAutoResize: TCheckBox;
    CheckBoxColumnResizable: TCheckBox;
    CheckBoxColumnClkResizeable: TCheckBox;
    CheckBoxColumnDrag: TCheckBox;
    CheckBoxHotTrackHeader: TCheckBox;
    ColorDialog1: TColorDialog;
    CheckBoxRestrictDrag: TCheckBox;
    TabSheetColors: TTabSheet;
    OpenPictureDialog1: TOpenPictureDialog;
    GroupBoxTextColor: TGroupBox;
    LabelTextColorGlobal: TLabel;
    LabelTextColorFolder: TLabel;
    LabelTextColorNonFolders: TLabel;
    LabelTextColorCompressed: TLabel;
    ButtonTextColorGlobal: TButton;
    ButtonTextColorFolders: TButton;
    ButtonTextColorNonFolders: TButton;
    ButtonTextColorCompressed: TButton;
    GroupBoxAssortedColors: TGroupBox;
    LabelColorHilight: TLabel;
    LabelHilightBorder: TLabel;
    LabelHilightFill: TLabel;
    LabelSelectDragFill: TLabel;
    LabelSelectDragBorder: TLabel;
    ButtonHilightFill: TButton;
    ButtonHilightBorder: TButton;
    ButtonSelectDragFill: TButton;
    ButtonSelectDragBorder: TButton;
    LabelColorTreeLine: TLabel;
    ButtonColorTreeLine: TButton;
    LabelDropTargetRect: TLabel;
    LabelDropTargetBorder: TLabel;
    LabelDropTargetFill: TLabel;
    ButtonDropTargetFill: TButton;
    ButtonDropTargetBorder: TButton;
    LabelColorHotTrack: TLabel;
    ButtonColorHotTrack: TButton;
    CheckBoxHotTrack: TCheckBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    CheckBoxAlphaSelectRectDrag: TCheckBox;
    TabSheetGeneralVisual: TTabSheet;
    GroupBoxColumnColors: TGroupBox;
    LabelColumn1Color: TLabel;
    LabelColumn2Color: TLabel;
    LabelColumn3Color: TLabel;
    LabelColumn4Color: TLabel;
    LabelColumn5Color: TLabel;
    LabelColumn6Color: TLabel;
    LabelColumn7Color: TLabel;
    LabelColumn8Color: TLabel;
    ButtonColumn1Color: TButton;
    ButtonColumn2Color: TButton;
    ButtonColumn3Color: TButton;
    ButtonColumn4Color: TButton;
    ButtonColumn5Color: TButton;
    ButtonColumn6Color: TButton;
    ButtonColumn7Color: TButton;
    ButtonColumn8Color: TButton;
    RadioGroupExpandButtonFill: TRadioGroup;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    EditVisualBkGnd: TEdit;
    ButtonVisualBkGnd: TButton;
    CheckBoxVisualBkGnd: TCheckBox;
    RadioGroupExpandButtonStyle: TRadioGroup;
    TabSheetExplorer: TTabSheet;
    PanelVET: TPanel;
    VET1: TVirtualExplorerTree;
    PanelExplorer: TPanel;
    ExplorerTreeview1: TVirtualExplorerTreeview;
    ExplorerComboBox1: TVirtualExplorerCombobox;
    ExplorerListview1: TVirtualExplorerListview;
    Splitter1: TSplitter;
    TabSheetSyncronization: TTabSheet;
    PanelSyncro: TPanel;
    VETSyncro1: TVirtualExplorerTree;
    VETSyncro2: TVirtualExplorerTree;
    Splitter2: TSplitter;
    GroupBoxSyncroOptions: TGroupBox;
    CheckBoxSyncroCollapseFirst: TCheckBox;
    CheckBoxSyncroExpandTarget: TCheckBox;
    CheckBoxSyncroSelectTarget: TCheckBox;
    Panel3: TPanel;
    GroupBoxExplorerOptions: TGroupBox;
    LabelComboBoxDropCount: TLabel;
    LabelComboBoxRollDownSpeed: TLabel;
    CheckBoxComboboxExtended: TCheckBox;
    EditComboBoxDropCount: TEdit;
    CheckBoxComboBoxSizable: TCheckBox;
    CheckBoxComboBoxSizePersistence: TCheckBox;
    EditComboBoxRollDownSpeed: TEdit;
    GroupBoxExplorerListviewOptions: TGroupBox;
    CheckBoxPersistentColumns: TCheckBox;
    TabSheetViews: TTabSheet;
    GroupBoxViews: TGroupBox;
    ButtonViewsSnapshot: TButton;
    ButtonViewsDelete: TButton;
    ListBoxViews: TListBox;
    RadioButtonComboBoxNameOnlyEdit: TRadioButton;
    RadioButtonComboBoxFullPathEdit: TRadioButton;
    PanelVETChecks: TPanel;
    VETChecks: TVirtualExplorerTree;
    TabSheetCheckboxes: TTabSheet;
    TabSheetTNamespace: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Bevel4: TBevel;
    CheckBoxTNamespace: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel4: TPanel;
    Label11: TLabel;
    ComboBoxECBStyle: TComboBox;
    Label12: TLabel;
    PopupMenuShellContextMenu: TPopupMenu;
    Item1: TMenuItem;
    N1: TMenuItem;
    Item2: TMenuItem;
    N3: TMenuItem;
    Item4: TMenuItem;
    Item3: TMenuItem;
    Procedure FormCreate(Sender: TObject);
    Procedure ComboBoxRootFolderChange(Sender: TObject);
    Procedure CheckBoxCustomRootClick(Sender: TObject);
    Procedure ButtonSetRootFolderClick(Sender: TObject);
    Procedure CheckBoxFolderObjectClick(Sender: TObject);
    Procedure CheckBoxNonFolderObjectClick(Sender: TObject);
    Procedure CheckBoxHiddenObjectClick(Sender: TObject);
    Procedure VET1EnumFolder(Sender: TCustomVirtualExplorerTree;
      Namespace: TNamespace; Var AllowAsChild: Boolean);
    Procedure CheckBoxFilterClick(Sender: TObject);
    Procedure EditFilterKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure EditFilterExit(Sender: TObject);
    Procedure EditCustomRootFolderPathExit(Sender: TObject);
    Procedure EditCustomRootFolderPathKeyDown(Sender: TObject;
      Var Key: Word; Shift: TShiftState);
    Procedure EditCustomRootFolderPathChange(Sender: TObject);
    Procedure EditFilterChange(Sender: TObject);
    Procedure ButtonBrowseToClick(Sender: TObject);
    Procedure CheckBoxContextMenuClick(Sender: TObject);
    Procedure CheckBoxDragDropClick(Sender: TObject);
    Procedure CheckBoxQueryInfoHintClick(Sender: TObject);
    Procedure CheckBoxImagesClick(Sender: TObject);
    Procedure CheckBoxImageThreadClick(Sender: TObject);
    Procedure CheckBoxLargeImagesClick(Sender: TObject);
    Procedure CheckBoxDblClkExecuteClick(Sender: TObject);
    Procedure CheckBoxChangeNotifierThreadClick(Sender: TObject);
    Procedure CheckBoxFoldersExpandableClick(Sender: TObject);
    Procedure CheckBoxHideRootFolderClick(Sender: TObject);
    Procedure CheckBoxHideRecycleBinClick(Sender: TObject);
    Procedure CheckBoxAnimateExpandClick(Sender: TObject);
    Procedure ComboBoxHintAnimationChange(Sender: TObject);
    Procedure CheckBoxAutoExpandClick(Sender: TObject);
    Procedure CheckBoxAutoDropExpandClick(Sender: TObject);
    Procedure CheckBoxAutoScrollClick(Sender: TObject);
    Procedure CheckBoxAutoScrollOnExpandClick(Sender: TObject);
    Procedure CheckBoxEditableClick(Sender: TObject);
    Procedure CheckBoxMultiSelectClick(Sender: TObject);
    Procedure VET1ContextMenuShow(Sender: TCustomVirtualExplorerTree;
      Namespace: TNamespace; Menu: HMENU; Var Allow: Boolean);
    Procedure VET1ContextMenuItemChange(Sender: TCustomVirtualExplorerTree;
      Namespace: TNamespace; MenuItemID: Integer; SubMenuID: HMENU;
      MouseSelect: Boolean);
    Procedure CheckBoxCustomMenuItemClick(Sender: TObject);
    Procedure VET1ContextMenuCmd(Sender: TCustomVirtualExplorerTree;
      Namespace: TNamespace; Verb: string; MenuItemID: Integer;
      Var Handled: Boolean);
    Procedure RadioGroupColumnTypeClick(Sender: TObject);
    Procedure VET1Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
    Procedure CheckBoxShellHeaderMenuClick(Sender: TObject);
    Procedure VET1HeaderRebuild(Sender: TCustomVirtualExplorerTree;
      Header: TVTHeader);
    Procedure VET1CustomColumnCompare(Sender: TCustomVirtualExplorerTree;
      Column: TColumnIndex; Node1, Node2: PVirtualNode; Var Result: Integer);
    Procedure CheckBoxCustomColumnClick(Sender: TObject);
    Procedure RadioGroupFileSizeFormatClick(Sender: TObject);
    Procedure RadioGroupHeaderStyleClick(Sender: TObject);
    Procedure CheckBoxAutoResizeClick(Sender: TObject);
    Procedure CheckBoxColumnResizableClick(Sender: TObject);
    Procedure CheckBoxColumnClkResizeableClick(Sender: TObject);
    Procedure CheckBoxColumnDragClick(Sender: TObject);
    Procedure CheckBoxHotTrackHeaderClick(Sender: TObject);
    Procedure CheckBoxRestrictDragClick(Sender: TObject);
    Procedure SpeedButtonColumn1ColorClick(Sender: TObject);
    Procedure ButtonColumn1ColorClick(Sender: TObject);
    Procedure ButtonColumn2ColorClick(Sender: TObject);
    Procedure ButtonColumn3ColorClick(Sender: TObject);
    Procedure ButtonColumn4ColorClick(Sender: TObject);
    Procedure ButtonColumn5ColorClick(Sender: TObject);
    Procedure ButtonColumn6ColorClick(Sender: TObject);
    Procedure ButtonColumn7ColorClick(Sender: TObject);
    Procedure ButtonColumn8ColorClick(Sender: TObject);
    Procedure ButtonVisualBkGndClick(Sender: TObject);
    Procedure CheckBoxVisualBkGndClick(Sender: TObject);
    Procedure ButtonTextColorGlobalClick(Sender: TObject);
    Procedure ButtonTextColorFoldersClick(Sender: TObject);
    Procedure ButtonTextColorNonFoldersClick(Sender: TObject);
    Procedure ButtonTextColorCompressedClick(Sender: TObject);
    Procedure ButtonHilightFillClick(Sender: TObject);
    Procedure ButtonHilightBorderClick(Sender: TObject);
    Procedure ButtonDropTargetFillClick(Sender: TObject);
    Procedure ButtonDropTargetBorderClick(Sender: TObject);
    Procedure ButtonSelectDragFillClick(Sender: TObject);
    Procedure ButtonSelectDragBorderClick(Sender: TObject);
    Procedure ButtonColorTreeLineClick(Sender: TObject);
    Procedure ButtonColorHotTrackClick(Sender: TObject);
    Procedure CheckBoxHotTrackClick(Sender: TObject);
    Procedure CheckBoxAlphaSelectRectDragClick(Sender: TObject);
    Procedure RadioGroupExpandButtonFillClick(Sender: TObject);
    Procedure RadioGroupExpandButtonStyleClick(Sender: TObject);
    Procedure TabSheetExplorerShow(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure CheckBoxPersistentColumnsClick(Sender: TObject);
    Procedure CheckBoxComboboxExtendedClick(Sender: TObject);
    Procedure EditComboBoxDropCountKeyPress(Sender: TObject;
      Var Key: Char);
    Procedure ExplorerComboBox1DropDown(Sender: TCustomVirtualExplorerCombobox;
      Var Allow: Boolean);
    Procedure TabSheetSyncronizationShow(Sender: TObject);
    Procedure TabSheetNormalShow(Sender: TObject);
    Procedure CheckBoxSyncroCollapseFirstClick(Sender: TObject);
    Procedure CheckBoxSyncroExpandTargetClick(Sender: TObject);
    Procedure CheckBoxSyncroSelectTargetClick(Sender: TObject);
    Procedure CheckBoxComboBoxSizableClick(Sender: TObject);
    Procedure EditComboBoxRollDownSpeedKeyPress(Sender: TObject; Var Key: Char);
    Procedure CheckBoxComboBoxSizePersistenceClick(Sender: TObject);
    Procedure ButtonViewsSnapshotClick(Sender: TObject);
    Procedure ButtonViewsDeleteClick(Sender: TObject);
    Procedure ListBoxViewsClick(Sender: TObject);
    Procedure RadioButtonComboBoxNameOnlyEditClick(Sender: TObject);
    Procedure RadioButtonComboBoxFullPathEditClick(Sender: TObject);
    Procedure TabSheetCheckboxesShowShow(Sender: TObject);
    Procedure VETChecksInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; Var InitialStates: TVirtualNodeInitStates);
    Procedure TabSheetTNamespaceShow(Sender: TObject);
    Procedure CheckBoxTNamespaceClick(Sender: TObject);
    Procedure ComboBoxECBStyleChange(Sender: TObject);
    procedure Item1Click(Sender: TObject);
    procedure Item4Click(Sender: TObject);
    procedure Item2Click(Sender: TObject);
    procedure Item3Click(Sender: TObject);
    procedure VET1GetVETText(Sender: TCustomVirtualExplorerTree;
      Column: TColumnIndex; Node: PVirtualNode; Namespace: TNamespace;
      var Text: string);
  Private
    { Private declarations }
    FEditCustomRootFolderPathDirty: Boolean;
    FEditFilterDirty: Boolean;
    FCustomMenuItemID: Integer;
    FCustomColumn: integer;

    Procedure RefreshTree;
    Procedure SetAnimateOption(Option: TVTAnimationOption; SetOption: Boolean);
    Procedure SetAutoOption(Option: TVTAutoOption; SetOption: Boolean);
    Procedure SetColors(ColorType: TDemoColor; ColorText: TLabel);
    Procedure SetColumnColor(ColumnNumber: Integer; ColorText: TLabel);
    Procedure SetTextColor(TextType: TTextType; ColorText: TLabel);
    Procedure SetCustomRootPath;
    Procedure SetFilterString;
    Procedure SetHeaderOption(Option: TVTHeaderOption; SetOption: Boolean);
    Procedure SetMiscOption(Option: TVTMiscOption; SetOption: Boolean);
    Procedure SetPaintOption(Option: TVTPaintOption; SetOption: Boolean);
    Procedure SetSelectionOption(Option: TVTSelectionOption; SetOption: Boolean);
    Procedure SetSyncroOption(Option: TVETSyncOption; SetOption: Boolean);
    Procedure SetVETShellOption(Option: TVETShellOption; SetOption: Boolean);
    Procedure SetVETMiscOption(Option: TVETMiscOption; SetOption: Boolean);
    Procedure SetVETImageOption(Option: TVETImageOption; SetOption: Boolean);
    Procedure SetVETFolderOption(Option: TVETFolderOption; SetOption: Boolean);
  Public
    { Public declarations }
  End;

Var
  Form1: TForm1;

Implementation

{$R *.DFM}

Procedure TForm1.ButtonBrowseToClick(Sender: TObject);
Begin
  VET1.BrowseTo(EditBrowseTo.Text, CheckBoxBrowseToExpand.Checked,
    CheckBoxBrowseToSelect.Checked, CheckBoxBrowseToFocusVET.Checked,
    CheckBoxBrowseToCollapseAll.Checked);
End;

Procedure TForm1.ButtonColorHotTrackClick(Sender: TObject);
Begin
  SetColors(dcHotTrack, LabelColorHotTrack)
End;

Procedure TForm1.ButtonColorTreeLineClick(Sender: TObject);
Begin
  SetColors(dcTreeLine, LabelColorTreeLine)
End;

Procedure TForm1.ButtonColumn1ColorClick(Sender: TObject);
Begin
  SetColumnColor(0, LabelColumn1Color);
End;

Procedure TForm1.ButtonColumn2ColorClick(Sender: TObject);
Begin
  SetColumnColor(1, LabelColumn2Color);
End;

Procedure TForm1.ButtonColumn3ColorClick(Sender: TObject);
Begin
  SetColumnColor(2, LabelColumn3Color);
End;

Procedure TForm1.ButtonColumn4ColorClick(Sender: TObject);
Begin
  SetColumnColor(3, LabelColumn4Color);
End;

Procedure TForm1.ButtonColumn5ColorClick(Sender: TObject);
Begin
  SetColumnColor(4, LabelColumn5Color);
End;

Procedure TForm1.ButtonColumn6ColorClick(Sender: TObject);
Begin
  SetColumnColor(5, LabelColumn6Color);
End;

Procedure TForm1.ButtonColumn7ColorClick(Sender: TObject);
Begin
  SetColumnColor(6, LabelColumn7Color);
End;

Procedure TForm1.ButtonColumn8ColorClick(Sender: TObject);
Begin
  SetColumnColor(7, LabelColumn8Color);
End;

Procedure TForm1.ButtonDropTargetBorderClick(Sender: TObject);
Begin
  SetColors(dcDropTargetBorder, LabelDropTargetBorder)
End;

Procedure TForm1.ButtonDropTargetFillClick(Sender: TObject);
Begin
  SetColors(dcDropTargetFill, LabelDropTargetFill)
End;

Procedure TForm1.ButtonHilightBorderClick(Sender: TObject);
Begin
  SetColors(dcHilightBorder, LabelHilightBorder)
End;

Procedure TForm1.ButtonHilightFillClick(Sender: TObject);
Begin
  SetColors(dcHilightFill, LabelHilightFill)
End;

Procedure TForm1.ButtonSelectDragBorderClick(Sender: TObject);
Begin
  SetColors(dcSelectBorder, LabelSelectDragBorder)
End;

Procedure TForm1.ButtonSelectDragFillClick(Sender: TObject);
Begin
  SetColors(dcSelectFill, LabelSelectDragFill)
End;

Procedure TForm1.ButtonSetRootFolderClick(Sender: TObject);
Begin
  If SysUtils.DirectoryExists(EditCustomRootFolderPath.Text) Then
    VET1.RootFolderCustomPath := EditCustomRootFolderPath.Text
End;

Procedure TForm1.ButtonTextColorCompressedClick(Sender: TObject);
Begin
  SetTextColor(ttCompressed, LabelTextColorCompressed)
End;

Procedure TForm1.ButtonTextColorFoldersClick(Sender: TObject);
Begin
  SetTextColor(ttFolders, LabelTextColorFolder)
End;

Procedure TForm1.ButtonTextColorGlobalClick(Sender: TObject);
Begin
  SetTextColor(ttGlobal, LabelTextColorGlobal)
End;

Procedure TForm1.ButtonTextColorNonFoldersClick(Sender: TObject);
Begin
  SetTextColor(ttNonFolders, LabelTextColorNonFolders)
End;

Procedure TForm1.ButtonViewsDeleteClick(Sender: TObject);
Var
  OldIndex: integer;
Begin
  OldIndex := ListBoxViews.ItemIndex;
  VET1.ViewManager.DeleteView(ListBoxViews.Items[ListBoxViews.ItemIndex]);
  ListBoxViews.Items.Delete(ListBoxViews.ItemIndex);
  If ListBoxViews.Items.Count < OldIndex Then
    ListBoxViews.ItemIndex := OldIndex
  Else
    ListBoxViews.ItemIndex := ListBoxViews.Items.Count - 1;
  VET1.ViewManager.SaveToFile(ViewsConfigFile);
End;

Procedure TForm1.ButtonViewsSnapshotClick(Sender: TObject);
Var
  ViewName: String;
  FileName: String;
Begin
  If InputQuery('Add View', 'Enter a name for the new View', ViewName) Then Begin
    VET1.ViewManager.Snapshot(ViewName, VET1);
    ListBoxViews.ItemIndex := ListBoxViews.Items.Add(ViewName);
    SetLength(FileName, MAX_PATH);
    GetModuleFilename(0, PChar(FileName), MAX_PATH);
    SetLength(FileName, StrLen(PChar(FileName)));
    VET1.ViewManager.SaveToFile(ViewsConfigFile);
  End;
End;

Procedure TForm1.ButtonVisualBkGndClick(Sender: TObject);
Begin
  If OpenPictureDialog1.Execute Then Begin
    Try
      VET1.Background.LoadFromFile(OpenPictureDialog1.FileName);
      EditVisualBkGnd.Text := OpenPictureDialog1.FileName;
      VET1.Invalidate;
    Except
      EditVisualBkGnd.Text := '';
    End
  End
End;

Procedure TForm1.CheckBoxTNamespaceClick(Sender: TObject);
Var
  NS: TNamespace;
Begin
  FormInfo.Visible := CheckBoxTNamespace.Checked;
  If VET1.ValidateNamespace(VET1.GetFirstSelected, NS) And CheckBoxTNamespace.Checked Then
    FormInfo.UpdateInfo(NS);
End;

Procedure TForm1.CheckBoxAlphaSelectRectDragClick(Sender: TObject);
Begin
  VET1.DrawSelectionMode := TVTDrawSelectionMode(CheckBoxAlphaSelectRectDrag.Checked)
End;

Procedure TForm1.CheckBoxAnimateExpandClick(Sender: TObject);
Begin
  SetAnimateOption(toAnimatedToggle, CheckBoxAnimateExpand.Checked)
End;

Procedure TForm1.CheckBoxAutoDropExpandClick(Sender: TObject);
Begin
  SetAutoOption(toAutoDropExpand, CheckBoxAutoDropExpand.Checked);
End;

Procedure TForm1.CheckBoxAutoExpandClick(Sender: TObject);
Begin
  SetAutoOption(toAutoExpand, CheckBoxAutoExpand.Checked);
End;

Procedure TForm1.CheckBoxAutoResizeClick(Sender: TObject);
Begin
  SetHeaderOption(hoAutoResize, CheckBoxAutoResize.Checked);
End;

Procedure TForm1.CheckBoxAutoScrollClick(Sender: TObject);
Begin
  SetAutoOption(toAutoScroll, CheckBoxAutoScroll.Checked);
End;

Procedure TForm1.CheckBoxAutoScrollOnExpandClick(Sender: TObject);
Begin
  SetAutoOption(toAutoScrollOnExpand, CheckBoxAutoScrollOnExpand.Checked);
End;

Procedure TForm1.CheckBoxChangeNotifierThreadClick(Sender: TObject);
Begin
  SetVETMiscOption(toChangeNotifierThread, CheckBoxChangeNotifierThread.Checked);
End;

Procedure TForm1.CheckBoxColumnClkResizeableClick(Sender: TObject);
Begin
  SetHeaderOption(hoDblClickResize, CheckBoxColumnClkResizeable.Checked);
End;

Procedure TForm1.CheckBoxColumnDragClick(Sender: TObject);
Begin
  SetHeaderOption(hoDrag, CheckBoxColumnDrag.Checked);
End;

Procedure TForm1.CheckBoxColumnResizableClick(Sender: TObject);
Begin
  SetHeaderOption(hoColumnResize, CheckBoxColumnResizable.Checked);
End;

Procedure TForm1.CheckBoxComboboxExtendedClick(Sender: TObject);
Begin
  With ExplorerComboBox1.PopupExplorerOptions Do
    If CheckBoxComboboxExtended.Checked Then ComboBoxStyle := cbsVETEnhanced
    Else ComboBoxStyle := cbsClassic;
End;

Procedure TForm1.CheckBoxComboBoxSizableClick(Sender: TObject);
Begin
  With ExplorerComboBox1.PopupExplorerOptions Do
    If CheckBoxComboBoxSizable.Checked Then
      Options := Options + [poSizeable]
    Else
      Options := Options - [poSizeable]
End;

Procedure TForm1.CheckBoxComboBoxSizePersistenceClick(Sender: TObject);
Begin
  With ExplorerComboBox1.PopupExplorerOptions Do
    If CheckBoxComboBoxSizePersistence.Checked Then
      Options := Options + [poPersistentSizing]
    Else
      Options := Options - [poPersistentSizing]
End;

Procedure TForm1.CheckBoxContextMenuClick(Sender: TObject);
Begin
  SetVETShellOption(toContextMenus, CheckBoxContextMenu.Checked);
End;

Procedure TForm1.CheckBoxCustomColumnClick(Sender: TObject);
Var
  NS: TNamespace;
Begin
  If Not CheckBoxCustomColumn.Checked Then Begin
    If (FCustomColumn > -1) And (FCustomColumn < VET1.Header.Columns.Count) Then
      VET1.Header.Columns.Delete(FCustomColumn);
    FCustomColumn := -1;
  End Else Begin
    If VET1.ValidateNamespace(VET1.FocusedNode, NS) Then Begin
      VET1.RebuildHeader(NS)
    End
  End
End;

Procedure TForm1.CheckBoxCustomMenuItemClick(Sender: TObject);
Begin
  EditCustomMenuItem.Enabled := CheckBoxCustomMenuItem.Checked;
  if CheckBoxCustomMenuItem.Checked then
    VET1.ShellContextSubMenu := PopupMenuShellContextMenu
  else
    VET1.ShellContextSubMenu := nil
End;

Procedure TForm1.CheckBoxCustomRootClick(Sender: TObject);
Begin
  ComboboxRootFolder.Enabled := Not CheckBoxCustomRoot.Checked;
  EditCustomRootFolderPath.Enabled := CheckBoxCustomRoot.Checked;
  If ComboboxRootFolder.Enabled Then
    VET1.RootFolder := TRootFolder(ComboboxRootFolder.ItemIndex)
  Else Begin
    FEditCustomRootFolderPathDirty := True;
    SetCustomRootPath;
  End
End;

Procedure TForm1.CheckBoxDblClkExecuteClick(Sender: TObject);
Begin
  SetVETMiscOption(toExecuteOnDblClk, CheckBoxDblClkExecute.Checked);
End;

Procedure TForm1.CheckBoxDragDropClick(Sender: TObject);
Begin
  SetVETShellOption(toDragDrop, CheckBoxDragDrop.Checked);
End;

Procedure TForm1.CheckBoxEditableClick(Sender: TObject);
Begin
  SetMiscOption(toEditable, CheckBoxEditable.Checked);
End;

Procedure TForm1.CheckBoxFilterClick(Sender: TObject);
Begin
  { This ensures max performance if the Filter is not used }
  If CheckBoxFilter.Checked Then
    VET1.OnEnumFolder := VET1EnumFolder
  Else
    VET1.OnEnumFolder := Nil;
  RefreshTree;
End;

Procedure TForm1.CheckBoxFolderObjectClick(Sender: TObject);
Begin
  If CheckBoxFolderObject.Checked Then
    VET1.FileObjects := VET1.FileObjects + [foFolders]
  Else
    VET1.FileObjects := VET1.FileObjects - [foFolders]
End;

Procedure TForm1.CheckBoxFoldersExpandableClick(Sender: TObject);
Begin
  SetVETFolderOption(toFoldersExpandable, CheckBoxFoldersExpandable.Checked);
End;

Procedure TForm1.CheckBoxHiddenObjectClick(Sender: TObject);
Begin
  If CheckBoxHiddenObject.Checked Then
    VET1.FileObjects := VET1.FileObjects + [foHidden]
  Else
    VET1.FileObjects := VET1.FileObjects - [foHidden]
End;

Procedure TForm1.CheckBoxHideRecycleBinClick(Sender: TObject);
Begin
  SetVETFolderOption(toForceHideRecycleBin, CheckBoxHideRecycleBin.Checked);
End;

Procedure TForm1.CheckBoxHideRootFolderClick(Sender: TObject);
Begin
  SetVETFolderOption(toHideRootFolder, CheckBoxHideRootFolder.Checked);
End;

Procedure TForm1.CheckBoxHotTrackClick(Sender: TObject);
Begin
  SetPaintOption(toHotTrack, CheckBoxHotTrack.Checked)
End;

Procedure TForm1.CheckBoxHotTrackHeaderClick(Sender: TObject);
Begin
  SetHeaderOption(hoHotTrack, CheckBoxHotTrackHeader.Checked);
End;

Procedure TForm1.CheckBoxImagesClick(Sender: TObject);
Begin
  SetVETImageOption(toImages, CheckBoxImages.Checked);
End;

Procedure TForm1.CheckBoxImageThreadClick(Sender: TObject);
Begin
  SetVETImageOption(toThreadedImages, CheckBoxImageThread.Checked);
End;

Procedure TForm1.CheckBoxLargeImagesClick(Sender: TObject);
Begin
  SetVETImageOption(toLargeImages, CheckBoxLargeImages.Checked);
  If CheckBoxLargeImages.Checked Then
    VET1.DefaultNodeHeight := GetSystemMetrics(SM_CXICON) + 1
  Else
    VET1.DefaultNodeHeight := 17;
  RefreshTree;
End;

Procedure TForm1.CheckBoxMultiSelectClick(Sender: TObject);
Begin
  SetSelectionOption(toMultiSelect, CheckBoxMultiSelect.Checked);
End;

Procedure TForm1.CheckBoxNonFolderObjectClick(Sender: TObject);
Begin
  If CheckBoxNonFolderObject.Checked Then
    VET1.FileObjects := VET1.FileObjects + [foNonFolders]
  Else
    VET1.FileObjects := VET1.FileObjects - [foNonFolders]
End;

Procedure TForm1.CheckBoxPersistentColumnsClick(Sender: TObject);
Begin
  If CheckBoxPersistentColumns.Checked Then
    ExplorerListview1.TreeOptions.VETMiscOptions := VET1.TreeOptions.VETMiscOptions + [toPersistentColumns]
  Else
    ExplorerListview1.TreeOptions.VETMiscOptions := VET1.TreeOptions.VETMiscOptions - [toPersistentColumns]
End;

Procedure TForm1.CheckBoxQueryInfoHintClick(Sender: TObject);
Begin
  SetVETShellOption(toShellHints, CheckBoxQueryInfoHint.Checked);
End;

Procedure TForm1.CheckBoxRestrictDragClick(Sender: TObject);
Begin
  SetHeaderOption(hoRestrictDrag, CheckBoxRestrictDrag.Checked);
End;

Procedure TForm1.CheckBoxShellHeaderMenuClick(Sender: TObject);
Begin
  SetVETShellOption(toShellColumnMenu, CheckBoxShellHeaderMenu.Checked)
End;

Procedure TForm1.CheckBoxSyncroCollapseFirstClick(Sender: TObject);
Begin
  SetSyncroOption(toCollapseTargetFirst, CheckBoxSyncroCollapseFirst.Checked);
End;

Procedure TForm1.CheckBoxSyncroExpandTargetClick(Sender: TObject);
Begin
  SetSyncroOption(toExpandTarget, CheckBoxSyncroExpandTarget.Checked);
End;

Procedure TForm1.CheckBoxSyncroSelectTargetClick(Sender: TObject);
Begin
  SetSyncroOption(toSelectTarget, CheckBoxSyncroSelectTarget.Checked);
End;

Procedure TForm1.CheckBoxVisualBkGndClick(Sender: TObject);
Begin
  SetPaintOption(toShowBackground, CheckBoxVisualBkGnd.Checked);
  EditVisualBkGnd.Enabled := CheckBoxVisualBkGnd.Checked;
  ButtonVisualBkGnd.Enabled := CheckBoxVisualBkGnd.Checked;
End;

Procedure TForm1.ComboBoxHintAnimationChange(Sender: TObject);
Begin
//  VET1.HintAnimation := THintAnimationType(ComboBoxHintAnimation.ItemIndex);
End;

Procedure TForm1.ComboBoxRootFolderChange(Sender: TObject);
Begin
  VET1.RootFolder := TRootFolder(ComboBoxRootFolder.ItemIndex)
End;

Procedure TForm1.EditComboBoxDropCountKeyPress(Sender: TObject; Var Key: Char);
Begin
  If ((Key < '0') Or (Key > '9')) And Not (Key = #8) {Backspace} Then Key := #0
  Else If Key = #13 Then Begin
    //ExplorerComboBox1.DropDownCount := StrToInt(EditComboBoxDropCount.Text)
  End;
End;

Procedure TForm1.EditComboBoxRollDownSpeedKeyPress(Sender: TObject; Var Key: Char);
Begin
  If ((Key < '0') Or (Key > '9')) And Not (Key = #8) {Backspace} Then Key := #0
  Else If Key = #13 Then Begin
    //ExplorerComboBox1.RollDownSpeed := StrToInt(EditComboBoxRollDownSpeed.Text)
  End;
End;

Procedure TForm1.EditCustomRootFolderPathChange(Sender: TObject);
Begin
  FEditCustomRootFolderPathDirty := True;
End;

Procedure TForm1.EditCustomRootFolderPathExit(Sender: TObject);
Begin
  SetCustomRootPath
End;

Procedure TForm1.EditCustomRootFolderPathKeyDown(Sender: TObject;
  Var Key: Word; Shift: TShiftState);
Begin
  If (Key = Word(#13)) And FEditCustomRootFolderPathDirty Then
    SetCustomRootPath
End;

Procedure TForm1.EditFilterChange(Sender: TObject);
Begin
  FEditFilterDirty := True;
End;

Procedure TForm1.EditFilterExit(Sender: TObject);
Begin
  SetFilterString
End;

Procedure TForm1.EditFilterKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = Word(#13) Then
    SetFilterString
End;

Procedure TForm1.ExplorerComboBox1DropDown(Sender: TCustomVirtualExplorerCombobox; Var Allow: Boolean);
Begin
  //ExplorerComboBox1.DropDownCount := StrToInt(EditComboBoxDropCount.Text);
  //ExplorerComboBox1.RollDownSpeed := StrToInt(EditComboBoxRollDownSpeed.Text);
End;

Procedure TForm1.FormCreate(Sender: TObject);
Begin
  Application.HintHidePause := 5000;
  With ComboBoxRootFolder.Items Do Begin
    Add('Adminstrative Tools');
    Add('Alternate Startup Folder');
    Add('Application Data');
    Add('BitBucket (RecycleBin)');
    Add('Common Adminstrative Tools (NT)');
    Add('Common Alternate Startup (NT)');
    Add('Common Application Data (NT)');
    Add('Common DesktopDirectory (NT)');
    Add('Common Documents (NT)');
    Add('Common Favorites (NT)');
    Add('Common Programs (NT)');
    Add('Common StartMenu (NT)');
    Add('Common Startup (NT)');
    Add('Common Templates (NT)');
    Add('Control Panel');
    Add('Cookies');
    Add('Desktop');
    Add('Desktop Directory');
    Add('Drives');
    Add('Favorites');
    Add('Fonts');
    Add('History');
    Add('Internet');
    Add('Internet Cache');
    Add('Local Application Data');
    Add('My Pictures');
    Add('Network Neighborhood');
    Add('Network');
    Add('Personal');
    Add('Printers');
    Add('Print Neighborhood');
    Add('Profile');
    Add('Program Files');
    Add('Common Program Files (NT)');
    Add('Programs');
    Add('Recent');
    Add('SendTo');
    Add('Start Menu');
    Add('Start Up');
    Add('System');
    Add('Template');
    Add('Windows');
  End;
  ComboBoxRootFolder.ItemIndex := Ord(VET1.RootFolder);
  ComboBoxHintAnimation.ItemIndex := 0;
  LabelContextMenuHelpString.Caption := '';
  FCustomColumn := -1;
  ComboBoxECBStyle.ItemIndex := 0;
End;

Procedure TForm1.FormShow(Sender: TObject);
Begin
  PanelExplorer.Align := alClient;
  PanelVET.Align := alClient;
  PanelSyncro.Align := alClient;
  PanelVETChecks.Align := alClient;

  ExplorerTreeview1.Active := False;
  ExplorerListview1.Active := False;
  VETSyncro1.Active := False;
  VETSyncro2.Active := False;
  VETChecks.Active := False;
  VET1.Active := True;
  PanelVET.Show;
  PanelExplorer.Hide;
  PanelSyncro.Hide;
  PanelVETChecks.Hide;

  ExplorerTreeview1.Selected[ExplorerTreeview1.GetFirst] := True;
End;

Procedure TForm1.ListBoxViewsClick(Sender: TObject);
Begin
  VET1.ViewManager.ShowView(ListBoxViews.Items[ListBoxViews.ItemIndex], VET1)
End;

Procedure TForm1.RadioButtonComboBoxFullPathEditClick(Sender: TObject);
Begin
  RadioButtonComboBoxNameOnlyEdit.Checked := Not RadioButtonComboBoxFullPathEdit.Checked;
  ExplorerComboBox1.TextType := ecbtFullPath;
End;

Procedure TForm1.RadioButtonComboBoxNameOnlyEditClick(Sender: TObject);
Begin
  RadioButtonComboBoxFullPathEdit.Checked := Not RadioButtonComboBoxNameOnlyEdit.Checked;
  ExplorerComboBox1.TextType := ecbtNameOnly;
End;

Procedure TForm1.RadioGroupColumnTypeClick(Sender: TObject);
Begin
  VET1.ColumnDetails := TColumnDetailType(RadioGroupColumnType.ItemIndex);

  { Only available in Columns visible }
  RadioGroupFileSizeFormat.Enabled := Not (VET1.ColumnDetails <> cdVETColumns);
  CheckBoxShellHeaderMenu.Enabled := VET1.ColumnDetails <> cdUser;
  CheckBoxCustomColumn.Enabled := VET1.ColumnDetails <> cdUser;
  RadioGroupHeaderStyle.Enabled := VET1.ColumnDetails <> cdUser;
  CheckBoxAutoResize.Enabled := VET1.ColumnDetails <> cdUser;
  CheckBoxColumnResizable.Enabled := VET1.ColumnDetails <> cdUser;
  CheckBoxColumnClkResizeable.Enabled := VET1.ColumnDetails <> cdUser;
  CheckBoxColumnDrag.Enabled := VET1.ColumnDetails <> cdUser;
  CheckBoxHotTrackHeader.Enabled := VET1.ColumnDetails <> cdUser;
  LabelColumn1Color.Enabled := VET1.ColumnDetails <> cdUser;
  LabelColumn2Color.Enabled := VET1.ColumnDetails <> cdUser;
  LabelColumn3Color.Enabled := VET1.ColumnDetails <> cdUser;
  LabelColumn4Color.Enabled := VET1.ColumnDetails <> cdUser;
  LabelColumn5Color.Enabled := VET1.ColumnDetails <> cdUser;
  LabelColumn6Color.Enabled := VET1.ColumnDetails <> cdUser;
  LabelColumn7Color.Enabled := VET1.ColumnDetails <> cdUser;
  LabelColumn8Color.Enabled := VET1.ColumnDetails <> cdUser;
  ButtonColumn1Color.Enabled := VET1.ColumnDetails <> cdUser;
  ButtonColumn2Color.Enabled := VET1.ColumnDetails <> cdUser;
  ButtonColumn3Color.Enabled := VET1.ColumnDetails <> cdUser;
  ButtonColumn4Color.Enabled := VET1.ColumnDetails <> cdUser;
  ButtonColumn5Color.Enabled := VET1.ColumnDetails <> cdUser;
  ButtonColumn6Color.Enabled := VET1.ColumnDetails <> cdUser;
  ButtonColumn7Color.Enabled := VET1.ColumnDetails <> cdUser;
  ButtonColumn8Color.Enabled := VET1.ColumnDetails <> cdUser;
  { Only available in Columns visible }
End;

Procedure TForm1.RadioGroupExpandButtonFillClick(Sender: TObject);
Begin
  VET1.ButtonFillMode := TVTButtonFillMode(RadioGroupExpandButtonFill.ItemIndex)
End;

Procedure TForm1.RadioGroupExpandButtonStyleClick(Sender: TObject);
Begin
  VET1.ButtonStyle := TVTButtonStyle(RadioGroupExpandButtonStyle.ItemIndex)
End;

Procedure TForm1.RadioGroupFileSizeFormatClick(Sender: TObject);
Begin
  VET1.FileSizeFormat := TFileSizeFormat(RadioGroupFileSizeFormat.ItemIndex);
End;

Procedure TForm1.RadioGroupHeaderStyleClick(Sender: TObject);
Begin
  VET1.Header.Style := TVTHeaderStyle(RadioGroupHeaderStyle.ItemIndex)
End;

Procedure TForm1.RefreshTree;
Begin
  VET1.BeginUpdate;
  Try
    { Store the state of the tree to try to restore it later }
    VET1.ViewManager.Snapshot('X', VET1);
    VET1.RebuildTree;
    VET1.ViewManager.ShowView('X', VET1);
    VET1.ViewManager.DeleteView('X');
  Finally
    VET1.EndUpdate
  End
End;

Procedure TForm1.SetAnimateOption(Option: TVTAnimationOption;
  SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.AnimationOptions := VET1.TreeOptions.AnimationOptions + [Option]
  Else
    VET1.TreeOptions.AnimationOptions := VET1.TreeOptions.AnimationOptions - [Option]
End;

Procedure TForm1.SetAutoOption(Option: TVTAutoOption; SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.AutoOptions := VET1.TreeOptions.AutoOptions + [Option]
  Else
    VET1.TreeOptions.AutoOptions := VET1.TreeOptions.AutoOptions - [Option]
End;

Procedure TForm1.SetColors(ColorType: TDemoColor; ColorText: TLabel);
Begin
  ColorDialog1.Color := ColorText.Font.Color;
  If ColorDialog1.Execute Then Begin
    Case ColorType Of
      dcDropTargetBorder: VET1.Colors.DropTargetBorderColor := ColorDialog1.Color;
      dcDropTargetFill: VET1.Colors.DropTargetColor := ColorDialog1.Color;
      dcHilightBorder: VET1.Colors.FocusedSelectionBorderColor := ColorDialog1.Color;
      dcHilightFill: VET1.Colors.FocusedSelectionColor := ColorDialog1.Color;
      dcGridLine: VET1.Colors.GridLineColor := ColorDialog1.Color;
      dcHotTrack: VET1.Colors.HotColor := ColorDialog1.Color;
      dcSelectFill: VET1.Colors.SelectionRectangleBlendColor := ColorDialog1.Color;
      dcSelectBorder: VET1.Colors.SelectionRectangleBorderColor := ColorDialog1.Color;
      dcTreeLine: VET1.Colors.TreeLineColor := ColorDialog1.Color;
    End;
    ColorText.Font.Color := ColorDialog1.Color;
  End
End;

Procedure TForm1.SetColumnColor(ColumnNumber: Integer; ColorText: TLabel);
Begin
  If ColumnNumber < VET1.Header.Columns.Count Then Begin
    ColorDialog1.Color := ColorText.Font.Color;
    If ColorDialog1.Execute Then Begin
      VET1.Header.Columns[ColumnNumber].Color := ColorDialog1.Color;
      ColorText.Font.Color := ColorDialog1.Color;
    End;
  End
End;

Procedure TForm1.SetCustomRootPath;
Begin
  If SysUtils.DirectoryExists(EditCustomRootFolderPath.Text) And FEditCustomRootFolderPathDirty Then Begin
    VET1.RootFolderCustomPath := EditCustomRootFolderPath.Text;
    FEditCustomRootFolderPathDirty := False
  End
End;

Procedure TForm1.SetFilterString;
Begin
  If FEditFilterDirty Then Begin
    RefreshTree;
    FEditFilterDirty := False;
  End
End;

Procedure TForm1.SetHeaderOption(Option: TVTHeaderOption; SetOption: Boolean);
Begin
  If SetOption Then
    VET1.Header.Options := VET1.Header.Options + [Option]
  Else
    VET1.Header.Options := VET1.Header.Options - [Option]
End;

Procedure TForm1.SetMiscOption(Option: TVTMiscOption; SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.MiscOptions := VET1.TreeOptions.MiscOptions + [Option]
  Else
    VET1.TreeOptions.MiscOptions := VET1.TreeOptions.MiscOptions - [Option]
End;

Procedure TForm1.SetPaintOption(Option: TVTPaintOption;
  SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.PaintOptions := VET1.TreeOptions.PaintOptions + [Option]
  Else
    VET1.TreeOptions.PaintOptions := VET1.TreeOptions.PaintOptions - [Option]
End;

Procedure TForm1.SetSelectionOption(Option: TVTSelectionOption;
  SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.SelectionOptions := VET1.TreeOptions.SelectionOptions + [Option]
  Else
    VET1.TreeOptions.SelectionOptions := VET1.TreeOptions.SelectionOptions - [Option]
End;

Procedure TForm1.SetSyncroOption(Option: TVETSyncOption; SetOption: Boolean);
Begin
  If SetOption Then
    VETSyncro2.TreeOptions.VETSyncOptions := VETSyncro2.TreeOptions.VETSyncOptions + [Option]
  Else
    VETSyncro2.TreeOptions.VETSyncOptions := VETSyncro2.TreeOptions.VETSyncOptions - [Option]
End;

Procedure TForm1.SetTextColor(TextType: TTextType; ColorText: TLabel);
Begin
  ColorDialog1.Color := ColorText.Font.Color;
  If ColorDialog1.Execute Then Begin
    Case TextType Of
      ttGlobal: VET1.Font.Color := ColorDialog1.Color;
      ttFolders: VET1.VETColors.FolderTextColor := ColorDialog1.Color;
      ttNonFolders: VET1.VETColors.FileTextColor := ColorDialog1.Color;
      ttCompressed: VET1.VETColors.CompressedTextColor := ColorDialog1.Color;
    End;
    ColorText.Font.Color := ColorDialog1.Color;
  End
End;

Procedure TForm1.SetVETFolderOption(Option: TVETFolderOption;
  SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.VETFolderOptions := VET1.TreeOptions.VETFolderOptions + [Option]
  Else
    VET1.TreeOptions.VETFolderOptions := VET1.TreeOptions.VETFolderOptions - [Option]
End;

Procedure TForm1.SetVETImageOption(Option: TVETImageOption;
  SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.VETImageOptions := VET1.TreeOptions.VETImageOptions + [Option]
  Else
    VET1.TreeOptions.VETImageOptions := VET1.TreeOptions.VETImageOptions - [Option]
End;

Procedure TForm1.SetVETMiscOption(Option: TVETMiscOption; SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.VETMiscOptions := VET1.TreeOptions.VETMiscOptions + [Option]
  Else
    VET1.TreeOptions.VETMiscOptions := VET1.TreeOptions.VETMiscOptions - [Option]
End;

Procedure TForm1.SetVETShellOption(Option: TVETShellOption;
  SetOption: Boolean);
Begin
  If SetOption Then
    VET1.TreeOptions.VETShellOptions := VET1.TreeOptions.VETShellOptions + [Option]
  Else
    VET1.TreeOptions.VETShellOptions := VET1.TreeOptions.VETShellOptions - [Option]
End;

Procedure TForm1.SpeedButtonColumn1ColorClick(Sender: TObject);
Begin
  ;
  ;
End;

Procedure TForm1.TabSheetCheckboxesShowShow(Sender: TObject);
Begin
  PanelSyncro.Hide;
  PanelVET.Hide;
  PanelExplorer.Hide;
  VETChecks.Active := True;
  ExplorerTreeview1.Active := False;
  ExplorerListview1.Active := False;
  VETSyncro1.Active := False;
  VETSyncro2.Active := False;
  VET1.Active := False;
  PanelVETChecks.Show;
  PanelVETChecks.SetFocus;
End;

Procedure TForm1.TabSheetExplorerShow(Sender: TObject);
Begin
  PanelVETChecks.Hide;
  PanelSyncro.Hide;
  PanelVET.Hide;
  ExplorerTreeview1.Active := True;
  ExplorerListview1.Active := True;
  VETSyncro1.Active := False;
  VETSyncro2.Active := False;
  VET1.Active := False;
  VETChecks.Active := False;
  PanelExplorer.Show;
  ExplorerTreeview1.SetFocus;
  ExplorerTreeview1.Selected[ExplorerTreeview1.GetFirst] := True
End;

Procedure TForm1.TabSheetNormalShow(Sender: TObject);
Begin
  PanelVETChecks.Hide;
  PanelExplorer.Hide;
  PanelSyncro.Hide;
  ExplorerTreeview1.Active := False;
  ExplorerListview1.Active := False;
  VETSyncro1.Active := False;
  VETSyncro2.Active := False;
  VETChecks.Active := False;
  VET1.Active := True;
  PanelVET.Show;
  VET1.TreeOptions.VETShellOptions := VET1.TreeOptions.VETShellOptions + [toContextMenus]
End;

Procedure TForm1.TabSheetSyncronizationShow(Sender: TObject);
Begin
  PanelVETChecks.Hide;
  PanelExplorer.Hide;
  PanelVET.Hide;
  ExplorerTreeview1.Active := False;
  ExplorerListview1.Active := False;
  VETSyncro1.Active := True;
  VETSyncro2.Active := True;
  VET1.Active := False;
  PanelSyncro.Show;
  { Must do after show to get latest value }
  VETSyncro1.Width := PanelSyncro.Width Div 2;
End;

Procedure TForm1.TabSheetTNamespaceShow(Sender: TObject);
Begin
  PanelVETChecks.Hide;
  PanelExplorer.Hide;
  PanelSyncro.Hide;
  ExplorerTreeview1.Active := False;
  ExplorerListview1.Active := False;
  VETSyncro1.Active := False;
  VETSyncro2.Active := False;
  VETChecks.Active := False;
  VET1.Active := True;
  PanelVET.Show;
End;

Procedure TForm1.VET1HeaderRebuild(
  Sender: TCustomVirtualExplorerTree; Header: TVTHeader);
Var
  CustomColumn: TVETColumn;
Begin
  If CheckBoxCustomColumn.Checked Then Begin
    { Added a user defined custom column when ColumnDetails is in the             }
    { cdShellColumn mode.                                                         }
    CustomColumn := TVETColumn(Header.Columns.Add);
    CustomColumn.ColumnDetails := cdCustom;
    CustomColumn.Width := 110;
    CustomColumn.Text := 'Custom Extensions';
    { The text for each node is retrieved in the OnGetVETText event               }
    { Need to rememeber what the index was to where when to fill in the text      }
    FCustomColumn := Header.Columns.Count - 1;
  End
End;

Procedure TForm1.VET1Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
Var
  NS: TNamespace;
Begin
  If CheckBoxTNamespace.Checked And VET1.ValidateNamespace(VET1.GetFirstSelected, NS) Then
    FormInfo.UpdateInfo(NS);
End;

Procedure TForm1.VET1ContextMenuCmd(Sender: TCustomVirtualExplorerTree;
  Namespace: TNamespace; Verb: string; MenuItemID: Integer;
  Var Handled: Boolean);
Begin
  If MenuItemID = FCustomMenuItemID Then Begin
    Handled := True;
    ShowMessage('Thanks for selecting:  ' + '"' + EditCustomMenuItem.Text + '"');
  End;
End;

Procedure TForm1.VET1ContextMenuItemChange(
  Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
  MenuItemID: Integer; SubMenuID: HMENU; MouseSelect: Boolean);
Begin
  LabelContextMenuHelpString.Caption := Namespace.ContextMenuItemHelp(MenuItemID)
End;

Procedure TForm1.VET1ContextMenuShow(Sender: TCustomVirtualExplorerTree;
  Namespace: TNamespace; Menu: HMENU; Var Allow: Boolean);

{ Searchs through the passed menu looking for an item identifer that is not   }
{ currently being used.                                                       }

  Function FindUniqueMenuID(AMenu: HMenu): cardinal;
  Var
    ItemCount, i: integer;
    Duplicate, Done: Boolean;
  Begin
    ItemCount := GetMenuItemCount(Menu);
    Duplicate := True;
    Done := False;
    // Bit of a guess here.  If you use the popup menu in the Context menu then
    // Delphi will generate "unique IDs (as far as Delphi is concerned) which
    // may be the same as the one we generate.  By starting at 1000 we likely won't
    // have a problem.
    Result := 1000;
    While Duplicate Do Begin
      i := 0;
      While (i < ItemCount) And Not Done Do Begin
        Done := GetMenuItemID(Menu, i) = Result;
        Inc(i);
      End;
      Duplicate := not Done;
      If Duplicate Then
        Inc(Result)
    End;
  End;

Var
  i, Items: Integer;
  Info: TMenuItemInfo;
  Buffer: Array[0..128] Of char;
  S: String;
Begin
  { In order to disable some context menu items we need to work with the menu  }
  { directly.  First get the count then look for a match of any item we want   }
  { disabled.  For the example it is easy since the built in items use         }
  { language independant cononical verbs.  If it is a custom context menu      }
  { handler it become less clear how to make sure it works in any language.    }
  Items := GetMenuItemCount(Menu);
  For i := 0 To Items - 1 Do Begin
    FillChar(Info, SizeOf(Info), #0);
    Info.cbSize := SizeOf(Info);
    Info.fMask := MIIM_TYPE Or MIIM_ID;
    Info.fType := MFT_STRING;
    Info.dwTypeData := @Buffer;
    Info.cch := SizeOf(Buffer) - 1;
    GetMenuItemInfo(Menu, i, True, Info);
    S := Namespace.ContextMenuVerb(GetMenuItemID(Menu, i));
    { This are all language independant using the verb }
    If ((StrComp(PChar(S), 'copy') = 0) And CheckBoxDisableCopy.Checked) Or
      ((StrComp(PChar(S), 'cut') = 0) And CheckBoxDisableCut.Checked) Or
      ((StrComp(PChar(S), 'delete') = 0) And CheckBoxDisableDelete.Checked) Or
      ((StrComp(PChar(S), 'properties') = 0) And CheckBoxDisableProperties.Checked) Or
      ((StrComp(PChar(S), 'rename') = 0) And CheckBoxDisableRename.Checked) Or
      ((StrComp(PChar(S), 'link') = 0) And CheckBoxDisableLink.Checked) Then Begin
      Info.fMask := MIIM_STATE;
      Info.fState := MFS_DISABLED;
      SetMenuItemInfo(Menu, i, True, Info);
    End;
  End;

  { If demo wants to add in a custom menu item without writing a ContextMenu    }
  { Extension (and who wouldn't) find an available identifer and add the item.  }
  If CheckBoxCustomMenuItem.Checked Then Begin
    Info.cbSize := SizeOf(Info);
    Info.fMask := MIIM_TYPE Or MIIM_ID;
    Info.fType := MFT_STRING;
    Info.dwTypeData := PChar(EditCustomMenuItem.Text);
    Info.cch := Length(EditCustomMenuItem.Text);
    Info.wID := FindUniqueMenuID(Menu);
    FCustomMenuItemID := Info.wID;
    InsertMenuItem(Menu, 0, True, Info);
  End;
End;

Procedure TForm1.VET1CustomColumnCompare(
  Sender: TCustomVirtualExplorerTree; Column: TColumnIndex; Node1,
  Node2: PVirtualNode; Var Result: Integer);
Var
  NS1, NS2: TNamespace;
Begin
  Result := 0; // Equal by default
  { Sorts a custom Column }
  If Column = FCustomColumn Then Begin
    If Sender.ValidateNamespace(Node1, NS1) And Sender.ValidateNamespace(Node2, NS2) Then
      Result := lstrcmp(PChar(ExtractFileExt(NS1.NameNormal)), PChar(ExtractFileExt(NS2.NameNormal)))
  End
End;

Procedure TForm1.VET1EnumFolder(Sender: TCustomVirtualExplorerTree;
  Namespace: TNamespace; Var AllowAsChild: Boolean);
Var
  FileExt: string;
Begin
  FileExt := SysUtils.AnsiUpperCase(ExtractFileExt(Namespace.NameParseAddress));
  If Not Namespace.Folder Then { Don't filter folders }
    If Not Namespace.Folder And (Pos(FileExt, SysUtils.AnsiUpperCase(EditFilter.Text)) = 0) Then
      AllowAsChild := False;
End;

procedure TForm1.VET1GetVETText(Sender: TCustomVirtualExplorerTree;
  Column: TColumnIndex; Node: PVirtualNode; Namespace: TNamespace;
  var Text: string);
begin
  If CheckBoxCustomColumn.Checked Then Begin
    { Show the file extensions in the custom column }
    If FCustomColumn = Column Then
      Text := ExtractFileExt(Namespace.NameNormal);
  End
end;

Procedure TForm1.VETChecksInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; Var InitialStates: TVirtualNodeInitStates);
Begin
  Sender.CheckType[Node] := ctTriStateCheckBox;
End;

Procedure TForm1.ComboBoxECBStyleChange(Sender: TObject);
Begin
  Case ComboBoxECBStyle.ItemIndex Of
    0: ExplorerComboBox1.Style := scsDropDownList;
    1: ExplorerComboBox1.Style := scsDropDown;
  End;
End;

procedure TForm1.Item1Click(Sender: TObject);
begin
  ShowMessage('You clicked Item 1');
end;

procedure TForm1.Item4Click(Sender: TObject);
begin
  ShowMessage('You clicked Item 4');
end;

procedure TForm1.Item2Click(Sender: TObject);
begin
  ShowMessage('You clicked Item 2');
end;

procedure TForm1.Item3Click(Sender: TObject);
begin
  ShowMessage('You clicked Item 3');
end;

End.


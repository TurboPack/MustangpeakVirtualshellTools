
// The packages must be rebuilt to make the changes in this file active



// -----------------------------------------------------------------------------
// TOOLBAR 2000 and TBX SUPPORT FOR VIRTUALSHELLHISTORY MENU
// -----------------------------------------------------------------------------
//
// Uncomment out the conditional define for Toolbar 2000 and TBX Toolbar support
//
// WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING:
//
// You must either add the Tooolbar 2000 and/or the TBX packages to the
// VirtualShellToolsDx.dpk "Requires" section. Usually tbx_d5.dcp and tb2k_d5.dcp and
// TBXSwitcherItem_d5 if using the TBX addon theme switch for D5
// This is easier if you open the VirtualShellToolsDx.dpk with a text editor and add this:
//
// requires
//   vcl50,
//   VirtualTreesD5,
//   VirtualToolsCommonD5,
//   ThemeManager5,
//   tb2k_d5,
//   tbx_d5;
//
// For D6 replace with:
//
//  requires
//    VirtualTreesD6,
//    VirtualToolsCommonD6,
//    ThemeManager6
//    tb2k_d6,
//    tbx_d6;
//
// Then recompile VSTools
//
// DO NOT allow Delphi to add the units to the "Contains" section automaticlly
// if you forget to add the packages to the "Requires"
// section.

// Define USE_TOOLBAR_TB2K if you use Toolbar 2000, TBX or SpTBXLib
//
{.$DEFINE USE_TOOLBAR_TB2K}
{.$DEFINE SpTBX}

// -----------------------------------------------------------------------------
//

// Strips particular component from the package to reduce EXE size in final application
//
//

{$DEFINE EXPLORERCOMBOBOX_L}
{$DEFINE EXPLORERLISTVIEW_L}
{$DEFINE EXPLORERTREE_L}
{$DEFINE EXPLORERTREEVIEW_L}
{$DEFINE EASYLISTVIEW_L}

// -----------------------------------------------------------------------------


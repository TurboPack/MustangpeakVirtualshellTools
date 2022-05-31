// The packages must be rebuilt to make the changes in this file active

// -----------------------------------------------------------------------------
// TOOLBAR 2000 and TBX SUPPORT FOR VIRTUALSHELLHISTORY MENU
// -----------------------------------------------------------------------------
//
// Uncomment out the conditional define for Toolbar 2000 and TBX Toolbar support
//
// WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING: WARNING:
//
// You must either add the Tooolbar 2000 and/or the SpTBXLib packages to the
// VirtualShellToolsDx.dpk "Requires" section.
// This is easier if you open the VirtualShellToolsDx.dpk with a text editor and add this:
//
// E,g, For D6:
//
//  requires
//    VirtualTreesD6,
//    VirtualToolsCommonD6,
//    ThemeManager6
//    tb2k_d6,
//    SpTbxLib_d6;
//
// Then recompile VSTools
//
// DO NOT allow Delphi to add the units to the "Contains" section automaticlly
// if you forget to add the packages to the "Requires" section.

// Define USE_TOOLBAR_TB2K if you use Toolbar 2000, SpTBXLib
{.$DEFINE USE_TOOLBAR_TB2K}
// Define SpTBX if you use SpTBXLib
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
// -----------------------------------------------------------------------------

// ImageEn SUPPORT
// You must add the ImageEn package to the VirtualShellToolsD.dpk "Requires" section PKIECtrl28
// You may need to add Path to ImageEn: Delphi Compiler, Windows 64bit, Search path \ImageEn\Source\Delphi11Alexandria_64

// {$DEFINE USEIMAGEEN}

unit VirtualExplorerListviewExReg;

// *****************************************************************************
// *****************************************************************************
// IMPORTANT PLEASE READ THIS NOTICE....
///
//  VLVEx is no longer being developed.  It is included in VSTools 2.0 to
// support legacy application.  Please use the VirtualExplorerEasyListview for
// new projects.....
// *****************************************************************************
// *****************************************************************************
//
// Version 1.7.0
//
//   The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except
// in compliance with the License. You may obtain a copy of the
// License at
//
// http://www.mozilla.org/MPL/
//
//   Software distributed under the License is distributed on an
// " AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either expressed or
// implied. See the License for the specific language governing rights
// and limitations under the License.
//
//
//   Alternatively, the contents of this file may be used under
// the terms of the GNU General Public License Version 2 or later
// (the "GPL"), in which case the provisions of the GPL are applicable
// instead of those above. If you wish to allow use of your version of
// this file only under the terms of the GPL and not to allow others to
// use your version of this file under the MPL, indicate your decision
// by deleting the provisions above and replace them with the notice and
// other provisions required by the GPL. If you do not delete the provisions
// above, a recipient may use your version of this file under either the
// MPL or the GPL.
//
// The initial developer of this code is Robert Lee

interface

uses
  Windows, Classes, VirtualExplorerListviewEx;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('VirtualShellTools', [TVirtualExplorerListviewEx]);
end;

end.



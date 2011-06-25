In BCB you will need to add NO_WIN32_LEAN_AND_MEAN to your project's conditional defines
(Project Options | Directories/Conditionals) - this solves the
Undefined symbol 'IQueryInfo' error in VirtualShellTypes.hpp.

In BCB6, you'll have to replace wrong files in $(BCB)\Include with
  corresponding files in CBuilder\C6\Include. Strange, I know.
  Make backup copies...

-------- How to build Demos in BCB5 --------

1. Run C++ Builder, menu File/New Application              |
2. Open Project Manager, delete Unit1 from project
3. Decide which demo you want to compile and save project
     to the corresponding folder with some reasonable name,
     e.g. the original one (filename.dpr) with C5 appended.
4. Open Delphi project in a viewer (Notepad), and look
     for the "uses" keyword. After this, there is something
     like

  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  InfoForm in 'InfoForm.pas' {Form2};

  So, you'll have to add Unit1.pas and InfoForm.pas to the
  project. First, look below line

    Application.Initialize;

  there is this or something similar:

    Application.CreateForm(TForm1, Form1);
    Application.CreateForm(TFormInfo, FormInfo);

  You have to add the files in this order. It will be
  probably the same as in the "uses" clause.
  Use Project Manager right-click on ...C5.exe to add files.
5. I recommend opening Project/Project Source and deleting
  the paths, and manually save the file.
  In BCB6, the paths are stored in .bpr file.
6. In Project Options/Directories and Conditionals, in both
  "Include Files" and "Library Files" delete the path to your
  files, since "." is always used. Add
  $(BCB)\Projects\Intermed to "Library Files".
7. Build the project and add the paths to any missing files
  to "Library Files" (.obj and .res), or
  "Include Paths" (.hpp). E.g., I have to add paths
  ..\..\VirtualTreeView and
  ..\Source\VirtualExplorerTree to Library paths.
8. On the second try, it should run.


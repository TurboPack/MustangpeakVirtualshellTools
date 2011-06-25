setlocal

PATH=C:\Program Files\BitZipper;C:\Program Files\ISTool 4;C:\Program Files\Inno Setup 5;C:\Program Files\MVAPPS\WEBEX

del "D:\Program Data\Delphi Projects\3rd Party Components\VirtualShellTools2.0\Setup\VirtualShellToolsSetup2.0.exe"
del "D:\Program Data\Delphi Projects\3rd Party Components\VirtualShellTools2.0\Setup\VirtualShellToolsSetup2.0.zip"

call compil32.exe /cc "VirtualShellTools2.0.iss" 

call Bitzipper.exe -add "D:\Program Data\Delphi Projects\3rd Party Components\VirtualShellTools2.0\Setup\VirtualShellToolsSetup2.0.zip" "VirtualShellToolsSetup2.0.exe"

copy VirtualShellToolsSetup2.0.exe "D:\Program Data\MVApps\Websites\MustangPeak\download\components"
copy VirtualShellToolsSetup2.0.zip "D:\Program Data\MVApps\Websites\MustangPeak\download\components"

call "C:\Program Files\WPK\WEBEX\webex.exe" "D:\Program Data\MVApps\Websites\MustangPeak\mustangpeak.wbs"

endlocal
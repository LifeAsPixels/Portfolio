@ECHO OFF
SET PSC0=Powershell.exe -Command "Set-ExecutionPolicy -Scope CurrentUser RemoteSigned"

CALL ExecutionPolicy-Get.bat

%PSC0% > PSC0
SET /P PSC0re=< PSC0
ECHO You can now run PowerShell scripts on %username%'s account

CALL ExecutionPolicy-Get.bat

del PSC0

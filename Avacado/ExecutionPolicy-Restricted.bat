@ECHO OFF
SET PSC=powershell.exe -Command "Set-ExecutionPolicy -Scope CurrentUser Restricted"
%PSC%
CALL Get-ExecutionPolicy.bat

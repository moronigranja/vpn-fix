@echo off
:aplicar
echo Ao pressionar qualquer tecla, o script será aplicado (Ctrl + C para cancelar)
pause
powershell -noprofile -executionpolicy bypass -file .\vpn_fix_admin.ps1
goto aplicar
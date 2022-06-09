powershell -noexit -noprofile -command "&{ start-process powershell -ArgumentList '-NoExit -noprofile -file registrar-tarefa.ps1' -verb RunAs}"
REM powershell.exe -noprofile -executionpolicy bypass -file .\script.ps1
pause
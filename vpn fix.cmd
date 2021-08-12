@echo off

echo "default route before fix" > vpn_fix.log
route print >> vpn_fix.log
echo "endereço ip ao conectar com tfs.amil.com.br" >> vpn_fix.log
pathping tfs.amil.com.br -n -w 1 -h 1 -q 1 >> vpn_fix.log

FOR /F "tokens=1 delims=." %%a in ('route print ^| findstr /r /c:"PANGP"') DO (
set /a indexInterfaceRedeVPN=%%a
)
FOR /F "skip=3 tokens=2 delims= " %%a in ('pathping tfs.amil.com.br -n -w 1 -h 1 -q 1') DO (
set VPNLocalIpAddress=%%a & goto fixRoutes
)

:ErroNaoConectado
echo "ErroNaoConectado" >> vpn_fix.log
echo Erro, Nao conectado a VPN UHG
goto end

:fixRoutes

if %VPNLocalIpAddress% == "" goto ErroNaoConectado

route change 0.0.0.0 mask 0.0.0.0 %VPNLocalIpAddress% metric 100 IF %indexInterfaceRedeVPN%
route add 10.25.0.0 mask 255.255.0.0 %VPNLocalIpAddress% metric 4 IF %indexInterfaceRedeVPN%
route add 10.104.0.0 mask 255.255.0.0 %VPNLocalIpAddress% metric 4 IF %indexInterfaceRedeVPN%
route add 10.105.0.0 mask 255.255.0.0 %VPNLocalIpAddress% metric 4 IF %indexInterfaceRedeVPN%
route add 10.106.0.0 mask 255.255.0.0 %VPNLocalIpAddress% metric 4 IF %indexInterfaceRedeVPN%

if ERRORLEVEL 1 goto ErroAlterarRota
echo "Sucesso" >> vpn_fix.log
echo Adicionado com sucesso!
goto end

:ErroAlterarRota
echo "ErroAlterarRota" >> vpn_fix.log
echo Erro ao alterar rota!
goto end

:end
echo "default route after fix" >> vpn_fix.log
route print >> vpn_fix.log
pause

@echo off

REM V1.3 mgranja
REM changelog
REM v 1.0 -> Criado script que utiliza ip e indice de rede automaticos
REM v 1.1 -> adicionada subrede 10.106.X.X para algumas urls novas
REM v 1.2 -> subrede mudada para generica 10.96.0.0/255.240.0.0, que deve servir de 10.96.0.0 até 10.111.0.0
REM v 1.3 -> Aumentada metrica da subrede 10.0.0.0 da vpn, pois pode ser o subnet local

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

:bypass
set VPNLocalIpAddress=10.0.0.140
goto fixRoutes

:fixRoutes

if %VPNLocalIpAddress% == "" goto ErroNaoConectado

route change 0.0.0.0 mask 0.0.0.0 %VPNLocalIpAddress% metric 100 IF %indexInterfaceRedeVPN%
REM tornar essas 3 proximas linhas automaticas
route change 192.168.1.0 mask 255.255.255.0 %VPNLocalIpAddress% metric 300 IF %indexInterfaceRedeVPN%
route change 192.168.18.0 mask 255.255.255.0 %VPNLocalIpAddress% metric 150 IF %indexInterfaceRedeVPN%
route change 10.0.0.0 mask 255.255.255.0 %VPNLocalIpAddress% metric 350 IF %indexInterfaceRedeVPN%
route add 10.25.0.0 mask 255.255.0.0 %VPNLocalIpAddress% metric 4 IF %indexInterfaceRedeVPN%
route add 10.96.0.0 mask 255.240.0.0 %VPNLocalIpAddress% metric 4 IF %indexInterfaceRedeVPN%

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

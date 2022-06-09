# VPN fix 1.4 by mgranja (https://github.com/moronigranja/vpn-fix)
# changelog
# v 1.0 -> Criado script que utiliza ip e indice de rede automaticos
# v 1.1 -> adicionada subrede 10.106.X.X para algumas urls novas
# v 1.2 -> subrede mudada para generica 10.96.0.0/255.240.0.0, que deve servir de 10.96.0.0 atÃ© 10.111.0.0
# v 1.3 -> Aumentada metrica da subrede 10.0.0.0 da vpn, pois pode ser o subnet local
# v 1.4 -> primeira versÃ£o em powershell, remove todas as rotas do vpn, e adiciona somente as necessarias

$adapter = Get-NetAdapter -InterfaceDescription "PANGP*"
if ($adapter.status -eq "Up") {
	Write-Output "Definindo novas rotas para VPN..."

	$adapter | Set-NetIPInterface -InterfaceMetric 150
	$adapter | Remove-NetRoute -Confirm:$False
	$adapter | New-NetRoute -DestinationPrefix 10.25.0.0/16
	$adapter | New-NetRoute -DestinationPrefix 10.96.0.0/12
	$adapter | New-NetRoute -DestinationPrefix 0.0.0.0/0
	
	#Write-Output "Redefinindo DNS da VPN"
	
	$adapter | Set-DnsClientServerAddress -ServerAddresses ("10.104.91.200","10.104.211.200")
}
else {
	Write-Output "Não conectado à  VPN UHG"
}
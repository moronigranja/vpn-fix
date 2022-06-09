# VPN fix 1.4 by mgranja (https://github.com/moronigranja/vpn-fix)
# changelog
# v 1.0 -> Criado script que utiliza ip e indice de rede automaticos
# v 1.1 -> adicionada subrede 10.106.X.X para algumas urls novas
# v 1.2 -> subrede mudada para generica 10.96.0.0/255.240.0.0, que deve servir de 10.96.0.0 até 10.111.0.0
# v 1.3 -> Aumentada metrica da subrede 10.0.0.0 da vpn, pois pode ser o subnet local
# v 1.4 -> primeira versão em powershell, remove todas as rotas do vpn, e adiciona somente as necessarias

#### START ELEVATE TO ADMIN #####
param(
    [Parameter(Mandatory=$false)]
    [switch]$shouldAssumeToBeElevated,

    [Parameter(Mandatory=$false)]
    [String]$workingDirOverride
)

# If parameter is not set, we are propably in non-admin execution. We set it to the current working directory so that
#  the working directory of the elevated execution of this script is the current working directory
if(-not($PSBoundParameters.ContainsKey('workingDirOverride')))
{
    $workingDirOverride = (Get-Location).Path
}

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# If we are in a non-admin execution. Execute this script as admin
if ((Test-Admin) -eq $false)  {
    if ($shouldAssumeToBeElevated) {
        Write-Output "Elevating did not work :("

    } else {
        #                                                         vvvvv add `-noexit` here for better debugging vvvvv 
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -shouldAssumeToBeElevated -workingDirOverride "{1}"' -f ($myinvocation.MyCommand.Definition, "$workingDirOverride"))
    }
    exit
}

Set-Location "$workingDirOverride"
##### END ELEVATE TO ADMIN #####

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
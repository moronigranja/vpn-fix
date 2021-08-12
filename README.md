# VPN Fix 
UM script para definir novas rotas de rede, com o proposito de utilizar os sites que precisam da vpn, e deixar acessiveis os outros da internet.

## Como utilizar este script

#### Baixar a ultima versão do arquivo "vpn fix.ps1". 
#### Enquanto conectado na VPN, clicar com o botão direito no arquivo, e selecionar a opção "Executar com Powershell"/"Run With Powershell".
#### Aceitar a permissão para executar como administrador, pois é necessária para mudar as configurções de rede do computador.

## Como desfazer as mudanças do script

#### As mudanças não são salvas permanentemente. Ao desconectar da VPN e conectar novamente, ou reiniciar o computador, as mudanças serão revertidas.


## Changelog
###### v 1.0 -> Criado script que utiliza ip e indice de rede automaticos
###### v 1.1 -> adicionada subrede 10.106.X.X para algumas urls novas
###### v 1.2 -> subrede mudada para generica 10.96.0.0/255.240.0.0, que deve servir de 10.96.0.0 até 10.111.0.0
###### v 1.3 -> Aumentada metrica da subrede 10.0.0.0 da vpn, pois pode ser o subnet local
###### v 1.4 -> primeira versão em powershell, remove todas as rotas do vpn, e adiciona somente as necessarias
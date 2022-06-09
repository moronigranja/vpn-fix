$taskname="Liberar Acesso VPN"
$description="Conserta as rotas do VPN para deixar a internet em geral acessivel, e também os sites especificos da VPN"
$location = Get-Location

# delete existing task if it exists
Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false
    

#$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {get-eventlog -logname Application -After ((get-date).AddDays(-1)) | Export-Csv -Path c:\fso\applog.csv -Force -NoTypeInformation}"'
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-NoProfile -executionpolicy bypass -WindowStyle Minimized -File $location\vpn_fix_admin.ps1"

#$trigger =  New-ScheduledTaskTrigger -AtLogOn
# create TaskEventTrigger, use your own value in Subscription
$CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger
$trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
$trigger.Subscription = 
@"
<QueryList><Query Id="0" Path="Microsoft-Windows-NetworkProfile/Operational"><Select Path="Microsoft-Windows-NetworkProfile/Operational">*[System[Provider[@Name='Microsoft-Windows-NetworkProfile'] and EventID=10000]]</Select></Query></QueryList>
"@
$trigger.Enabled = $True

Register-ScheduledTask -RunLevel Highest -Action $action -Trigger $trigger -TaskName $taskname -Description $description
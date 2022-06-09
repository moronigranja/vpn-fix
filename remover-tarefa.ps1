$taskname="Liberar Acesso VPN"

# delete existing task if it exists
Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false
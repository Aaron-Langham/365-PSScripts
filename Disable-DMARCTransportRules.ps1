$LogonEmail = Read-Host "Enter Logon Email"

Connect-ExchangeOnline -UserPrincipalName $LogonEmail

Disable-TransportRule -Identity "*DMARC*"

Get-TransportRule

Disconnect-ExchangeOnline -Confirm:$false

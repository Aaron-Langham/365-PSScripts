Connect-ExchangeOnline

$Mailboxes = Get-Mailbox

ForEach ($User in $Mailboxes){set-Mailbox $User.UserPrincipalName -RemoveDelayHoldApplied}
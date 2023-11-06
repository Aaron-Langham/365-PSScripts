$LogonEmail = Read-Host "Enter Logon Email"

Connect-ExchangeOnline -UserPrincipalName $LogonEmail

#Internal Transport rule
$InternalRule = @{
    Name = 'DMARC Reject - Internal'
    HeaderContainsMessageHeader = 'Authentication-Results'
    HeaderContainsWords = 'dmarc=fail action=oreject'
    RejectMessageReasonText = 'Unauthenticated email is not accepted due to the domain’’s DMARC policy'
    RejectMessageEnhancedStatusCode = '5.7.1'
}

New-TransportRule @InternalRule -Mode Enforce -FromScope InOrganization

#External
$ExternalRule = @{
    Name = 'DMARC SCL - External'
    HeaderContainsMessageHeader = 'Authentication-Results'
    HeaderContainsWords = 'dmarc=fail action=oreject'
    SetSCL = 5
}
New-TransportRule @ExternalRule -Mode Enforce -FromScope NotInOrganization

Get-TransportRule

Disconnect-ExchangeOnline -Confirm:$false

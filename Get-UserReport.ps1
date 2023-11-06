$LogonEmail = Read-Host "Enter Logon Email"
Connect-ExchangeOnline -UserPrincipalName $LogonEmail
Connect-MgGraph -Scopes "Directory.Read.All"

Class User {
    [string]$DisplayName
    [string]$UserPrincipalName
    [string]$Mail
    [string]$AccountId
    [string]$Id
    [string]$SkuId
    [string]$SkuPartNumber
    [string]$Aliases
}


$accounts = Get-mgUser | Select-Object DisplayName,UserPrincipalName,Mail,Id

$Users =
ForEach ($account in $accounts){
    $User = [User]::new()
    $User.DisplayName = $account.DisplayName
    $User.UserPrincipalName = $account.UserPrincipalName
    $User.Mail = $account.Mail
    $User.Id = $account.Id

    $licence = Get-MgUserLicenseDetail -UserId $account.UserPrincipalName
    $User.SkuId = $licence.SkuId
    $User.SkuPartNumber = $licence.SkuPartNumber

    $mailbox = Get-Mailbox -Identity $account.UserPrincipalName | Select-Object DisplayName,@{Name="EmailAddresses";Expression={$_.EmailAddresses | Where-Object {$_ -LIKE "SMTP:*"}}}
    $User.Aliases = $mailbox.EmailAddresses
    
    $User
}

$Users | Select-Object DisplayName,UserPrincipalName,SkuPartNumber,Mail,Aliases | ConvertTo-Csv | Out-File ".\UsersReport.csv"

Disconnect-MgGraph
Disconnect-ExchangeOnline

$LogonEmail = Read-Host "Enter Logon Email"

Connect-ExchangeOnline -UserPrincipalName $LogonEmail


$again = $true

while ($again)
{
    $Option = Read-Host "
    Enter 'g' to see current config,
    Enter 'c' to create new config,
    Enter 'e' to enable DKIM
    Enter 'q' to exit"

    if ($Option -eq "g")
    {Get-DKIMSigningConfig}
    elseif ($Option -eq "c")
    {
        $Domain = Read-Host "Enter Domain"
        New-DKIMSigningConfig -Domain $Domain -Enabled $true
        Get-DKIMSigningConfig
    }
    elseif ($Option -eq "e")
    {
        $Domain = Read-Host "Enter Domain"
        Set-DKIMSigningConfig -Identity $Domain -Enabled $true
        Get-DKIMSigningConfig
    }
    elseif ($Option -eq "q"){$again = $false}
    else{Write-Host "Invalid Option, Try again"}
}

Disconnect-ExchangeOnline -Confirm:$false
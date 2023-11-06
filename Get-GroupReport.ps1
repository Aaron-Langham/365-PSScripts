$LogonEmail = Read-Host "Enter Logon Email"
Connect-ExchangeOnline -UserPrincipalName $LogonEmail
Connect-MgGraph -Scopes "Directory.Read.All"

class Group {
    [string]$Name
    [string]$DisplayName
    [string]$Type
    [Member[]]$Members
    [string]$UserPrincipalName
    [string]$MemberDisplayName
    [string]$Mail
}

class Member {
    [string]$UserPrincipalName
    [string]$MemberDisplayName
    [string]$Mail
}

$gs = Get-Group | Select-Object *
$Groups =
ForEach ($g in $gs){
    $Group = [Group]::new()
    $Group.Name = $g.Name
    $Group.DisplayName = $g.DisplayName
    $Group.Type = $g.GroupType

    $ms = $g.Members
    $Members =
    ForEach ($m in $ms){
        $User = Get-Mailbox -Identity $m | Select-Object *
        if ($User.Length -eq 1){
            $Member = [Member]::new()
            $Member.UserPrincipalName = $User.UserPrincipalName
            $Member.MemberDisplayName = $User.DisplayName
            $Member.Mail = $User.WindowsEmailAddress

            $Member
        }
        else {
            ForEach ($u in $User){
                $grs = Get-MgUserMemberOf -UserId $u.UserPrincipalName | Select-Object *
                ForEach ($gr in $grs){
                    if ($gr.AdditionalProperties.displayName -eq $g.DisplayName){
                        $Member = [Member]::new()
                        $Member.UserPrincipalName = $u.UserPrincipalName
                        $Member.MemberDisplayName = $u.DisplayName
                        $Member.Mail = $u.WindowsEmailAddress

                        $Member
                    }
                }
            }
        }
    }

    $Group.Members = $Members
    $Group
}

$Groups2 =
ForEach ($Group in $Groups){
    $Group
    $Group2 = 
    ForEach ($member in $Group.Members){$member}
    $Group2 = $Group2 | Sort-Object -Property UserPrincipalName -Unique
    $Group2
}

$Groups2 | ConvertTo-Csv | Out-File ".\GroupReport.csv"

Disconnect-MgGraph
Disconnect-ExchangeOnline

Connect-ExchangeOnline 

$newnames = Import-Csv "" #Path to CSV with 1 column called 'Name' with the list of UserPrincipleNames to be added to the group

$group = "" #Name of the Group

$oldnames = Get-UnifiedGroupLinks -Identity $group -LinkType Members

ForEach ($oldname in $oldnames){Remove-UnifiedGroupLinks -Identity $group -LinkType Members -Links $oldname.name -Confirm $true}

ForEach ($newname in $newnames){Add-UnifiedGroupLinks -Identity $group -LinkType Members -Links $newname.Name}


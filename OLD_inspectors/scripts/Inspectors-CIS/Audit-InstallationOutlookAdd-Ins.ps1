function Audit-InstallationOutlookAddIns{
$InstallationOutlookAddIns = Get-EXOMailbox | Select-Object -Unique RoleAssignmentPolicy | ForEach-Object { Get-RoleAssignmentPolicy -Identity $_.RoleAssignmentPolicy | Where-Object {$_.AssignedRoles -like "*Apps*"}} | Select-Object Identity, @{Name="AssignedRoles"; Expression={Get-Mailbox | Select-Object -Unique RoleAssignmentPolicy | ForEach-Object { Get-RoleAssignmentPolicy -Identity $_.RoleAssignmentPolicy | Select-Object -ExpandProperty AssignedRoles | Where-Object {$_ -like "*Apps*"}}}} 
if ($InstallationOutlookAddIns.AssignedRoles -contains 'My Marketplace Apps' -or 'My Custom Apps' -or 'My ReadWriteMailbox Apps'){
return $InstallationOutlookAddIns
}
return $null
}
return Audit-InstallationOutlookAddIns
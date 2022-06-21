$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-InstallationOutlookAddIns{
try{
$InstallationOutlookAddInsData = @()
$InstallationOutlookAddIns = Get-EXOMailbox | Select-Object -Unique RoleAssignmentPolicy | ForEach-Object { Get-RoleAssignmentPolicy -Identity $_.RoleAssignmentPolicy | Where-Object {$_.AssignedRoles -like "*Apps*"}} | Select-Object Identity, @{Name="AssignedRoles"; Expression={Get-Mailbox | Select-Object -Unique RoleAssignmentPolicy | ForEach-Object { Get-RoleAssignmentPolicy -Identity $_.RoleAssignmentPolicy | Select-Object -ExpandProperty AssignedRoles | Where-Object {$_ -like "*Apps*"}}}} 
if ($InstallationOutlookAddIns.AssignedRoles -contains 'My Marketplace Apps' -or 'My Custom Apps' -or 'My ReadWriteMailbox Apps'){
foreach ($InstallationOutlookAddInsDataObj in $InstallationOutlookAddIns){
$InstallationOutlookAddInsData += "$($InstallationOutlookAddIns.Identity), $($InstallationOutlookAddIns.AssignedRoles)"}
return $InstallationOutlookAddInsData
}
return $null
}Catch{
Write-Warning "Error message: $_"
$message = $_.ToString()
$exception = $_.Exception
$strace = $_.ScriptStackTrace
$failingline = $_.InvocationInfo.Line
$positionmsg = $_.InvocationInfo.PositionMessage
$pscommandpath = $_.InvocationInfo.PSCommandPath
$failinglinenumber = $_.InvocationInfo.ScriptLineNumber
$scriptname = $_.InvocationInfo.ScriptName
Write-Verbose "Write to log"
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
Write-Verbose "Errors written to log"
}
}
return Audit-InstallationOutlookAddIns
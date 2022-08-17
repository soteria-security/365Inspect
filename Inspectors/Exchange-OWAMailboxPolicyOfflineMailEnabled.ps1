$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-OWAMailboxPolicyOfflineMailEnabled{
$finalobject = @()
try{
#OWA Mailbox Policy Check Offline
$OWAMailboxPolicies = Get-OwaMailboxPolicy | Select Id,AllowOfflineOn
foreach ($policy in $OWAMailboxPolicies){
$finalobject += $policy.Id
if ($policy.AllowOfflineOn -eq "AllComputers"){
$finalobject += "AllowOfflineOn: $($policy.AllowOfflineOn)"
}
}
if ($finalobject.count -ne 0){
return $finalobject
}else{
return $null
}
}catch{
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
return Audit-OWAMailboxPolicyOfflineMailEnabled
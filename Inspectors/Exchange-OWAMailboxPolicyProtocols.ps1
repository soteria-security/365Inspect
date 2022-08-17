$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-ExchangeMailboxPolicyProtocols{
try{
$finalobject = @()
$owamailboxpolicies = Get-OwaMailboxPolicy | select ActiveSyncIntegrationEnabled,SilverlightEnabled,FacebookEnabled,LinkedInEnabled
$array = @("ActiveSyncIntegrationEnabled","SilverlightEnabled","FacebookEnabled","LinkedInEnabled")
foreach ($owamailboxpolicy in $owamailboxpolicies){
$finalobject += $owamailboxpolicy.Name
foreach ($object in $array){
if ($owamailboxpolicy.$object -eq $true){
$finalobject += "$($object) $($owamailboxpolicy.$object)"
}
}
}
if ($finalobject -ne 0){return $finalobject}else{return $null}
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
return Audit-ExchangeMailboxPolicyProtocols
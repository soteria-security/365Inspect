$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"
 
. $errorHandling

function Audit-AuthenticationPolicyExistenceCheck{
try{
$finalobject = @()
$AuthenticationPolicy = Get-AuthenticationPolicy | Select *
if ($AuthenticationPolicy -eq $null){
return "No AuthenticationPolicy Found!"
}else{
$array = @("AllowBasicAuth","AllowBasicAuthActiveSync","AllowBasicAuthImap","AllowBasicAuthMapi","AllowBasicAuthOfflineAddressBook","AllowBasicAuthAutodiscover","AllowBasicAuthOutlookService","AllowBasicAuthPop","AllowBasicAuthReportingWebService","AllowBasicAuthRest","AllowBasicAuthRpc","AllowBasicAuthSmtp","AllowBasicWebServices","AllowBasicAuthPowershell")
foreach ($policy in $AuthenticationPolicy){
$finalobject += $policy.Name
foreach ($object in $array){
if ($policy.$object -eq $true){
$finalobject += $object
}
}
}
if ($finalobject.count -ne 0){return $finalobject}else{return $null}
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
return Audit-AuthenticationPolicyExistenceCheck
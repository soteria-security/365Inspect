$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-BasicAuthCheckMobileDevice{
$BasicAuthCheckMobileDeviceResults = @()
try{
$BasicAuthCheckMobileDevice = Get-MobileDevice -ResultSize Unlimited | Where {$_.DeviceOS -eq "OutlookBasicAuth"} | Format-Table -Auto UserDisplayName,DeviceAccessState
if ($BasicAuthCheckMobileDevice.Count -ne 0){
foreach ($MobileDevice in $BasicAuthCheckMobileDevice){
$BasicAuthCheckMobileDeviceResults += $MobileDevice.UserDisplayName
}
return $BasicAuthCheckMobileDeviceResults
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
return Audit-BasicAuthCheckMobileDevice
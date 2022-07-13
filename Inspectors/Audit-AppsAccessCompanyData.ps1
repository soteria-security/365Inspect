$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-AppsAccessCompanyData{
try{
$appsaccesscompanydata = Get-MsolCompanyInformation | Select-Object UsersPermissionToUserConsentToAppEnabled
if ($appsaccesscompanydata.UsersPermissionToUserConsentToAppEnabled -match 'True'){
return 'UsersPermissionToUserConsentToAppEnabled: '+ $appsaccesscompanydata.UsersPermissionToUserConsentToAppEnabled
}
return $null
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
return Audit-AppsAccessCompanyData
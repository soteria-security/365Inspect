$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-ModernAuthentication{
try{
$auditmodernauthentication = Get-OrganizationConfig | select Name,OAuth2ClientProfileEnabled
if (!$auditmodernauthentication.OAuth2ClientProfileEnabled -match 'True'){
return 'OAuth2ClientProfileEnabled: '+$auditmodernauthentication.OAuth2ClientProfileEnabled
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
return Audit-ModernAuthentication
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-Basic-Authentication{
try{
$basicauthdata = @()
$basicauth1 = Get-OrganizationConfig | Select-Object -ExpandProperty DefaultAuthenticationPolicy | ForEach { Get-AuthenticationPolicy $_ | Select-Object AllowBasicAuth* }
$basicauth2 = Get-OrganizationConfig | Select-Object DefaultAuthenticationPolicy
$basicauth3 = Get-User -ResultSize Unlimited | Select-Object UserPrincipalName, AuthenticationPolicy
if($basicauth1.DefaultAuthenticationPolicy -contains "" -and $basicauth2.DefaultAuthenticationPolicy -contains "" -and $basicauth3.AuthenticationPolicy -contains ""){
foreach ($basicauthuser in $basicauth3){
$basicauthdata += "$($basicauth3.UserPrincipalName), $($basicauth3.AuthenticationPolicy)"
}
return $basicauthdata
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
return Audit-Basic-Authentication
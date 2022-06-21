$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-MSTeamsSettings{
try{
$MSTeamsSettingsData = @()
$MSTeamsSettings_1 = Get-CsTenantFederationConfiguration | select Identity,AllowedDomains,AllowPublicUsers
$MSTeamsSettings_2 = Get-CsExternalAccessPolicy -Identity Global
if ($MSTeamsSettings_1 -or $MSTeamsSettings_2 -ne $null){
if ($MSTeamsSettings_1.AllowedDomains -match 'AllowAllKnownDomains' -or $MSTeamsSettings_1.AllowPublicUsers -match 'True' -or $MSTeamsSettings_2.EnableFederationAccess -match 'True' -or $MSTeamsSettings_2.EnablePublicCloudAccess -match 'True'){
$MSTeamsSettingsData += " AllowedDomains: "+$MSTeamsSettings_1.AllowedDomains
$MSTeamsSettingsData += "`n AllowPublicUsers: "+$MSTeamsSettings_1.AllowPublicUsers
$MSTeamsSettingsData += " EnableFederationAccess: "+$MSTeamsSettings_2.EnableFederationAccess
$MSTeamsSettingsData += "`n EnablePublicCloudAccess: "+$MSTeamsSettings_2.EnablePublicCloudAccess
return $MSTeamsSettingsData
}
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
return Audit-MSTeamsSettings
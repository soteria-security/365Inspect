$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-MSTeamsSettingsFileSharingOptions{
try{
$MSTeamsSettings_3Data = @()
$MSTeamsSettings_3 = Get-CsTeamsClientConfiguration | select allow*
if ($MSTeamsSettings_3.AllowDropBox -or $MSTeamsSettings_3.AllowGoogleDrive -or $MSTeamsSettings_3.AllowShareFile -or $MSTeamsSettings_3.AllowBox -or $MSTeamsSettings_3.AllowEgnyte -match 'True'){
$MSTeamsSettings_3Data += " AllowDropBox: "+$MSTeamsSettings_3.AllowDropBox
$MSTeamsSettings_3Data += "`n AllowGoogleDrive: "+$MSTeamsSettings_3.AllowGoogleDrive
$MSTeamsSettings_3Data += "`n AllowShareFile: "+$MSTeamsSettings_3.AllowShareFile
$MSTeamsSettings_3Data += "`n AllowBox: "+$MSTeamsSettings_3.AllowBox
$MSTeamsSettings_3Data += "`n AllowEgnyte: "+$MSTeamsSettings_3.AllowEgnyte
return $MSTeamsSettings_3Data
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
return Audit-MSTeamsSettingsFileSharingOptions
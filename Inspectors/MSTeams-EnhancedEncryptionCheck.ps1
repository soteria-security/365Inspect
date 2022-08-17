$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-MSTeamsEnhancedEncryption{
try{
$MSTeamsEnhancedEncryption = @()
$MSTeamsEnhancedEncryptionCMD = Get-CsTeamsEnhancedEncryptionPolicy -Identity Global
if ($MSTeamsEnhancedEncryptionCMD.CallingEndtoEndEncryptionEnabledType -contains 'Disabled'){
$MSTeamsEnhancedEncryption += "CallingEndtoEndEncryptionEnabledType: $($MSTeamsEnhancedEncryptionCMD.CallingEndtoEndEncryptionEnabledType)"
}
if ($MSTeamsEnhancedEncryptionCMD.MeetingEndToEndEncryption -contains 'Disabled'){
$MSTeamsEnhancedEncryption += "MeetingEndToEndEncryption: $($MSTeamsEnhancedEncryptionCMD.MeetingEndToEndEncryption)"
}
if ($MSTeamsEnhancedEncryption.Count -gt 0){
return $MSTeamsEnhancedEncryption
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
return Audit-MSTeamsEnhancedEncryption
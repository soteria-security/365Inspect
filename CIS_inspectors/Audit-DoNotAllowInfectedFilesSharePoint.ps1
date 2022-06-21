$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-DoNotAllowInfectedFileSharePoint{
try{
$DNAIFSP = Get-SPOTenant | Select-Object DisallowInfectedFileDownload
if ($DNAIFSP.DisallowInfectedFileDownload -match 'False'){
return 'DisallowInfectedFileDownload: '+$DNAIFSP.DisallowInfectedFileDownload
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
return Audit-DoNotAllowInfectedFileSharePoint
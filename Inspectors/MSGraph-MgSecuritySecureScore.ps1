$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-MgSecuritySecureScore{
try{
$command = Get-MgSecuritySecureScore -Top 1 | select CreatedDateTime,CurrentScore, MaxScore
if ($command.CurrentScore -ne $command.MaxScore){return "MaxScore of $($command.CreatedDateTime) is not $($command.MaxScore), The CurrentScore is: "+$command.CurrentScore}else{return $null}
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
return Audit-MgSecuritySecureScore
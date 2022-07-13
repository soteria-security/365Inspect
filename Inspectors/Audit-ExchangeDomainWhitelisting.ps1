$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-ExchangeDomainWhitelisting{
try{
$ExchangeDomainWhitelistingData = @()
$ExchangeDomainWhitelisting = Get-TransportRule | Where-Object {($_.setscl -eq -1 -and $_.SenderDomainIs -ne $null)} | select Name,SenderDomainIs
if (!$ExchangeDomainWhitelisting -eq $null){
foreach ($ExchangeDomainWhitelistingDataObj in $ExchangeDomainWhitelisting){
$ExchangeDomainWhitelistingData += "$($ExchangeDomainWhitelisting.Name), $($ExchangeDomainWhitelisting.SenderDomainIs)"}
return $ExchangeDomainWhitelistingData
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
return Audit-ExchangeDomainWhitelisting
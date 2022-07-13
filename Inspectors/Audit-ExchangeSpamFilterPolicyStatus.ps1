$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-ExchangeSpamFilterPolicy{
try{
$ExchangeSpamFilterPolicyData = @()
$ExchangeSpamFilterPolicy = Get-HostedOutboundSpamFilterPolicy | Select-Object BccSuspiciousOutboundMail,NotifyOutboundSpamRecipients,NotifyOutboundSpam
if ($ExchangeSpamFilterPolicy.BccSuspiciousOutboundMail -match 'False' -or $audit.NotifyOutboundSpamRecipients -eq $null -or $ExchangeSpamFilterPolicy.NotifyOutboundSpam -match 'False'){
$ExchangeSpamFilterPolicyData += " BccSuspiciousOutboundMail: "+$ExchangeSpamFilterPolicy.BccSuspiciousOutboundMail
$ExchangeSpamFilterPolicyData += "`n NotifyOutboundSpamRecipients: "+$ExchangeSpamFilterPolicy.NotifyOutboundSpamRecipients
$ExchangeSpamFilterPolicyData += "`n NotifyOutboundSpam: "+$ExchangeSpamFilterPolicy.NotifyOutboundSpam
return $ExchangeSpamFilterPolicyData
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
return Audit-ExchangeSpamFilterPolicy
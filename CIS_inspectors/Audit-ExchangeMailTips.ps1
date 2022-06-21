$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-ExchangeMailTips{
try{
Import-Module ExchangeOnlineManagement
$ExchangeMailTipsData = @()
$ExchangeMailTips = Get-OrganizationConfig |Select-Object MailTipsAllTipsEnabled, MailTipsExternalRecipientsTipsEnabled, MailTipsGroupMetricsEnabled, MailTipsLargeAudienceThreshold
if ($ExchangeMailTips.MailTipsAllTipsEnabled -match 'True' -and $ExchangeMailTips.MailTipsExternalRecipientsTipsEnabled -match 'True' -and $ExchangeMailTips.MailTipsGroupMetricsEnabled -match 'True' -and $ExchangeMailTips.MailTipsLargeAudienceThreshold -ige 25){
$ExchangeMailTipsData += " MailTipsAllTipsEnabled: "+$ExchangeMailTips.MailTipsAllTipsEnabled
$ExchangeMailTipsData += "`n MailTipsExternalRecipientsTipsEnabled: "+$ExchangeMailTips.MailTipsExternalRecipientsTipsEnabled
$ExchangeMailTipsData += "`n MailTipsGroupMetricsEnabled: "+$ExchangeMailTips.MailTipsGroupMetricsEnabled
$ExchangeMailTipsData += "`n MailTipsLargeAudienceThreshold: "+$ExchangeMailTips.MailTipsLargeAudienceThreshold
return $ExchangeMailTipsData
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
return Audit-ExchangeMailTips
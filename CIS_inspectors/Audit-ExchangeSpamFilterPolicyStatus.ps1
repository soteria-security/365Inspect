function Audit-ExchangeSpamFilterPolicy{
$ExchangeSpamFilterPolicyData = @()
$ExchangeSpamFilterPolicy = Get-HostedOutboundSpamFilterPolicy | Select-Object BccSuspiciousOutboundMail,NotifyOutboundSpamRecipients,NotifyOutboundSpam
if ($ExchangeSpamFilterPolicy.BccSuspiciousOutboundMail -match 'False' -or $audit.NotifyOutboundSpamRecipients -eq $null -or $ExchangeSpamFilterPolicy.NotifyOutboundSpam -match 'False'){
$ExchangeSpamFilterPolicyData += " BccSuspiciousOutboundMail: "+$ExchangeSpamFilterPolicy.BccSuspiciousOutboundMail
$ExchangeSpamFilterPolicyData += "`n NotifyOutboundSpamRecipients: "+$ExchangeSpamFilterPolicy.NotifyOutboundSpamRecipients
$ExchangeSpamFilterPolicyData += "`n NotifyOutboundSpam: "+$ExchangeSpamFilterPolicy.NotifyOutboundSpam
return $ExchangeSpamFilterPolicyData
}
return $null
}
return Audit-ExchangeSpamFilterPolicy
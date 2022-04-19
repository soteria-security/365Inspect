function Audit-ExchangeSpamFilterPolicy{
$ExchangeSpamFilterPolicy = Get-HostedOutboundSpamFilterPolicy | Select-Object BccSuspiciousOutboundMail,NotifyOutboundSpam
if ($ExchangeSpamFilterPolicy.BccSuspiciousOutboundMail -eq $null -or $audit.NotifyOutboundSpamRecipients -eq $null -or $ExchangeSpamFilterPolicy.NotifyOutboundSpam -match 'False'){
return $ExchangeSpamFilterPolicy
}
return $null
}
return Audit-ExchangeSpamFilterPolicy
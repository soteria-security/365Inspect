function Audit-ExchangeMailTips{
Import-Module ExchangeOnlineManagement
$ExchangeMailTips = Get-OrganizationConfig |Select-Object MailTipsAllTipsEnabled, MailTipsExternalRecipientsTipsEnabled, MailTipsGroupMetricsEnabled, MailTipsLargeAudienceThreshold
if ($ExchangeMailTips.MailTipsAllTipsEnabled -match 'True' -and $ExchangeMailTips.MailTipsExternalRecipientsTipsEnabled -match 'True' -and $ExchangeMailTips.MailTipsGroupMetricsEnabled -match 'True' -and $ExchangeMailTips.MailTipsLargeAudienceThreshold -ige 25){
return $ExchangeMailTips
}
return $null
}
return Audit-ExchangeMailTips
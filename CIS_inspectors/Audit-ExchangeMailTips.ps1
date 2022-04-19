function Audit-ExchangeMailTips{
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
}
return Audit-ExchangeMailTips
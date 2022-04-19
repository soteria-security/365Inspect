function Audit-ExchangeDomainWhitelisting{
$ExchangeDomainWhitelistingData = @()
$ExchangeDomainWhitelisting = Get-TransportRule | Where-Object {($_.setscl -eq -1 -and $_.SenderDomainIs -ne $null)} | select Name,SenderDomainIs
if (!$ExchangeDomainWhitelisting -eq $null){
foreach ($ExchangeDomainWhitelistingDataObj in $ExchangeDomainWhitelisting){
$ExchangeDomainWhitelistingData += "$($ExchangeDomainWhitelisting.Name), $($ExchangeDomainWhitelisting.SenderDomainIs)"}
return $ExchangeDomainWhitelistingData
}
return $null
}
return Audit-ExchangeDomainWhitelisting
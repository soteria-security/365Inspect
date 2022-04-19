function Audit-ExchangeDomainWhitelisting{
$ExchangeDomainWhitelisting = Get-TransportRule | Where-Object {($_.setscl -eq -1 -and $_.SenderDomainIs -ne $null)} | select Name,SenderDomainIs
if (!$ExchangeDomainWhitelisting -eq $null){
return $ExchangeDomainWhitelisting
}
return $null
}
return Audit-ExchangeDomainWhitelisting
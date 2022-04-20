function Audit-AutoForwardingExchange{
$AutoForwardingExchangeData = @() 
$AutoForwardingExchange_1 = Get-RemoteDomain Default | select AllowedOOFType, AutoForwardEnabled
$AutoForwardingExchange_2 = Get-TransportRule | Where-Object {$_.RedirectMessageTo -ne $null} | select Name,RedirectMessageTo
$AutoForwardingExchange_3 = Get-TransportRule | where { $_.Identity -like '*Client Rules To External Block*' }

if ($AutoForwardingExchange_1 -or $AutoForwardingExchange_2 -or $AutoForwardingExchange_3 -ne $null){

if ($AutoForwardingExchange_1.AllowedOOFType -match 'External' -and $AutoForwardingExchange_1.AutoForwardEnabled -match 'True'){

foreach ($AutoForwardingExchangeDataObj in $AutoForwardingExchange_1){

$AutoForwardingExchangeData += " AllowedOOFType: "+$AutoForwardingExchange_1.AllowedOOFType
$AutoForwardingExchangeData += "`n AutoForwardEnabled: "+$AutoForwardingExchange_1.AutoForwardEnabled
}
}
if(!$AutoForwardingExchange_2 -eq $null){

foreach ($AutoForwardingExchangeDataObj2 in $AutoForwardingExchange_2){

$AutoForwardingExchangeData += " Name: "+$AutoForwardingExchange_2.Name
$AutoForwardingExchangeData += "`n RedirectMessageTo: "+$AutoForwardingExchange_2.RedirectMessageTo
}
}
if($AutoForwardingExchange_3 -eq $null){
$AutoForwardingExchangeData += 'Identity: '+$AutoForwardingExchange_3.Identity}
return $AutoForwardingExchangeData
}
return $null
}
return Audit-AutoForwardingExchange
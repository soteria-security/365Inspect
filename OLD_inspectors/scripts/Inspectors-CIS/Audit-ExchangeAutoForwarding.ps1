function Audit-AutoForwardingExchange{
$AutoForwardingExchange = '' 
$AutoForwardingExchange_1 = Get-RemoteDomain Default | select AllowedOOFType, AutoForwardEnabled
$AutoForwardingExchange_2 = Get-TransportRule | Where-Object {$_.RedirectMessageTo -ne $null} | select Name,RedirectMessageTo
$AutoForwardingExchange_3 = Get-TransportRule | where { $_.Identity -like '*Client Rules To External Block*' }
if ($AutoForwardingExchange_1 -or $AutoForwardingExchange_2 -or $AutoForwardingExchange_3 -ne $null){
if ($AutoForwardingExchange_1.AllowedOOFType -match 'External' -and $AutoForwardingExchange_1.AutoForwardEnabled -match 'True'){
$AutoForwardingExchange += "`n"+$AutoForwardingExchange_1}
if(!$AutoForwardingExchange_2 -eq $null){
$AutoForwardingExchange += "`n"+$AutoForwardingExchange_2}
if($AutoForwardingExchange_3 -eq $null){
 $AutoForwardingExchange += "`n"+$AutoForwardingExchange_3}
return $AutoForwardingExchange
}
return $null
}
return Audit-AutoForwardingExchange

Connect-ExchangeOnline
$audit = Get-RemoteDomain Default | select AllowedOOFType, AutoForwardEnabled
if ($audit.AllowedOOFType -match 'External' -and $audit.AutoForwardEnabled -match 'True'){'VULNERABLE - AutoForwardEnabled is True. External Forwarding is allowed!'}else{'NOT VULNERABLE - AutoForwardEnabled is False, External Forwarding is not allowed!'}
$audit2 = Get-TransportRule | Where-Object {$_.RedirectMessageTo -ne $null} | select Name,RedirectMessageTo
if (!$audit2 -eq $null){'VULNERABLE - External Domains Detected'}else{'NOT VULNERABLE - No External Domains Detected!'}
$audit3 = Get-TransportRule | where { $_.Identity -like '*Client Rules To External Block*' }
if ($audit3 -eq $null){'VULNERABLE - No External Block Message is displayed, thus AutoForwarding to external domains is enabled!'}else{'NOT VULNERABLE - BLOCK MESSAGE IS ACTIVE, AUTOFORWARDING IS DISABLED TO EXTERNAL DOMAINS'}
$audit2
Disconnect-ExchangeOnline
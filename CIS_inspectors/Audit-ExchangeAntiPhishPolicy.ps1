function Audit-AntiPhishPolicy{
Import-Module ExchangeOnlineManagement
$AntiPhishPolicy = Get-AntiPhishPolicy | select Name
if ($AntiPhishPolicy.Name -eq $null){
return 'AntiPhishPolicy: '+$AntiPhishPolicy
}
return $null
}
return Audit-AntiPhishPolicy
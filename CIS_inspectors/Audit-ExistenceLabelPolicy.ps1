function Audit-ExistenceLabelPolicy{
Import-Module ExchangeOnlineManagement
$ExistenceLabelPolicy = Get-LabelPolicy
if ($ExistenceLabelPolicy -eq $null){
return 'ExistenceLabelPolicy: '+$ExistenceLabelPolicy
}
return $null
}
return Audit-ExistenceLabelPolicy
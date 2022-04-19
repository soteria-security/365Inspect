function Audit-PublicGroups{
Import-Module ExchangeOnlineManagement
$publicgroups = Get-UnifiedGroup | ? {$_.AccessType -eq "Public"}
if ($publicgroups.AccessType -contains 'Public'){
return $publicgroups
}
return $null
}
return Audit-PublicGroups
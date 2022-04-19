function Audit-PublicGroups{
Import-Module ExchangeOnlineManagement
$publicgroupsdata = @()
$publicgroups = Get-UnifiedGroup | ? {$_.AccessType -eq "Public"}
if ($publicgroups.AccessType -contains 'Public'){
foreach ($publicgroupsdataobj in $publicgroups){
$publicgroupsdata += "$($publicgroups.DisplayName),$($publicgroups.AccessType)"}
return $publicgroupsdata
}
return $null
}
return Audit-PublicGroups
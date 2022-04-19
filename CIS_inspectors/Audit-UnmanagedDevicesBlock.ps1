function Audit-SPOUnmanagedDevicesBlock{
$SPOUnmanagedDevicesBlockData = @()
$SPOUnmanagedDevicesBlock = Get-SPOTenantSyncClientRestriction | select TenantRestrictionEnabled,AllowedDomainList,BlockMacSync
if ($SPOUnmanagedDevicesBlock.TenantRestrictionEnabled -match 'False' -or $SPOUnmanagedDevicesBlock.BlockMacSync -match 'False'){
$SPOUnmanagedDevicesBlockData += " TenantRestrictionEnabled: "+$SPOUnmanagedDevicesBlock.TenantRestrictionEnabled
$SPOUnmanagedDevicesBlockData += "`n AllowedDomainList: "+$SPOUnmanagedDevicesBlock.AllowedDomainList
$SPOUnmanagedDevicesBlockData += "`n BlockMacSync: "+$SPOUnmanagedDevicesBlock.BlockMacSync
return $SPOUnmanagedDevicesBlockData
}
return $null
}
return Audit-SPOUnmanagedDevicesBlock
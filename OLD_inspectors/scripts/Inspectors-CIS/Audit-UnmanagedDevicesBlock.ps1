function Audit-SPOUnmanagedDevicesBlock{
$SPOUnmanagedDevicesBlock = Get-SPOTenantSyncClientRestriction | select TenantRestrictionEnabled,AllowedDomainList,BlockMacSync
if ($audit.TenantRestrictionEnabled -match 'False' -or $audit.BlockMacSync -match 'False'){
return $SPOUnmanagedDevicesBlock
}
return $null
}
return Audit-SPOUnmanagedDevicesBlock

'VULNERABLE - No AllowList set up and Unmanaged Device Restriction Enabled'
'VULNERABLE - Mac Devices are not Blocked from Sync!'
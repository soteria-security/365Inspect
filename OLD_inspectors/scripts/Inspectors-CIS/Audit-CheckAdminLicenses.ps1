function Audit-CheckAdminLicenses{
$checkadminlic = Get-MsolRole | %{$role = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid} | Where-Object -Property isLicensed -match 'True'
if ($checkadminlic.count -igt 0){
return $checkadminlic
}
return $null
}
return Audit-AdditionalStorageProvidersAvailable
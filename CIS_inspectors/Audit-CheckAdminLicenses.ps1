function Audit-CheckAdminLicenses{
$checkadminlicdata = @()
$checkadminlic = Get-MsolRole | %{$role = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid} | Where-Object -Property isLicensed -match 'True'
if ($checkadminlic.count -igt 0){
$checkadminlicdata += "$($checkadminlic.EmailAddress)"+ "`n"
return $checkadminlicdata
}
return $null
}
return Audit-CheckAdminLicenses
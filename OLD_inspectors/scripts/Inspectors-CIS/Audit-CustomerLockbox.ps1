function Audit-CustomerLockbox{
$CustomerLockbox = Get-OrganizationConfig |Select-Object CustomerLockBoxEnabled

if ($CustomerLockbox.CustomerLockBoxEnabled -match 'False'){
return $CustomerLockbox
}
return $null
}
return Audit-CustomerLockbox
function Audit-CustomerLockbox{
$CustomerLockbox = Get-OrganizationConfig |Select-Object CustomerLockBoxEnabled

if ($CustomerLockbox.CustomerLockBoxEnabled -match 'False'){
return 'CustomerLockBoxEnabled: '+$CustomerLockbox.CustomerLockBoxEnabled
}
return $null
}
return Audit-CustomerLockbox
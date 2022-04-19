function Audit-AppsAccessCompanyData{
$appsaccesscompanydata = Get-MsolCompanyInformation | Select-Object UsersPermissionToUserConsentToAppEnabled
if ($appsaccesscompanydata.UsersPermissionToUserConsentToAppEnabled -match 'True'){
return 'UsersPermissionToUserConsentToAppEnabled: '+ $appsaccesscompanydata.UsersPermissionToUserConsentToAppEnabled
}
return $null
}
return Audit-AppsAccessCompanyData
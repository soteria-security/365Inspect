function Audit-AppsAccessCompanyData{
$appsaccesscompanydata = Get-MsolCompanyInformation | Select-Object UsersPermissionToUserConsentToAppEnabled
if ($appsaccesscompanydata.UsersPermissionToUserConsentToAppEnabled -match 'True'){
return $appsaccesscompanydata
}
return $null
}
return Audit-AdditionalStorageProvidersAvailable
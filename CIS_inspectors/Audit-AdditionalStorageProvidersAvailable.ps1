function Audit-AdditionalStorageProvidersAvailable{
$AdditionalStorageProvidersAvailable = Get-OwaMailboxPolicy | Select Name, AdditionalStorageProvidersAvailable
if ($AdditionalStorageProvidersAvailable.AdditionalStorageProvidersAvailable -match 'True'){
return 'AdditionalStorageProvidersAvailable: '+$AdditionalStorageProvidersAvailable.AdditionalStorageProvidersAvailable
}
return $null
}
return Audit-AdditionalStorageProvidersAvailable
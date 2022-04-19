function Audit-AdditionalStorageProvidersAvailable{
$additionalstorageprovider = Get-OwaMailboxPolicy | Select Name, AdditionalStorageProvidersAvailable
if ($audit.AdditionalStorageProvidersAvailable -match 'True'){
return $additionalstorageprovider
}
return $null
}
return Audit-AdditionalStorageProvidersAvailable
function Audit-SelfServicePasswordResetCheck{
$selfservicepswdreset = Get-MsolCompanyInformation | Select SelfServePasswordResetEnabled
if ($selfservicepswdreset.SelfServePasswordResetEnabled -match 'False'){
return $selfservicepswdreset
}
return $null
}
return Audit-AdditionalStorageProvidersAvailable
function Audit-SelfServicePasswordResetCheck{
$selfservicepswdreset = Get-MsolCompanyInformation | Select SelfServePasswordResetEnabled
if ($selfservicepswdreset.SelfServePasswordResetEnabled -match 'False'){
return 'SelfServePasswordResetEnabled: '+$selfservicepswdreset.SelfServePasswordResetEnabled
}
return $null
}
return Audit-SelfServicePasswordResetCheck
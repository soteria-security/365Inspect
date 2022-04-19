#Applies to CIS P2.6+2.7 and the URL https://soteria.io/azure-ad-default-configuration-blunders/ for extra audit material!
function Audit-DURPAZAPPT2{
$DURPAZAPPT2Data = @()
$DURPAZAPPT2 = Get-MsolCompanyInformation | select UsersPermissionToReadOtherUsersEnabled,UsersPermissionToCreateGroupsEnabled,UsersPermissionToUserConsentToAppEnabled
if ($DURPAZAPPT2.UsersPermissionToReadOtherUsersEnabled -match 'True' -or $DURPAZAPPT2.UsersPermissionToCreateGroupsEnabled -match 'True' -or $DURPAZAPPT2.UsersPermissionToUserConsentToAppEnabled -match 'True'){
foreach ($DURPAZAPPT2DataObj in $DURPAZAPPT2){
$DURPAZAPPT2Data += " UsersPermissionToReadOtherUsersEnabled: "+$DURPAZAPPT2.UsersPermissionToReadOtherUsersEnabled
$DURPAZAPPT2Data += "`n UsersPermissionToCreateGroupsEnabled: "+$DURPAZAPPT2.UsersPermissionToCreateGroupsEnabled
$DURPAZAPPT2Data += "`n UsersPermissionToUserConsentToAppEnabled: "+$DURPAZAPPT2.UsersPermissionToUserConsentToAppEnabled
}
return $DURPAZAPPT2Data
}
return $null
}
return Audit-DURPAZAPPT2
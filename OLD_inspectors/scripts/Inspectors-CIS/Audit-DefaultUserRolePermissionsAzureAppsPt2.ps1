#Applies to CIS P2.6+2.7 and the URL https://soteria.io/azure-ad-default-configuration-blunders/ for extra audit material!
function Audit-DURPAZAPPT2{
$DURPAZAPPT2 = Get-MsolCompanyInformation | select UsersPermissionToReadOtherUsersEnabled,UsersPermissionToCreateGroupsEnabled,UsersPermissionToUserConsentToAppEnabled
if ($DURPAZAPPT2.UsersPermissionToReadOtherUsersEnabled -match 'True' -or $DURPAZAPPT2.UsersPermissionToCreateGroupsEnabled -match 'True' -or $DURPAZAPPT2.UsersPermissionToUserConsentToAppEnabled -match 'True'){
return $DURPAZAPPT2
}
return $null
}
return Audit-DURPAZAPPT2
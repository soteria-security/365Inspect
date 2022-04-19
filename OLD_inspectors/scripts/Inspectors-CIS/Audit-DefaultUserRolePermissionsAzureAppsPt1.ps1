#Applies to CIS P2.6+2.7 and the URL https://soteria.io/azure-ad-default-configuration-blunders/ for extra audit material!
function Audit-DURPAZAPPT1{
$DURPAZAPPT1 = Get-AzureADMSAuthorizationPolicy | select AllowedToSignUpEmailBasedSubscriptions,AllowEmailVerifiedUsersToJoinOrganization -ExpandProperty DefaultUserRolePermissions -ExcludeProperty PermissionGrantPoliciesAssigned
if ($DURPAZAPPT1.AllowedToCreateApps -match 'True' -or $DURPAZAPPT1.AllowedToCreateSecurityGroups -match 'True' -or $DURPAZAPPT1.AllowedToReadOtherUsers -match 'True' -or $DURPAZAPPT1.AllowedToSignUpEmailBasedSubscriptions -match 'True' -or $DURPAZAPPT1.AllowEmailVerifiedUsersToJoinOrganization -match 'True'){
return $DURPAZAPPT1
}
return $null
}
return Audit-DURPAZAPPT1
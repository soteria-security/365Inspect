#Applies to CIS P2.6+2.7 and the URL https://soteria.io/azure-ad-default-configuration-blunders/ for extra audit material!
function Audit-DURPAZAPPT1{
$DURPAZAPPT1DATA = @()
$DURPAZAPPT1 = Get-AzureADMSAuthorizationPolicy | select AllowedToSignUpEmailBasedSubscriptions,AllowEmailVerifiedUsersToJoinOrganization -ExpandProperty DefaultUserRolePermissions -ExcludeProperty PermissionGrantPoliciesAssigned
if ($DURPAZAPPT1.AllowedToCreateApps -match 'True' -or $DURPAZAPPT1.AllowedToCreateSecurityGroups -match 'True' -or $DURPAZAPPT1.AllowedToReadOtherUsers -match 'True' -or $DURPAZAPPT1.AllowedToSignUpEmailBasedSubscriptions -match 'True' -or $DURPAZAPPT1.AllowEmailVerifiedUsersToJoinOrganization -match 'True'){
$DURPAZAPPT1DATA += " AllowedToCreateApps: "+$DURPAZAPPT1.AllowedToCreateApps
$DURPAZAPPT1DATA += "`n AllowedToCreateSecurityGroups: "+$DURPAZAPPT1.AllowedToCreateSecurityGroups
$DURPAZAPPT1DATA += "`n AllowedToReadOtherUsers: "+$DURPAZAPPT1.AllowedToReadOtherUsers
$DURPAZAPPT1DATA += "`n AllowedToSignUpEmailBasedSubscriptions: "+$DURPAZAPPT1.AllowedToSignUpEmailBasedSubscriptions
$DURPAZAPPT1DATA += "`n AllowEmailVerifiedUsersToJoinOrganization: "+$DURPAZAPPT1.AllowEmailVerifiedUsersToJoinOrganization
return $DURPAZAPPT1DATA
}
return $null
}
return Audit-DURPAZAPPT1
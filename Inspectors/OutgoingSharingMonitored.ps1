function Inspect-OutgoingSharingMonitored {
	$tenant = Get-SPOTenant
	
	If ((-NOT $tenant.BccExternalSharingInvitations) -OR (-NOT $tenant.BccExternalSharingInvitationsList)) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-OutgoingSharingMonitored
function Inspect-OutgoingSharingMonitored {
	$tenant = Get-SPOTenant
	
	If ($tenant.SharingCapability -ne "Disabled"){
		If ((-NOT $tenant.BccExternalSharingInvitations) -OR (-NOT $tenant.BccExternalSharingInvitationsList)) {
			return @($org_name)
		}
	Else{
		return $null
		}
	}
}

return Inspect-OutgoingSharingMonitored
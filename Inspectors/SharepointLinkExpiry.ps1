function Inspect-SharepointLinkExpiry {
	If ((Get-SPOTenant).SharingCapability -eq "ExternalUserAndGuestSharing"){
		If ((Get-SPOTenant).RequireAnonymousLinksExpireInDays -eq -1) {
			return @($org_name)
		}
	Else{
		return $null
		}
	}
}

return Inspect-SharepointLinkExpiry
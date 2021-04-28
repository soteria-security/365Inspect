function Inspect-SharepointLinkExpiry {
	If ((Get-SPOTenant).RequireAnonymousLinksExpireInDays -eq -1) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-SharepointLinkExpiry
function Inspect-SharepointLegacyAuthEnabled {
	If ($(Get-SPOTenant).LegacyAuthProtocolsEnabled) {
		return @($org_name)
	}
	return $null
}

return Inspect-SharepointLegacyAuthEnabled
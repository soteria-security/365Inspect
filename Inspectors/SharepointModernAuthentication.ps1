function Inspect-SharepointModernAuthentication {
	$sharepoint_modern_auth_disabled = $(Get-SPOTenant).OfficeClientADALDisabled
	If ($sharepoint_modern_auth_disabled) {
		return @($org_name)
	}
	return $null
}

return Inspect-SharepointModernAuthentication
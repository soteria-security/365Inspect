function Inspect-ThirdPartyIntegratedAppPermission {
	If ((Get-MsolCompanyInformation).UsersPermissionToUserConsentToAppEnabled) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-ThirdPartyIntegratedAppPermission
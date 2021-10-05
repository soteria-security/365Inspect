function Inspect-SharepointExternalUserResharing {
	If (-NOT (Get-SPOTenant).PreventExternalUsersFromResharing) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-SharepointExternalUserResharing
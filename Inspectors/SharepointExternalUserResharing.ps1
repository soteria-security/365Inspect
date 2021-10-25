function Inspect-SharepointExternalUserResharing {
	If ((Get-SPOTenant).SharingCapability -ne "Disabled"){
		If (-NOT (Get-SPOTenant).PreventExternalUsersFromResharing) {
			return @($org_name)
		}
	Else{
		return $null
		}
	}
}

return Inspect-SharepointExternalUserResharing
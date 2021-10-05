function Inspect-SharepointExternalSharing {
	$sharing_capability = (Get-SPOTenant).SharingCapability
	If ($sharing_capability -ne "Disabled") {
		$message = $org_name + ": " + "Sharing capability is " + $sharing_capability + "."
		return @($message)
	}
	
	return $null
}

return Inspect-SharepointExternalSharing
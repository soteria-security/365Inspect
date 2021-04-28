function Inspect-ExternalCalendarSharing {
	$enabled_share_policies = Get-SharingPolicy | Where-Object -FilterScript {$_.Enabled}
	$enabled_external_share_policies = @()
	
	ForEach ($policy in $enabled_share_policies) {
		$domains = $policy | Select-Object -ExpandProperty Domains
		$calendar_sharing_anon = ($domains -like 'Anonymous:Calendar*')
		If ($calendar_sharing_anon.Count -NE 0) {
			$enabled_external_share_policies += $policy.Name
		}
	}
	
	If ($enabled_external_share_policies.Count -NE 0) {
		return $enabled_external_share_policies
	}
	
	return $null
}

return Inspect-ExternalCalendarSharing
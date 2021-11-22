function Inspect-NoSafeLinksForTeams {
	Try {
		$safelinks_for_teams_policies = Get-SafeLinksPolicy | Where-Object {($_.IsEnabled -eq $true) -AND ($_.EnableSafeLinksForTeams -ne $true)}
		If ($safelinks_for_teams_policies.Count -ne 0) {
			return @($org_name)
		}
	} Catch [System.Management.Automation.CommandNotFoundException] {
		return $null
	}
	
	return $null
}

return Inspect-NoSafeLinksForTeams
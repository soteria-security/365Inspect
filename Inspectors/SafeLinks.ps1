function Inspect-ATPSafeLinks {
	# This will throw an error if the environment under test does not have an ATP license,
	# but should still work.
	Try {
		$safe_links_policies = Get-SafeLinksPolicy
		If (!($safe_links_policies)) {
			return @($org_name)
		}
	} Catch [System.Management.Automation.CommandNotFoundException] {
		return $null
	}
	
	return $null
}

return Inspect-ATPSafeLinks
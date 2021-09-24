function Inspect-SafeLinksClickThrough {
	Try {
		$click_through_policies = Get-SafeLinksPolicy | Where { !$_.DoNotAllowClickThrough }
		If ($click_through_policies.Count -ne 0) {
			return @($org_name)
		}
	} Catch [System.Management.Automation.CommandNotFoundException] {
		return $null
	}
	
	return $null
}

return Inspect-SafeLinksClickThrough
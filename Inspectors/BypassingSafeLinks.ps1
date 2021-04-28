function Inspect-BypassingSafeLinks {
	$safe_links_bypass_rules = (Get-TransportRule | Where { $_.SetHeaderName -eq "X-MS-Exchange-Organization-SkipSafeLinksProcessing" }).Identity
	
	If ($safe_links_bypass_rules.Count -ne 0) {
		return $safe_links_bypass_rules
	}
	
	return $null
}

return Inspect-BypassingSafeLinks
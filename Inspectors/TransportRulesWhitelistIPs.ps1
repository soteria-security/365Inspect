function Inspect-TransportRulesWhitelistIPs {
	$ip_whitelist_rules = (Get-TransportRule | Where { $_.SetSCL -AND ($_.SetSCL -as [int] -LE 0) -AND $_.SenderIPRanges }).Name
	
	If ($ip_whitelist_rules.Count -eq 0) {
		return $null
	}
	
	return $ip_whitelist_rules
}

return Inspect-TransportRulesWhitelistIPs
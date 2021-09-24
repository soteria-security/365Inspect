function Inspect-TransportRulesWhitelistDomains {
	$domain_whitelist_rules = (Get-TransportRule | Where { $_.SetSCL -AND ($_.SetSCL -as [int] -LE 0) -AND $_.SenderDomainIs }).Name
	
	If ($domain_whitelist_rules.Count -eq 0) {
		return $null
	}
	
	return $domain_whitelist_rules
}

return Inspect-TransportRulesWhitelistDomains
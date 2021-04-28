function Inspect-DMARCPolicyAction {
	$domains = (Get-MsolDomain).Name
	$domains_without_actions = @()
	
	ForEach($domain in $domains) {
		($dmarc_record = ((nslookup -querytype=txt _dmarc.$domain 2>&1 | Select-String "DMARC1") -replace "`t", "")) | Out-Null
		
		If ($dmarc_record -Match "p=none;") {
			$domains_without_actions += $domain
		}
	}
	
	If ($domains_without_actions.Count -ne 0) {
		return $domains_without_actions
	}
	
	return $null
}

return Inspect-DMARCPolicyAction
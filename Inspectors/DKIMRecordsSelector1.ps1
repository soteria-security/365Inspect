function Inspect-DKIMRecordsSelector1 {
	$domains = (Get-MsolDomain).Name
	$domains_without_records = @()
	
	ForEach($domain in $domains) {
		($dkim_one_output = (nslookup -querytype=cname selector1._domainkey.$domain 2>&1 | Select-String "canonical name")) | Out-Null
		
		If (-NOT $dkim_one_output) {
			$domains_without_records += $domain
		}
	}
	
	If ($domains_without_records.Count -ne 0) {
		return $domains_without_records
	}
	
	return $null
}

return Inspect-DKIMRecordsSelector1
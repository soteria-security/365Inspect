function Inspect-SPFRecords {
	$domains = (Get-MsolDomain).Name
	$domains_without_records = @()
	
	# The redirection is kind of a cheesy hack to prevent the output from
	# cluttering the screen.
	ForEach($domain in $domains) {
		($spf_record = ((nslookup -querytype=txt $domain 2>&1 | Select-String "spf1") -replace "`t", "")) | Out-Null
		
		If (-NOT $spf_record) {
			$domains_without_records += $domain
		}
	}
	
	If ($domains_without_records.Count -ne 0) {
		return $domains_without_records
	}
	
	return $null
}

return Inspect-SPFRecords
function Inspect-DMARCRecords {
	$domains = (Get-MsolDomain).Name
	$domains_without_records = @()
	
	ForEach($domain in $domains) {
		($dmarc_record = ((nslookup -querytype=txt _dmarc.$domain 2>&1 | Select-String "DMARC1") -replace "`t", "")) | Out-Null
		
		If (-NOT $dmarc_record) {
			$domains_without_records += $domain
		}
	}
	
	If ($domains_without_records.Count -ne 0) {
		return $domains_without_records
	}
	
	return $null
}

return Inspect-DMARCRecords
function Inspect-DKIMRecordsSelector2 {
	$domains = Get-MsolDomain | Where-Object {$_.name -notlike "*.onmicrosoft.com"}
	$domains_without_records = @()
	
	ForEach($domain in $domains.name) {
		($dkim_two_output = (nslookup -querytype=cname selector2._domainkey.$domain 2>&1 | Select-String "canonical name")) | Out-Null
		
		If (-NOT $dkim_two_output) {
			$domains_without_records += $domain
		}
	}
	
	If ($domains_without_records.Count -ne 0) {
		return $domains_without_records
	}
	
	return $null
}

return Inspect-DKIMRecordsSelector2
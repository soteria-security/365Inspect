function Inspect-SPFSoftFail {
	$domains = Get-MsolDomain | Where-Object {$_.name -notlike "*.onmicrosoft.com"}
    $domains_with_soft_fail = @()
	
    ForEach($domain in $domains.name) {
        ($spf_record = ((nslookup -querytype=txt $domain 2>&1 | Select-String "spf1") -replace "`t", "")) | Out-Null
		
        If ( -NOT ( $spf_record -Match "-all" ) ) {
            $domains_with_soft_fail += $domain
        }
    }
	
    If ($domains_with_soft_fail.Count -ne 0) {
        return $domains_with_soft_fail
    }
	
    return $null
}

return Inspect-SPFSoftFail
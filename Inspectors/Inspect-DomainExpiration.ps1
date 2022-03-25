Function Inspect-DomainExpiration {
    $domains = Get-AcceptedDomain

    $results = @()

    foreach ($domain in $domains.DomainName){
        $expDate = whois $domain | select-string "Registry Expiry Date" -ErrorAction SilentlyContinue

        $results += "$domain - $expDate"
    }

    Return $results
}

Return Inspect-DomainExpiration
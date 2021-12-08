function Inspect-DomainSpoofingRule {
	$rules = Get-TransportRule
	$flag = $False
    $domains = (Get-AcceptedDomain).DomainName

	ForEach ($domain in $domains) {
        ForEach ($rule in $rules) {    
            if (($rule.FromScope -eq "NotInOrganization") -AND ($rule.SenderDomainIs -contains $domain) -AND (($rule.DeleteMessage -ne $false) -OR ($null -ne $rule.RejectMessageReasonText))) {
                $flag = $True
            }
        }
    }
	
	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-DomainSpoofingRule
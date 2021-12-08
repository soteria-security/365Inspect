function Get-AntiSpoofingPolicy {
	$policies = Get-AntiPhishPolicy | Where-object {$_.enabled -eq $true}
	$flag = $False

    If ($policies.Count -ne 0){
        ForEach ($policy in $policies) {    
            if (($policy.EnableSpoofIntelligence -eq $true) -and (($policy.EnableOrganizationDomainsProtection -eq $true) -or ($policy.EnableTargetedDomainsProtection -eq $true) -or ($policy.EnableTargetedUserProtection -eq $true))) {
                $flag = $True
            }
        }
    }
	
	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null
}

return Get-AntiSpoofingPolicy
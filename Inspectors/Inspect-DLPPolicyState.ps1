Function Inspect-DLPPolicyState {
	$dlpPolicies = Get-DlpCompliancePolicy | Where-Object {$_.Mode -notlike "Enable"}

    $policies = @()
    
    foreach ($policy in $dlpPolicies){
        $policies += "$($policy.Name) state is $($policy.mode)"
    }

    If ($policies.Count -gt 0){
        Return $policies
    }
    Return $null
}
return Inspect-DLPPolicyState
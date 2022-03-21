Function Inspect-customDLPPolicies {
	$dlpPolicies = Get-DlpCompliancePolicy | Where-Object {$_.Name -notlike "Default*"}
    
    If ($dlpPolicies.count -lt 1){
        Return "No custom DLP policies configured."
    }
    Return $null
}
return Inspect-customDLPPolicies
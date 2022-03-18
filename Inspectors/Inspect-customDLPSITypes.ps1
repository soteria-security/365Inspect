Function Inspect-customDLPSITypes {
	$dlpPolicies = Get-DlpSensitiveInformationType | Where-Object {$_.publisher -notlike "Microsoft Corporation"}
    
    If ($dlpPolicies.count -lt 1){
        Return "No custom DLP sensitive information types defined."
    }
    Return $null
}
return Inspect-customDLPSITypes
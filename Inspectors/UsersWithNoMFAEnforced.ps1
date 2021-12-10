function Inspect-UsersWithNoMFAEnforced {
	# Query Security defaults to see if it's enabled. If it is, skip this check.
	$secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
    If ($secureDefault.IsEnabled -eq $false){
		$conditionalAccess = Get-AzureADMSConditionalAccessPolicy

		$flag = $false
		
		Foreach ($policy in $conditionalAccess) {
			If (($policy.conditions.users.includeusers -eq "All") -and ($policy.grantcontrols.builtincontrols -like "Mfa")){
				$flag = $true
			}
		}

		If (!$flag){
			$unenforced_users = (Get-MsolUserByStrongAuthentication -MaxResults 999999 | Where-Object {($_.isLicensed -eq $true) -and ($_.StrongAuthenticationRequirements.State -NE "Enforced")}).UserPrincipalName
			$num_unenforced_users = $unenforced_users.Count
			If ($num_unenforced_users -NE 0) {
				return $unenforced_users
			}
		}
	}
	return $null
}

return Inspect-UsersWithNoMFAEnforced
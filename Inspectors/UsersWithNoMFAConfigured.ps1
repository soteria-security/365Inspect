function Inspect-UsersWithNoMFAConfigured {
	$conditionalAccess = Get-AzureADMSConditionalAccessPolicy

	$flag = $false
	
	Foreach ($policy in $conditionalAccess) {
		If (($policy.conditions.users.includeusers -eq "All") -and ($policy.grantcontrols.builtincontrols -like "Mfa")){
			$flag = $true
		}
	}

	If (!$flag){
		$unenabled_users = (Get-MsolUser -All | Where-Object {($_.isLicensed -eq $true) -and ($_.StrongAuthenticationMethods.Count -eq 0) -and ($_.BlockCredential -eq $False) -and ($_.StrongAuthenticationRequirements.State -NE "Enforced")}).UserPrincipalName
		
		If ($unenabled_users -ne 0) {
			return $unenabled_users.count
		}
	}
		
	return $null
}

return Inspect-UsersWithNoMFAConfigured
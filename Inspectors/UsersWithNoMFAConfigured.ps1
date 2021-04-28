function Inspect-UsersWithNoMFAConfigured {
	$unenabled_users = (Get-MsolUser -All | Where-Object {($_.StrongAuthenticationMethods.Count -eq 0) -and ($_.BlockCredential -eq $False)}).UserPrincipalName
	
	If ($unenabled_users -ne 0) {
		return $unenabled_users
	}
	
	return $null
}

return Inspect-UsersWithNoMFAConfigured
function Inspect-UsersWithNoMFAEnforced {
	# -All has been broken for ~5 years, unfortunately.
	# Might be a way to better query this with Graph or something.
	$unenforced_users = (Get-MsolUserByStrongAuthentication -All | Where-Object {$_.StrongAuthenticationRequirements.State -NE "Enforced"}).UserPrincipalName
	$num_unenforced_users = $unenforced_users.Count

	If ($num_unenforced_users -NE 0) {
		return $unenforced_users
	}
	
	return $null
}

return Inspect-UsersWithNoMFAEnforced
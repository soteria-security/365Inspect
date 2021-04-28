function Inspect-PasswordExpiry {
	$pass_expiry = (Get-MsolPasswordPolicy -DomainName "$org_name.onmicrosoft.com").ValidityPeriod
	
	If (-NOT ($pass_expiry -eq 2147483647)) {
		return @($org_name)
	}
	return $null
}

return Inspect-PasswordExpiry
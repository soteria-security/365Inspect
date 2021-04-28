function Inspect-ExchangeModernAuthentication {
	$orgs_without_MA = @()
	Get-OrganizationConfig | 
		ForEach-Object -Process {if (!$_.OAuth2ClientProfileEnabled) {$orgs_without_MA += $_.Name;}}
		
	If ($orgs_without_MA.Count -NE 0) {
		return $orgs_without_MA
	}
	
	return $null
}

return Inspect-ExchangeModernAuthentication
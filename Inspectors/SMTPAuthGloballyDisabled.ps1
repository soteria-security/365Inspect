function Inspect-SMTPAuthGloballyDisabled {
	# Query Security defaults to see if it's enabled. If it is, skip this check.
	$secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
    If ($secureDefault.IsEnabled -eq $false){
		If (Get-TransportConfig | Where-Object {!$_.SmtpClientAuthenticationDisabled}) {
			return @($org_name)
		}
	}
	
	return $null
}

return Inspect-SMTPAuthGloballyDisabled

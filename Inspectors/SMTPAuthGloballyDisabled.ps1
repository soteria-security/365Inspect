function Inspect-SMTPAuthGloballyDisabled {
	If (Get-TransportConfig | Where-Object {!$_.SmtpClientAuthenticationDisabled}) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-SMTPAuthGloballyDisabled

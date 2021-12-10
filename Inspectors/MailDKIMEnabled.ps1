function Inspect-MailDKIMEnabled {
	$domains_without_dkim = (Get-DkimSigningConfig | Where-Object {(!$_.Enabled) -and ($_.Domain -notlike "*.onmicrosoft.com")}).Domain
	
	If ($domains_without_dkim.Count -NE 0) {
		return $domains_without_dkim
	}
	
	return $null
}

return Inspect-MailDKIMEnabled
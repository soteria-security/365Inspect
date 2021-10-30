function Inspect-MailboxesWithSMTPEnabled {
	# Query Security defaults to see if it's enabled. If it is, skip this check.
	$secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
    If ($secureDefault.IsEnabled -eq $false){
		$smtp = (Get-CasMailbox -ResultSize Unlimited | Where-Object {!$_.SmtpClientAuthenticationDisabled}).Name
	}
	
	If ($smtp.Count -NE 0) {
		return $non_smtp
	}
	
	return $null
}

return Inspect-MailboxesWithSMTPEnabled
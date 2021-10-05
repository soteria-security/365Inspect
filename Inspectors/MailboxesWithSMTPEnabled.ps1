function Inspect-MailboxesWithSMTPEnabled {
	$smtp = (Get-CasMailbox -ResultSize Unlimited | Where-Object {!$_.SmtpClientAuthenticationDisabled}).Name
	
	If ($smtp.Count -NE 0) {
		return $non_smtp
	}
	
	return $null
}

return Inspect-MailboxesWithSMTPEnabled
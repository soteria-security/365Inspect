function Inspect-MailboxesWithPOPEnabled {
	$pop = (Get-CasMailbox -ResultSize Unlimited | Where-Object { $_.PopEnabled }).Name
	
	If ($pop.Count -NE 0) {
		return $pop
	}
	
	return $null
}

return Inspect-MailboxesWithPOPEnabled
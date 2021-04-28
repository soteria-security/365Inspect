function Inspect-MailboxAuditingEnabled {
	$mailboxes_without_auditing = (Get-Mailbox -ResultSize Unlimited | Where-Object {!$_.AuditEnabled}).Name
	If ($mailboxes_without_auditing.Count -NE 0) {
		return $mailboxes_without_auditing
	}
	
	return $null
}

return Inspect-MailboxAuditingEnabled
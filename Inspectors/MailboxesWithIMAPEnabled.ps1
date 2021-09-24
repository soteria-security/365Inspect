function Inspect-MailboxesWithIMAPEnabled {
	return (Get-CasMailbox -ResultSize Unlimited | Where-Object {$_.ImapEnabled}).Name
}

return Inspect-MailboxesWithIMAPEnabled
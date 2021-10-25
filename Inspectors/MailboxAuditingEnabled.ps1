function Inspect-MailboxAuditingEnabled {
	$audit_disabled = (Get-OrganizationConfig).AuditDisabled

	If ($audit_disabled -eq $true){
		$mailboxes_without_auditing = (Get-EXOMailbox -ResultSize Unlimited | Where-Object {!$_.AuditEnabled}).Name
		If ($mailboxes_without_auditing.Count -NE 0) {
			return $mailboxes_without_auditing
			}
		}
	Else{
		return $null
	}
}

return Inspect-MailboxAuditingEnabled
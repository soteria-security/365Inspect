function Inspect-MailboxAuditingAtTenantLevel {
	$audit_disabled = (Get-OrganizationConfig).AuditDisabled
	
	If ($audit_disabled -eq $true) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-MailboxAuditingAtTenantLevel
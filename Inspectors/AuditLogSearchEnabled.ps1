function Inspect-AuditLogSearchEnabled {
	If (-NOT (Get-AdminAuditLogConfig).UnifiedAuditLogIngestionEnabled) {
		return @(org_name)
	}
	
	return $null
}

return Inspect-AuditLogSearchEnabled
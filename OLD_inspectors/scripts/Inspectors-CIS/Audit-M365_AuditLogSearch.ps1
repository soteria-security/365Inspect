function Audit-AuditLogSearch{
Import-Module ExchangeOnlineManagement
$AuditLogSearch = Get-AdminAuditLogConfig | Select-Object AdminAuditLogEnabled, UnifiedAuditLogIngestionEnabled
if ($AuditLogSearch.AdminAuditLogEnabled -and $AuditLogSearch.UnifiedAuditLogIngestionEnabled -match 'True'){
return $AuditLogSearch
}
return $null
}
return Audit-AuditLogSearch
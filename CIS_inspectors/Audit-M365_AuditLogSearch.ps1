function Audit-AuditLogSearch{
Import-Module ExchangeOnlineManagement
$AuditLogSearchData = @()
$AuditLogSearch = Get-AdminAuditLogConfig | Select-Object AdminAuditLogEnabled, UnifiedAuditLogIngestionEnabled
if ($AuditLogSearch.AdminAuditLogEnabled -and $AuditLogSearch.UnifiedAuditLogIngestionEnabled -match 'True'){
foreach ($AuditLogSearchDataObj in $AuditLogSearch){
$AuditLogSearchData += "$($AuditLogSearch.AdminAuditLogEnabled), $($AuditLogSearch.UnifiedAuditLogIngestionEnabled)"}
return $AuditLogSearchData
}
return $null
}
return Audit-AuditLogSearch
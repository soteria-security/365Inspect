$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-AuditLogSearch{
try{
Import-Module ExchangeOnlineManagement
$AuditLogSearchData = @()
$AuditLogSearch = Get-AdminAuditLogConfig | Select-Object AdminAuditLogEnabled, UnifiedAuditLogIngestionEnabled
if ($AuditLogSearch.AdminAuditLogEnabled -and $AuditLogSearch.UnifiedAuditLogIngestionEnabled -match 'True'){
foreach ($AuditLogSearchDataObj in $AuditLogSearch){
$AuditLogSearchData += "$($AuditLogSearch.AdminAuditLogEnabled), $($AuditLogSearch.UnifiedAuditLogIngestionEnabled)"}
return $AuditLogSearchData
}
return $null
}Catch{
Write-Warning "Error message: $_"
$message = $_.ToString()
$exception = $_.Exception
$strace = $_.ScriptStackTrace
$failingline = $_.InvocationInfo.Line
$positionmsg = $_.InvocationInfo.PositionMessage
$pscommandpath = $_.InvocationInfo.PSCommandPath
$failinglinenumber = $_.InvocationInfo.ScriptLineNumber
$scriptname = $_.InvocationInfo.ScriptName
Write-Verbose "Write to log"
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
Write-Verbose "Errors written to log"
}
}
return Audit-AuditLogSearch
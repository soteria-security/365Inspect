function Audit-MailboxAudit{
$MailboxAuditData = @()
$MailboxAudit1 = Get-OrganizationConfig | select AuditDisabled
$MailboxAudit2 = Get-mailbox | Where AuditEnabled
if ($MailboxAudit1 -or $MailboxAudit2 -ne $null){
if ($MailboxAudit1.AuditDisabled -match 'True'){
$MailboxAuditData += 'AuditDisabled: '+$MailboxAudit1.AuditDisabled }
if ($MailboxAudit2.AuditEnabled -match 'False'){
$MailboxAuditData += '`n` AuditEnabled: '+$MailboxAudit2.AuditEnabled }
return $MailboxAuditData
}
return $null
}
return Audit-MailboxAudit

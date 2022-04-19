function Audit-MailboxAudit{
$MailboxAudit = ''
$MailboxAudit1 = Get-OrganizationConfig | select AuditDisabled
$MailboxAudit2 = Get-mailbox | Where AuditEnabled
if ($MailboxAudit1 -or $MailboxAudit2 -ne $null){
if ($MailboxAudit1.AuditDisabled -match 'True'){
$MailboxAudit += $MailboxAudit1 }
if ($MailboxAudit2.AuditEnabled -match 'False'){
$MailboxAudit += "`n"+$MailboxAudit2}
return $MailboxAudit
}
return $null
}
return Audit-MailboxAudit

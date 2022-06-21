$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-MailboxAudit{
try{
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
}catch{
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
return Audit-MailboxAudit

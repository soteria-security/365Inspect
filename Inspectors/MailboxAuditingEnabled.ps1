$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-MailboxAuditingEnabled {
Try {

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
Catch {
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

return Inspect-MailboxAuditingEnabled



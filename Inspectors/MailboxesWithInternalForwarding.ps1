$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Get-InternalMailboxForwarding{
Try {

    $mailboxes = Get-Mailbox -ResultSize Unlimited

    $knownDomains = (Get-MgDomain).Id

    $rulesEnabled = @()

    foreach ($mailbox in $mailboxes){
        $rulesEnabled += Get-InboxRule -Mailbox $mailbox.UserPrincipalName | Where-Object {($null -ne $_.ForwardTo) -or ($null -ne $_.ForwardAsAttachmentTo) -or ($null -ne $_.RedirectTo)} | Select-Object MailboxOwnerId, RuleIdentity, Name, ForwardTo, RedirectTo
    }
    if ($rulesEnabled.Count -gt 0) {
        foreach ($domain in $knownDomains){
            $rulesEnabled | Where-Object {($_.ForwardTo -match "EX:/o=") -or ($_.ForwardAsAttachmentTo -match "EX:/o=") -or ($_.RedirectTo -match "EX:/o=")} | Out-File -FilePath "$($path)\ExchangeMailboxeswithInternalForwardingRules.txt" -Append
            Return $rulesenabled.MailboxOwnerID | Select-Object -Unique
        }
    }
    Return $null

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

Get-InternalMailboxForwarding



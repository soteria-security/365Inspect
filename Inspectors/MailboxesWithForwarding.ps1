$path = @($out_path)

Function Get-MailboxForwarding{
    $mailboxes = Get-Mailbox -ResultSize Unlimited
    
    $rulesEnabled = @()

    foreach ($mailbox in $mailboxes){
        $rulesEnabled += Get-InboxRule -Mailbox $mailbox.UserPrincipalName | Where-Object {($null -ne $_.ForwardTo) -or ($null -ne $_.ForwardAsAttachmentTo) -or ($null -ne $_.RedirectTo)} | Select-Object MailboxOwnerId, RuleIdentity, Name, ForwardTo, RedirectTo
    }
    if ($rulesEnabled.Count -gt 0) {
        $rulesEnabled | Out-File -FilePath "$($path)\ExchangeMailboxeswithForwardingRules.txt" -Append
        Return $rulesenabled.MailboxOwnerID
    }
    Return $null
}

Get-MailboxForwarding


Function Get-MailboxForwarding{
    $mailboxes = Get-EXOMailbox -Filter {(DeliverToMailboxAndForward -ne $false) -or (ForwardingAddress -ne $null) -or (ForwardingSmtpAddress -ne $null)} -ResultSize Unlimited
    $i = 0
    if ($mailboxes.count -gt 0){
        foreach ($mailbox in $mailboxes){
            $mailbox | Select-Object displayname, windowsemailaddress, delivertomailboxandforward, forwardingaddress, forwardingsmtpaddress | Export-Csv "$(Get-Date -Format yyyy-MM-dd)_Mailboxes_with_forwarding.csv" -NoTypeInformation -Append
            $i++ 
            Write-Progress -Activity "Searching Mailboxes" -PercentComplete ($i/$mailboxes.count*100)
        }
    Return $mailboxes.alias
    }
}

Get-MailboxForwarding
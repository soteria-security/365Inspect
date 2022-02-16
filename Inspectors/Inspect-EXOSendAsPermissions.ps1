$path = @($out_path)

Function Inspect-EXOSendAsPermissions{
    
    $sendAs = Get-Mailbox -ResultSize Unlimited | Get-RecipientPermission | Where-Object {($_.Trustee -ne 'NT AUTHORITY\SELF') -and ($_.AccessControlType -eq "Allow")}

    if ($sendAs.Count -gt 0) {
        $sendAs | Out-File -FilePath "$($path)\EXOSendAsPermissions.txt" -Append
        Return $sendAs.Identity
    }
    Return $null
}

Inspect-EXOSendAsPermissions
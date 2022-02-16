$path = @($out_path)

Function Inspect-EXOSendOnBehalfOf{
    
    $GrantSendOnBehalfTo = Get-Mailbox -ResultSize Unlimited | Where-Object {$_.GrantSendOnBehalfTo -like "*"}

    if ($GrantSendOnBehalfTo.Count -gt 0) {
        $GrantSendOnBehalfTo | Select-Object Identity, GrantSendOnBehalfTo | Out-File -FilePath "$($path)\EXOGrantSendOnBehalfToPermissions.txt" -Append
        Return $GrantSendOnBehalfTo.Identity
    }
    Return $null
}

Inspect-EXOSendOnBehalfOf
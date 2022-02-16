$path = @($out_path)

Function Inspect-EXOFullAccess{
    
    $fullAccess = Get-Mailbox -ResultSize Unlimited | Where-Object {($_.User -ne 'NT AUTHORITY\SELF') -and ($_.AccessRights -eq 'FullAccess')}

    if ($fullAccess.Count -gt 0) {
        $fullAccess | Out-File -FilePath "$($path)\EXOFullAccessPermissions.txt" -Append
        Return $fullAccess.Identity
    }
    Return $null
}

Inspect-EXOFullAccess
$path = @($out_path)

Function Inspect-EmailVerifiedUserCreation {
    $emailVerifiedUsers = Get-AzureADUser -All:$true | Where-Object {$_.CreationType -eq "EmailVerified"}

    $results = @()

    $emailVerifiedUsers | Select-Object AccountEnabled,DisplayName,ShowInAddressList,UserPrincipalName,OtherMails | Format-Table -AutoSize | Out-File "$path\EmailVerifiedUserCreation.txt" 

    foreach ($account in $emailVerifiedUsers){
        $results += $account.UserPrincipalName
    }

    Return $results
}

Return Inspect-EmailVerifiedUserCreation
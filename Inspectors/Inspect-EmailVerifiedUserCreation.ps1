$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-EmailVerifiedUserCreation {
Try {

    $emailVerifiedUsers = Get-MgUser -All:$true | Where-Object {$_.CreationType -eq "EmailVerified"}

    $results = @()

    $emailVerifiedUsers | Select-Object AccountEnabled,DisplayName,ShowInAddressList,UserPrincipalName,OtherMails | Format-Table -AutoSize | Out-File "$path\EmailVerifiedUserCreation.txt" 

    foreach ($account in $emailVerifiedUsers){
        $results += $account.UserPrincipalName
    }

    Return $results

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

Return Inspect-EmailVerifiedUserCreation



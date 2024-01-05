$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-EmailVerifiedUserCreation {
    Try {

        $emailVerifiedUsers = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/users?filter=creationtype eq 'EmailVerified'" -ErrorAction Stop).Value

        $results = @()

        If (($emailVerifiedUsers | Measure-Object).Count -gt 0) {
            $emailVerifiedUsers | Select-Object AccountEnabled, DisplayName, ShowInAddressList, UserPrincipalName, OtherMails | Format-Table -AutoSize | Out-File "$path\EmailVerifiedUserCreation.txt" 
        }

        foreach ($account in $emailVerifiedUsers) {
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
        Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $strace
        Write-Verbose "Errors written to log"
    }
}

Return Inspect-EmailVerifiedUserCreation
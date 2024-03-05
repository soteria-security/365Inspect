$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SSPRAllowsEmailAuth {
    Try {

        $emailPolicy = (Get-MgPolicyAuthenticationMethodPolicy).AuthenticationMethodConfigurations | Where-Object Id -eq "email"

        if ($emailPolicy.State -eq "disabled") {
            Return $null
        }

        $users = Get-MgReportAuthenticationMethodUserRegistrationDetail | Where-Object MethodsRegistered -eq "email"

        $results = @()

        Foreach ($result in $users){
            $results += "User: $($result.UserDisplayName), UserPrincipalName: $($result.UserPrincipalName), IsAdmin: $($user.IsAdmin)"
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

return Inspect-SSPRAllowsEmailAuth
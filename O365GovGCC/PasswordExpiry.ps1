$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-PasswordExpiry {
    Try {
        $pass_expiry = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/v1.0/domains").Value

        $expPolicies = @()
	
        If (-NOT ($pass_expiry.PasswordValidityPeriodInDays -eq 2147483647)) {
            Foreach ($x in $pass_expiry) {
                If ($null -ne $x.PasswordValidityPeriodInDays) {
                    $expPolicies += "$($x.Id) password expiration in days: $($x.PasswordValidityPeriodInDays)"
                }
            }
        }

        if ($null -ne $expPolicies) {
            return $expPolicies
        }
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

return Inspect-PasswordExpiry
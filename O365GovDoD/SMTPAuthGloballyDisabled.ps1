$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SMTPAuthGloballyDisabled {
    Try {
        # Query Security defaults to see if it's enabled. If it is, skip this check.
        $secureDefault = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/policies/identitySecurityDefaultsEnforcementPolicy")
        If ($secureDefault.IsEnabled -eq $false) {
            If (Get-TransportConfig | Where-Object { !$_.SmtpClientAuthenticationDisabled }) {
                return "SmtpClientAuthenticationDisabled: $((Get-TransportConfig).SmtpClientAuthenticationDisabled)"
            }
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

return Inspect-SMTPAuthGloballyDisabled
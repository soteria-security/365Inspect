$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-ThirdPartyIntegratedAppPermission {
    Try {
        $adminConsent = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/policies/adminConsentRequestPolicy" -ErrorAction Stop)

        If ($adminConsent.IsEnabled -eq $false) {
            $permissions = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/policies/authorizationPolicy").Value.defaultUserRolePermissions

            If ($permissions.AllowedToCreateApps -eq $true) {
                return $permissions.AllowedToCreateApps
            }
        }
        Else {
            Return "Admin Consent Workflow is enabled."
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

return Inspect-ThirdPartyIntegratedAppPermission
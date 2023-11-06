$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-MailboxesWithSMTPEnabled {
    Try {
        # Query Security defaults to see if it's enabled. If it is, skip this check.
        $secureDefault = ((Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/policies/identitySecurityDefaultsEnforcementPolicy"))

        If ($secureDefault.IsEnabled -eq $false) {
            $conditionalAccess = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/v1.0/policies/conditionalAccessPolicies").Value

            $blockingPolicies = @()

            foreach ($policy in $conditionalAccess) {
                if (($policy.State -like 'enabled') -and ($policy.grantcontrols.builtincontrols -like 'block') -and (($policy.conditions.clientAppTypes -contains "other") -or ($policy.conditions.clientAppTypes -contains "exchangeActiveSync")) -and (($policy.conditions.applications.IncludeApplications -like 'All') -or ($policy.conditions.applications.IncludeApplications -like 'Office365') -or ($policy.conditions.applications.IncludeApplications -eq '00000002-0000-0ff1-ce00-000000000000'))) {
                    $blockingPolicies += $policy.DisplayName
                }
            }

            If (($blockingPolicies | measure-object).count -eq 0) {
                $smtp = (Get-CasMailbox -ResultSize Unlimited | Where-Object { !$_.SmtpClientAuthenticationDisabled }).Name
            }
        }
        
        If ($smtp.Count -NE 0) {
            return $non_smtp
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

return Inspect-MailboxesWithSMTPEnabled
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-MailboxesWithIMAPEnabled {
    Try {
        # Query Security defaults to see if it's enabled. If it is, skip this check.
        $secureDefault = ((Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/beta/policies/identitySecurityDefaultsEnforcementPolicy"))

        If ($secureDefault.IsEnabled -eq $false) {
            $conditionalAccess = (Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/v1.0/policies/conditionalAccessPolicies").Value

            $blockingPolicies = @()

            foreach ($policy in $conditionalAccess) {
                if (($policy.State -like 'enabled') -and ($policy.grantcontrols.builtincontrols -like 'Block') -and (($policy.conditions.applications.IncludeApplications -like 'All') -or ($policy.conditions.applications.IncludeApplications -like 'Office365') -or ($policy.conditions.applications.IncludeApplications -eq '00000002-0000-0ff1-ce00-000000000000'))) {
                    $blockingPolicies += $policy.DisplayName
                }
            }

            If (($blockingPolicies | measure-object).count -eq 0) {
                $IMPAEnabled = (Get-CasMailbox -ResultSize Unlimited | Where-Object { $_.ImapEnabled }).Name
            }
        }

        Return $IMPAEnabled
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

return Inspect-MailboxesWithIMAPEnabled
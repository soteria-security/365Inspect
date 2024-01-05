$ErrorActionPreference = "Stop"

# Import error log function
$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Inspect-NoMFA {
    Try {
        # Query Security defaults to see if it's enabled. If it is, skip this check.
        $unenforced_users = @()

        $secureDefault = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/policies/identitySecurityDefaultsEnforcementPolicy")
        $tenantLicense = ((Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/subscribedSkus").Value).ServicePlans
    
        If ($tenantLicense.ServicePlanName -match "AAD_PREMIUM*") {
            $MFAviaCA = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/policies/conditionalAccessPolicies").Value | Where-Object { ($_.state -eq "Enabled") -and ($_.conditions.users.includeusers -eq "All") -and ($_.grantcontrols.builtincontrols -eq "Mfa") }
            
            If (($secureDefault.IsEnabled -eq $false) -and (-NOT $MFAviaCA)) {
                $unenforced_users += (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/reports/credentialUserRegistrationDetails").Value | Where-Object { $_.isMfaRegistered -eq $false }
            }

            
            If (($unenforced_users | Measure-Object).Count -NE 0) {
                return $unenforced_users.UserPrincipalName
            }
        }
        ElseIf (($secureDefault.IsEnabled -eq $false) -and ($tenantLicense.ServicePlanName -notmatch "AAD_PREMIUM")) {
            Return "Secure Defaults is not enabled, and the tenant is not licensed to query this information."
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

return Inspect-NoMFA
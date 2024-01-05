$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling



$path = "$($env:USERPROFILE)\Documents\Reports\365Inspect_Report_$(Get-Date -Format yyyy-MM-dd)"

function Inspect-CAPolicies_registersecurityinfo {
    Try {

        $tenantLicense = ((Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/subscribedSkus").Value).ServicePlans
    
        If ($tenantLicense.ServicePlanName -match "AAD_PREMIUM*") {
        
            $secureDefault = ((Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/policies/identitySecurityDefaultsEnforcementPolicy").Value)
        
            $conditionalAccess = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/policies/conditionalAccessPolicies").Value

            If ($secureDefault.IsEnabled -eq $true) {
            
            }
            ElseIf (($secureDefault.IsEnabled -eq $false) -and ($conditionalAccess.count -eq 0)) {
                return $false
            }
            else {
                $totalCount = ($conditionalAccess | Measure-Object).Count
                $noAction = 0

                $disabledPolicies = @()

                Foreach ($policy in $conditionalAccess) {
                    $actions = $policy.conditions.applications.includeUserActions
                    If ($actions -ne 'urn:user:registersecurityinfo') {
                        $noAction += 1
                    }
                    Elseif (($actions -eq 'urn:user:registersecurityinfo') -and ($policy.State -ne 'enabled')) {
                        $disabledPolicies += "$($policy.DisplayName) is not enabled."
                    }
                }

                If ($noAction -eq $totalCount) {
                    Return "No policies require MFA for registering User Security Information."
                }
                If ($disabledPolicies) {
                    Return $disabledPolicies
                }
            }
        }
        Else {
            Return $null
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

return Inspect-CAPolicies_registersecurityinfo
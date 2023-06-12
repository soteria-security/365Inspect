$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling



$path = "$($env:USERPROFILE)\Documents\Reports\365Inspect_Report_$(Get-Date -Format yyyy-MM-dd)"

function Inspect-CAPolicies_userrisk {
    Try {

        $tenantLicense = ((Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/subscribedSkus").Value).ServicePlans
    
        If ($tenantLicense.ServicePlanName -match "AAD_PREMIUM*") {
        
            $secureDefault = ((Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/policies/identitySecurityDefaultsEnforcementPolicy").Value)
        
            $conditionalAccess = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/policies/conditionalAccessPolicies").Value

            If ($secureDefault.IsEnabled -eq $true) {
            
            }
            ElseIf (($secureDefault.IsEnabled -eq $false) -and ($conditionalAccess.count -eq 0)) {
                return $false
            }
            else {
                $policies = ((Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/policies/conditionalAccessPolicies").Value | Where-Object { ($null -ne $_.conditions.userRiskLevels) -and (($_.conditions.userRiskLevels -eq 'high') -or ($_.conditions.userRiskLevels -eq 'medium')) })

                If (($policies | Measure-Object).Count -gt 0) {
                    $results = @()
                    $disabledPolicies = @()

                    Foreach ($policy in $policies) {

                        $result = [PSCustomObject]@{
                            Name            = $policy.DisplayName
                            State           = $policy.State
                            GrantConditions = $policy.grantcontrols.builtincontrols
                            UserRisk        = $policy.conditions.userRiskLevels
                        }
                        
                        # Enabled Policies
                        If (($result.UserRisk -contains 'high') -and ($result.GrantConditions -ne 'block')) {
                            $results += "$($result.Name) does not block sign-in for users with high risk."
                        }
                        If (($result.UserRisk -contains 'medium') -and ($result.GrantConditions -ne 'block')) {
                            $results += "$($result.Name) does not block sign-in for users with medium risk."
                        }
                        If (($result.UserRisk -contains 'high') -and ($result.GrantConditions -ne 'passwordChange')) {
                            $results += "$($result.Name) does not require a password change for users with high risk."
                        }
                        If (($result.UserRisk -contains 'medium') -and ($result.GrantConditions -ne 'passwordChange')) {
                            $results += "$($result.Name) does not require a password change for users with medium risk."
                        }

                        # Disabled Policies
                        If (($result.UserRisk -contains 'high') -and ($result.GrantConditions -eq 'block') -and ($result.State -ne 'enabled')) {
                            $results += "Policy $($result.Name) that blocks sign-in for users with high risk is not enabled."
                        }
                        If (($result.UserRisk -contains 'medium') -and ($result.GrantConditions -eq 'block') -and ($result.State -ne 'enabled')) {
                            $results += "Policy $($result.Name) that blocks sign-in for users with medium risk is not enabled."
                        }
                        If (($result.UserRisk -contains 'high') -and ($result.GrantConditions -eq 'passwordChange') -and ($result.State -ne 'enabled')) {
                            $results += "Policy $($result.Name) that requires a password change for users with high risk is not enabled."
                        }
                        If (($result.UserRisk -contains 'medium') -and ($result.GrantConditions -eq 'passwordChange') -and ($result.State -ne 'enabled')) {
                            $results += "Policy $($result.Name) that requires a password change for users with medium risk is not enabled."
                        }
                    }

                    If ($results -and (!$disabledPolicies)) {
                        Return $results
                    }
                    If ((! $results) -and ($disabledPolicies)) {
                        Return $disabledPolicies
                    }
                    Else {
                        $both = @($results, $disabledPolicies)
                        Return $both
                    }
                }
                Else {
                    Return "No policies exist to control user sign-in with a risk level of medium or higher"
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

return Inspect-CAPolicies_userrisk
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Inspector-CAPolicies_legacyauth {
    Try {
        $subscriptions = (Get-MgSubscribedSku).ServicePlans | where ServicePlanName -match "AAD_PREMIUM*"
        If ($subscriptions.Length > 0) {
        
            $secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy
        
            $conditionalAccess = Get-MgIdentityConditionalAccessPolicy -CountVariable "capCount"
            If ($secureDefault.IsEnabled) {
                return $null
            } ElseIf ($capCount -eq 0) {
                return "No policies exist that address legacy authentication."
            } Else {
                $results = @()

                Foreach ($policy in $conditionalAccess) {

                    If (($null -ne $policy.Conditions.ClientAppTypes) -and 
                        (($policy.Conditions.ClientAppTypes).Count -eq 2) -and
                        ($policy.Conditions.ClientAppTypes -contains "other") -and
                        ($policy.Conditions.ClientAppTypes -contains "exchangeActiveSync")) {
                        
                        $result = [PSCustomObject]@{
                            Name              = $policy.DisplayName
                            State             = $policy.State
                            ClientAppTypes    = $policy.Conditions.ClientAppTypes
                            GrantConditions   = $policy.GrantControls.BuiltInControls
                        }
                        #Non-Blocking Policies
                        If ($result.State -eq "enabled" -and $result.GrantConditions -ne "block") {
                            $results += "Policy $($result.Name) that has conditions for legacy authentication does not block."
                        }

                        #Disabled Policies
                        If ($result.State -ne "enabled" -and $result.GrantConditions -eq "block") {
                            $results += "Policy $($result.Name) that blocks legacy authentication is not enabled."
                        }

                        #If a policy that addresses legacy authentication is found, return null
                        If ($result.State -eq "enabled" -and $result.GrantConditions -eq "block") {
                            return $null
                        }
                    }
                }
                If ($results.Count -eq 0) {
                    return "No policies exist that address legacy authentication."
                } Else {
                    Return $results
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
        Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
        Write-Verbose "Errors written to log"
    }
}

return Inspector-CAPolicies_legacyauth
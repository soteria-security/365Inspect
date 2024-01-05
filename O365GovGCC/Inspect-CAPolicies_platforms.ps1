$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = "$($env:USERPROFILE)\Documents\Reports\365Inspect_Report_$(Get-Date -Format yyyy-MM-dd)"

function Inspect-CAPolicies_platforms {
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
                $results = @()

                Foreach ($policy in $conditionalAccess) {

                    $platforms = @("android", "iOS", "windows", "windowsPhone", "macOS", "linux")

                    If (($null -ne $policy.conditions.platforms) -and ((($policy.conditions.platforms.includePlatforms).Count -ge 1) -or (($policy.conditions.platforms.excludePlatforms).count -ge 1))) {
                        $result = [PSCustomObject]@{
                            Name              = $policy.DisplayName
                            State             = $policy.State
                            IncludedPlatforms = $policy.conditions.platforms.includeplatforms
                            ExcludedPlatforms = $policy.conditions.platforms.excludeplatforms
                            GrantConditions   = $policy.grantcontrols.builtincontrols
                        }
                        
                        If (($result.IncludedPlatforms -ne 'all') -and (($result.IncludedPlatforms | Measure-Object).Count -ne ($platforms).Count)) {
                            foreach ($platform in $platforms) {
                                If ($result.IncludedPlatforms -notcontains $platform) {
                                    $results += "Policy $($result.Name) does not target $platform devices."
                                }
                                If ($result.ExcludedPlatforms -contains $platform) {
                                    $results += "Policy $($result.Name) explicitly excludes $platform devices."
                                }
                            }
                        }
                    }
                }
                Return $results
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

return Inspect-CAPolicies_platforms
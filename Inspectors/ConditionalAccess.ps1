$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

function Inspect-CAPolicies {
    Try {
        $tenantLicense = ((Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/beta/subscribedSkus").Value).ServicePlans
    
        If ($tenantLicense.ServicePlanName -match "AAD_PREMIUM*") {
            
            $secureDefault = ((Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/beta/policies/identitySecurityDefaultsEnforcementPolicy").Value)
            
            $conditionalAccess = (Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/v1.0/policies/conditionalAccessPolicies").Value

            If ($secureDefault.IsEnabled -eq $true) {
                
            }
            ElseIf (($secureDefault.IsEnabled -eq $false) -and ($conditionalAccess.count -eq 0)) {
                return $false
            }
            else {
                $path = New-Item -ItemType Directory -Force -Path "$($path)\ConditionalAccess"
                
                Foreach ($policy in $conditionalAccess) {

                    $name = $policy.DisplayName

                    $pattern = '[\\\[\]\{\}/():;\*\"#<>\$&+!`|=\?@\s'']'

                    $name = $name -replace $pattern, '-'

                    $IncludedUsers = @()

                    $ExcludedUsers = @()

                    $IncludedGroups = @()

                    $ExcludedGroups = @()

                    $IncludedRoles = @()

                    $ExcludedRoles = @()

                    If ($policy.conditions.users.includeusers -eq "All") {
                        $IncludedUsers = "All"
                    }
                    Elseif ($policy.conditions.users.includeusers -eq "None") {
                        $IncludedUsers = "None"
                    }
                    Elseif ($policy.conditions.users.includeusers -eq "GuestsOrExternalUsers") {
                        $IncludedUsers = "GuestsOrExternalUsers"
                    }
                    Elseif ($policy.conditions.users.includeusers) {
                        $IncludedUsers = @()
                        Foreach ($user in $policy.conditions.users.includeusers) {
                            $IncludedUsers += (Invoke-GraphRequest -Method Get -Uri "https://$(@($global:graphURI))/beta/directoryObjects/$user").DisplayName
                        }
                    }
                    
                    If ($policy.conditions.users.excludeusers -eq "All") {
                        $ExcludedUsers = "All"
                    }
                    Elseif ($policy.conditions.users.excludeusers -eq "None") {
                        $ExcludedUsers = "None"
                    }
                    Elseif ($policy.conditions.users.excludeusers -eq "GuestsOrExternalUsers") {
                        $ExcludedUsers = "GuestsOrExternalUsers"
                    }
                    Elseif ($policy.conditions.users.excludeusers) {
                        $ExcludedUsers = @()
                        Foreach ($user in $policy.conditions.users.excludeusers) {
                            $ExcludedUsers += (Invoke-GraphRequest -Method Get -Uri "https://$(@($global:graphURI))/beta/directoryObjects/$user").DisplayName
                        }
                    }
                    
                    If ($policy.conditions.users.includegroups -eq "All") {
                        $IncludedGroups = "All"
                    }
                    Elseif ($policy.conditions.users.includegroups) {
                        $IncludedGroups = @()
                        Foreach ($group in $policy.conditions.users.includegroups) {
                            $IncludedGroups += (Invoke-GraphRequest -Method Get -Uri "https://$(@($global:graphURI))/beta/directoryObjects/$group").DisplayName
                        }
                    }
                    
                    If ($policy.conditions.users.excludegroups -eq "All") {
                        $ExcludedGroups = "All"
                    }
                    Elseif ($policy.conditions.users.excludegroups) {
                        $ExcludedGroups = @()
                        Foreach ($group in $policy.conditions.users.excludegroups) {
                            $ExcludedGroups += (Invoke-GraphRequest -Method Get -Uri "https://$(@($global:graphURI))/beta/directoryObjects/$group").DisplayName
                        }
                    }
                    
                    If ($policy.conditions.users.includeroles -eq "All") {
                        $IncludedRoles = "All"
                    }
                    Elseif ($policy.conditions.users.includeroles) {
                        $IncludedRoles = @()
                        Foreach ($role in $policy.conditions.users.includeroles) {
                            $IncludedRoles += (Invoke-GraphRequest -Method Get -Uri "https://$(@($global:graphURI))/beta/directoryObjects/$role").DisplayName
                        }
                    }
                    
                    If ($policy.conditions.users.excluderoles -eq "All") {
                        $ExcludedRoles = "All"
                    }
                    Elseif ($policy.conditions.users.excluderoles) {
                        $ExcludedRoles = @()
                        Foreach ($role in $policy.conditions.users.excluderoles) {
                            $ExcludedRoles += (Invoke-GraphRequest -Method Get -Uri "https://$(@($global:graphURI))/beta/directoryObjects/$role").DisplayName
                        }
                    }

                    $sessionControls = $policy.sessioncontrols

                    $result = [PSCustomObject]@{
                        Name                     = $policy.DisplayName
                        State                    = $policy.State
                        IncludedApps             = $policy.conditions.applications.includeapplications
                        ExcludedApps             = $policy.conditions.applications.excludeapplications
                        IncludedUserActions      = $policy.conditions.includeuseractions
                        IncludedProtectionLevels = $policy.conditions.includeprotectionlevels
                        IncludedUsers            = $IncludedUsers
                        ExcludedUsers            = $ExcludedUsers
                        IncludedGroups           = $IncludedGroups
                        ExcludedGroups           = $ExcludedGroups
                        IncludedRoles            = $IncludedRoles
                        ExcludedRoles            = $ExcludedRoles
                        IncludedPlatforms        = $policy.conditions.platforms.includeplatforms
                        ExcludedPlatforms        = $policy.conditions.platforms.excludeplatforms
                        IncludedLocations        = $policy.conditions.locations.includelocations
                        ExcludedLocations        = $policy.conditions.locations.excludelocations
                        IncludedSignInRisk       = $policy.conditions.SignInRiskLevels
                        ClientAppTypes           = $policy.conditions.ClientAppTypes
                        GrantConditions          = $policy.grantcontrols.builtincontrols
                        ApplicationRestrictions  = $sessioncontrols.ApplicationEnforcedRestrictions
                        CloudAppSecurity         = $sessioncontrols.CloudAppSecurity
                        SessionLifetime          = $sessioncontrols.signinfrequency
                        PersistentBrowser        = $sessioncontrols.PersistentBrowser
                    }
                
                    $result | ConvertTo-Json -Depth 100 | Out-File -FilePath "$($path)\$($name)_Policy.json"
                }
            }
        }
        Else {
            Return "Tenant is not licensed for Conditional Access."
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

return Inspect-CAPolicies
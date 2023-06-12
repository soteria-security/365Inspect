$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

function Inspect-CAPolicies {
    Try {
        $tenantLicense = (Get-MgSubscribedSku)
    
        If (($tenantLicense.ServicePlans.ServicePlanName -match "AAD_PREMIUM*")) {
        
            $secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
            $conditionalAccess = Get-MgIdentityConditionalAccessPolicy

            If ($secureDefault.IsEnabled -eq $true) {
            
            }
            ElseIf (($secureDefault.IsEnabled -eq $false) -and ($conditionalAccess.count -eq 0)) {
                return $false
            }
            else {
                $path = New-Item -ItemType Directory -Force -Path "$($path)\ConditionalAccess"
            
                Foreach ($policy in $conditionalAccess) {

                    $name = $policy.displayName

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
                        Foreach ($id in ($policy.conditions.users.includeusers)) {
                            If ($id -eq "GuestsOrExternalUsers") {
                                $IncludedUsers += "GuestsOrExternalUsers"
                            }
                            Else {
                                $IncludedUsers += (Get-MgDirectoryObject -DirectoryObjectId $id).AdditionalProperties.displayName -join ', '
                            }
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
                        Foreach ($id in ($policy.conditions.users.excludeusers)) {
                            If ($id -eq "GuestsOrExternalUsers") {
                                $ExcludedUsers += "GuestsOrExternalUsers"
                            }
                            Else {
                                $ExcludedUsers += (Get-MgDirectoryObject -DirectoryObjectId $id).AdditionalProperties.displayName -join ', '
                            }
                        }
                    }
                
                    If ($policy.conditions.users.includegroups -eq "All") {
                        $IncludedGroups = "All"
                    }
                    Elseif ($policy.conditions.users.includegroups) {
                        $IncludedGroups = @()
                        Foreach ($id in ($policy.conditions.users.includegroups)) {
                            $IncludedGroups += (Get-MgDirectoryObject -DirectoryObjectId $id).AdditionalProperties.displayName -join ', '
                        }
                    }
                
                    If ($policy.conditions.users.excludegroups -eq "All") {
                        $ExcludedGroups = "All"
                    }
                    Elseif ($policy.conditions.users.excludegroups) {
                        $ExcludedGroups = @()
                        foreach ($id in ($policy.conditions.users.excludegroups)) {
                            $ExcludedGroups += (Get-MgDirectoryObject -DirectoryObjectId $id).AdditionalProperties.displayName -join ', '
                        }
                    }
                
                    If ($policy.conditions.users.includeroles -eq "All") {
                        $IncludedRoles = "All"
                    }
                    Elseif ($policy.conditions.users.includeroles) {
                        $IncludedRoles = @()
                        foreach ($id in ($policy.conditions.users.includeroles)) {
                            $IncludedRoles += (Get-MgDirectoryObject -DirectoryObjectId $id).AdditionalProperties.displayName -join ', '
                        }
                    }
                
                    If ($policy.conditions.users.excluderoles -eq "All") {
                        $ExcludedRoles = "All"
                    }
                    Elseif ($policy.conditions.users.excluderoles) {
                        $ExcludedRoles = @()
                        foreach ($id in ($policy.conditions.users.excluderoles)) {
                            $ExcludedRoles += (Get-MgDirectoryObject -DirectoryObjectId $id).AdditionalProperties.displayName -join ', '
                        }
                    }

                    $sessionControls = $policy.sessioncontrols

                    $result = [PSCustomObject]@{
                        Name                       = $policy.DisplayName
                        State                      = $policy.State
                        IncludedApps               = $policy.conditions.applications.includeapplications
                        ExcludedApps               = $policy.conditions.applications.excludeapplications
                        IncludedUserActions        = $policy.conditions.includeuseractions
                        IncludedProtectionLevels   = $policy.conditions.includeprotectionlevels
                        IncludedUsers              = $IncludedUsers
                        ExcludedUsers              = $ExcludedUsers
                        IncludedGroups             = $IncludedGroups
                        ExcludedGroups             = $ExcludedGroups
                        IncludedRoles              = $IncludedRoles
                        ExcludedRoles              = $ExcludedRoles
                        IncludedPlatforms          = $policy.conditions.platforms.includeplatforms
                        ExcludedPlatforms          = $policy.conditions.platforms.excludeplatforms
                        IncludedLocations          = $policy.conditions.locations.includelocations
                        ExcludedLocations          = $policy.conditions.locations.excludelocations
                        IncludedSignInRisk         = $policy.conditions.SignInRiskLevels
                        ClientAppTypes             = $policy.conditions.ClientAppTypes
                        GrantConditions            = $policy.grantcontrols.builtincontrols
                        ApplicationRestrictions    = $sessioncontrols.ApplicationEnforcedRestrictions
                        DisableResilienceDefaults  = $sessioncontrols.disableResilienceDefaults
                        ContinuousAccessEvaluation = $sessioncontrols.continuousAccessEvaluation
                        CloudAppSecurity           = $sessioncontrols.CloudAppSecurity
                        SessionLifetime            = $sessioncontrols.signinfrequency
                        PersistentBrowser          = $sessioncontrols.PersistentBrowser.mode
                        TokenProtection            = $sessionControls.secureSignInSession
                        UserRisk                   = $policy.conditions.userRiskLevels
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
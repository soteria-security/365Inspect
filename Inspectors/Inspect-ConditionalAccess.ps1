$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

# Resolves an ID referenced by a Conditional Access policy to a display name.
# - Roles in CA policies are role TEMPLATE / definition IDs, not directory object IDs,
#   so /directoryObjects/{id} returns 404 for them. Look them up as role definitions.
# - Users/groups that were deleted but are still referenced by a policy also return 404.
#   Report them instead of failing the whole inspector (a stale reference is worth seeing).
function Resolve-CAPrincipal {
    param (
        [Parameter(Mandatory)] [string] $Id,
        [Parameter(Mandatory)] [ValidateSet('User', 'Group', 'Role')] [string] $Kind
    )

    # Keywords CA uses in place of IDs
    If ($Id -in @('All', 'None', 'GuestsOrExternalUsers')) { return $Id }

    $base = "https://$(@($global:graphURI))"
    $uris = switch ($Kind) {
        'Role' {
            "$base/v1.0/directoryRoleTemplates/$Id",                  # built-in roles
            "$base/v1.0/roleManagement/directory/roleDefinitions/$Id" # custom roles
        }
        default { "$base/beta/directoryObjects/$Id" }
    }

    foreach ($uri in $uris) {
        Try {
            $obj = Invoke-GraphRequest -Method Get -Uri $uri -ErrorAction Stop
            If ($obj.displayName) { return $obj.displayName }
        }
        Catch {
            # 404: try the next lookup, or fall through to the not-found label
        }
    }

    return "$Id ($Kind not found: deleted or stale reference)"
}

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

                    $u = $policy.conditions.users
                    $IncludedUsers = @($u.includeUsers  | ForEach-Object { Resolve-CAPrincipal -Id $_ -Kind User })
                    $ExcludedUsers = @($u.excludeUsers  | ForEach-Object { Resolve-CAPrincipal -Id $_ -Kind User })
                    $IncludedGroups = @($u.includeGroups | ForEach-Object { Resolve-CAPrincipal -Id $_ -Kind Group })
                    $ExcludedGroups = @($u.excludeGroups | ForEach-Object { Resolve-CAPrincipal -Id $_ -Kind Group })
                    $IncludedRoles = @($u.includeRoles  | ForEach-Object { Resolve-CAPrincipal -Id $_ -Kind Role })
                    $ExcludedRoles = @($u.excludeRoles  | ForEach-Object { Resolve-CAPrincipal -Id $_ -Kind Role })

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
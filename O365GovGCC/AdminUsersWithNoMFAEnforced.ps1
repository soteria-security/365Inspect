$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-AdminUsersWithNoMFAEnforced {
    Try {
        $tenantLicense = ((Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/subscribedSkus").Value).ServicePlans
    
        If ($tenantLicense.ServicePlanName -match "AAD_PREMIUM*") {
            $adminRoleIds = @("62e90394-69f5-4237-9190-012177145e10", "194ae4cb-b126-40b2-bd5b-6091b380977d", "f28a1f50-f6e7-4571-818b-6a12f2af6b6c", "29232cdf-9323-42fd-ade2-1d097af3e4de", "b1be1c3e-b65d-4f19-8427-f6fa0d97feb9", "729827e3-9c14-49f7-bb1b-9608f156bbb8", "b0f54661-2d74-4c50-afa3-1ec803f12efe", "fe930be7-5e62-47db-91af-98c3a49a38b1", "c4e39bd9-1100-46d3-8c65-fb160da0071f", "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3", "158c047a-c907-4556-b7ef-446551a6b5f7", "966707d0-3269-4727-9be2-8c3a10f19b9d", "7be44c8a-adaf-4e2a-84d6-ab2649e08a13", "e8611ab8-c189-46e8-94e1-60213ab1f814")

            $secureDefault = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/policies/identitySecurityDefaultsEnforcementPolicy")
                
            $adminMFACAPolicies = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/policies/conditionalAccessPolicies").Value | Where-Object { ($_.state -eq "Enabled") -and ($_.conditions.users.includeroles) -and ($_.grantcontrols.builtincontrols -eq "Mfa") }
        
            $MFAviaCA = $false
        
            If ($adminMFACAPolicies) {
                $count = 0
                foreach ($id in $adminRoleIds) {
                    If ($adminMFACAPolicies.conditions.users.includeroles -contains $id) {
                        $count++
                    }
                }
        
                If ($count -eq ($adminRoleIds | Measure-Object).Count) {
                    $MFAviaCA = $true
                }
            } 
        
            If (($secureDefault.IsEnabled -eq $false) -and (-NOT $MFAviaCA)) {
                $adminRoles = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/directoryRoles").Value | Where-Object { $_.DisplayName -like "*Admin*" }
        
                $mfaReport = ((Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/reports/credentialUserRegistrationDetails").Value | Where-Object { $_.isMfaRegistered -eq $false }).userPrincipalName
        
                $results = @()
        
                ForEach ($role in $adminRoles) {
                    $roleMembers = @()
                    $roleMembers = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/roleManagement/directory/roleAssignments").Value 
        
                    $users = @()
        
                    If ($roleMembers.count -gt 0) {
                        Foreach ($member in $roleMembers) {
                            If ($member.roleDefinitionId -eq $role.roleTemplateId) {
                                $entity = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/directoryObjects/$($member.principalId)")
        
                                If ($entity.'@odata.type' -eq '#microsoft.graph.user') {
                                    $users += $entity.userPrincipalName
                                }
                                If ($entity.'@odata.type' -eq '#microsoft.graph.group') {
                                    $groupMembers = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/groups/$(($entity).Id)/members").Value
        
                                    foreach ($groupMember in $groupMembers) {
                                        $users += $groupMember.userPrincipalName
                                    }
                                }
                            }
                        }
                    }
        
                    foreach ($user in $Users) {
                        If ($mfaReport -contains $user) {
                            $results += $user + " in role " + $role.DisplayName + " not configured for MFA"
                        }
                    }
                }
        
                If ($results.Count -ne 0) {
                    Return $results | Sort-Object
                }
            }
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

return Inspect-AdminUsersWithNoMFAEnforced
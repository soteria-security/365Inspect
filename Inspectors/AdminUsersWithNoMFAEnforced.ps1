$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-AdminUsersWithNoMFAEnforced {
    Try {
        # Query Security defaults to see if it's enabled. If it is, skip this check.
        $secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
        If ($secureDefault.IsEnabled -eq $false) {
            $conditionalAccess = Get-MgIdentityConditionalAccessPolicy

            $flag = $false
            
            Foreach ($policy in $conditionalAccess) {
                If (($policy.conditions.users.includeusers -eq "All") -and ($policy.grantcontrols.builtincontrols -like "Mfa")) {
                    $flag = $true
                }
            }

            If (!$flag) {
                $unenforced_users = @()
                #$adminRoles = @("9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3", "58a13ea3-c632-46ae-9ee0-9c0d43cd7f3d", "892c5842-a9a6-463a-8041-72aa08ca3cf6", "158c047a-c907-4556-b7ef-446551a6b5f7", "f28a1f50-f6e7-4571-818b-6a12f2af6b6c", "d37c8bed-0711-4417-ba38-b4abe66ce4c2", "9f06204d-73c1-4d4c-880a-6edb90606fd8", "7be44c8a-adaf-4e2a-84d6-ab2649e08a13", "c430b396-e693-46cc-96f3-db01bf8bb62a", "729827e3-9c14-49f7-bb1b-9608f156bbb8", "62e90394-69f5-4237-9190-012177145e10", "69091246-20e8-4a56-aa4d-066075b2a7a8", "17315797-102d-40b4-93e0-432062caca18", "b0f54661-2d74-4c50-afa3-1ec803f12efe", "29232cdf-9323-42fd-ade2-1d097af3e4de", "194ae4cb-b126-40b2-bd5b-6091b380977d")
                $adminRoles = (Get-MgDirectoryRole | Where-Object { $_.DisplayName -match "Admin" } ).RoleTemplateId

                foreach ($role in $adminRoles) {
                    $RID = (Get-MgDirectoryRole -Filter "RoleTemplateId eq '$role'").Id
                    $roleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $RID
                    Foreach ($member in $roleMembers) {
                        If ($member.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.user') {
                            $unenforced_users += (Get-MgReportAuthenticationMethodUserRegistrationDetail -UserRegistrationDetailsId $member.Id | Where-Object { $_.isMfaRegistered -eq $false }).UserPrincipalName
                        }
                        If ($member.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.group') {
                            $grpMembers = (Get-MgGroupMember -GroupId $member.Id)
                            Foreach ($grpMember in $grpMembers) {
                                $unenforced_users += (Get-MgReportAuthenticationMethodUserRegistrationDetail -UserRegistrationDetailsId $grpMember.Id | Where-Object { $_.isMfaRegistered -eq $false }).UserPrincipalName
                            }
                        }
                        If ($member.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.servicePrincipal') {
                            
                        }
                    }
                }
                
                $num_unenforced_users = $unenforced_users.Count
                
                If ($num_unenforced_users -NE 0) {
                    return $unenforced_users
                }
            }
        }

        return $null
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
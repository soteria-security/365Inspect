$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Inspect-ProperAdminCount {
    Try {
        $license = (Invoke-GraphRequest -Method Get -Uri "https://dod-graph.microsoft.us/beta/subscribedSkus").Value.ServicePlans | Where-Object { $_.ServicePlanName -eq 'AAD_PREMIUM_P2' }

        If ($license) {
            $gaRole = (Invoke-GraphRequest  -Method Get -Uri "https://dod-graph.microsoft.us/beta/roleManagement/directory/roleDefinitions?filter=displayName eq 'Global Administrator'").Value

            $gaRoleMembers = (Invoke-GraphRequest  -Method Get -Uri "https://dod-graph.microsoft.us/beta/roleManagement/directory/roleAssignments?filter=roleDefinitionId eq '$(($gaRole).templateId)'").Value

            $results = @()

            foreach ($member in $gaRoleMembers) {
                $user = (Invoke-GraphRequest -Method Get -Uri "https://dod-graph.microsoft.us/beta/directoryObjects/$($member.principalId)")
                $info = [PSCustomObject]@{
                    Name       = ($user.displayName)
                    UPN        = ($user.userPrincipalName)
                    Assigned   = $($member.assignmentstate) 
                    MemberType = $($member.MemberType)
                    Role       = ($gaRole).DisplayName
                }

                $results += "User: $($info.Name) - $($info.UPN), Assignment State: $($info.Assigned), Assignment Type: $($info.MemberType)"
            }

            $num_global_admins = ($results | Measure-Object).Count

            If (($num_global_admins -lt 2) -or ($num_global_admins -gt 4)) {
                return $results
            }
        }
        Else {
            $tenantLicense = ((Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/subscribedSkus").Value).ServicePlans
    
            If ($tenantLicense.ServicePlanName -match "AAD_PREMIUM*") {   
                $gaRole = (Invoke-GraphRequest  -Method Get -Uri "https://dod-graph.microsoft.us/beta/directoryRoles?filter=displayName eq 'Global Administrator'").Value
                $gaRoleMembers = (Invoke-GraphRequest  -Method Get -Uri "https://dod-graph.microsoft.us/beta/directoryRoles/$(($gaRole).Id)/members").Value

                $results = @()

                foreach ($member in $gaRoleMembers) {
                    $user = (Invoke-GraphRequest -Method Get -Uri "https://dod-graph.microsoft.us/beta/directoryObjects/$($member.principalId)")
                    $info = [PSCustomObject]@{
                        Name     = ($member.displayName)
                        UPN      = ($member.userPrincipalName)
                        IsSynced = ($member.onPremisesSyncEnabled)
                    }

                    $results += "User: $($info.Name) - $($info.UPN), IsOn-Premise - $($info.IsSynced)"
                }

                $num_global_admins = ($results | Measure-Object).Count

                If (($num_global_admins -lt 2) -or ($num_global_admins -gt 4)) {
                    return $results
                }
            }
            Else {
                Return "Tenant is not licensed to query this information."
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

return Inspect-ProperAdminCount
$ErrorActionPreference = "Stop"

# Import error log function
$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Inspect-PartnerSupport {
    Try {
        $adminRoles = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/directoryRoles").Value | Where-Object { $_.DisplayName -like "Partner Tier*" }

        $results = @()

        ForEach ($role in $adminRoles) {
            $roleMembers = @()

            $roleMembers = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments?filter=roleDefinitionId eq '$($role.id)'").Value

            $users = @()

            If ($roleMembers.count -gt 0) {
                Foreach ($member in $roleMembers) {
                    If ($member.roleDefinitionId -eq $role.roleTemplateId) {
                        $entity = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/directoryObjects/$($member.principalId)")

                        If ($entity.'@odata.type' -eq '#microsoft.graph.user') {
                            $users += $entity.userPrincipalName
                        }
                        If ($entity.'@odata.type' -eq '#microsoft.graph.group') {
                            $groupMembers = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/groups/$(($entity).Id)/members").Value

                            foreach ($groupMember in $groupMembers) {
                                $users += $groupMember.userPrincipalName
                            }
                        }
                    }
                }
            }

            foreach ($user in $Users) {
                $results += $user + " in role " + $role.DisplayName
            }
        }

        If ($results.Count -ne 0) {
            Return $results | Sort-Object
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

return Inspect-PartnerSupport
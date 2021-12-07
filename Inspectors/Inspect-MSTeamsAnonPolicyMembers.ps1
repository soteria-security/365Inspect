Function Inspect-MSTeamsAnonPolicyMembers{
    Try{
        $teamsPolicies = Get-CsTeamsMeetingPolicy
        $policies = @()
        $results = Get-CsOnlineUser | Where-Object {$_.TeamsMeetingPolicy -eq $null}

        Foreach ($policy in $teamsPolicies) {
            If ($policy.AllowAnonymousUsersToJoinMeeting -eq $true){
                $policies += $policy.Identity
            }
        }

        If ($results.count -ne 0){
            Return $results.UserPrincipalName
        }
    }
    Catch {
        Write-Warning -Message "Error processing request. Manual verification required."
        Return "Error processing request."
        }

    Return $null
}

Return Inspect-MSTeamsAnonPolicyMembers
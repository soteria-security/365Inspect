Function Inspect-MSTeamsAnonUsers{
    Try {
        $teamsPolicies = Get-CsTeamsMeetingPolicy
        $policies = @()

        Foreach ($policy in $teamsPolicies) {
            If ($policy.AllowAnonymousUsersToJoinMeeting -eq $true){
                $policies += $policy.Identity
            }
        }

        If ($policies.count -ne 0){
            Return "$($policies.count) policies allow anonymous users to join meetings."
            Return $policies
        }
    }
    Catch {
        Write-Warning -Message "Error processing request. Manual verification required."
        Return "Error processing request."
    }

    Return $null
}

Return Inspect-MSTeamsAnonUsers
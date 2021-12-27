Function Inspect-MSTeamsLinkPreview{
    Try{
        $teamsPolicies = Get-CsTeamsMessagingPolicy
        $policies = @()
        $results = Get-CsOnlineUser | Where-Object {$null -eq $_.TeamsMeetingPolicy}

        Foreach ($policy in $teamsPolicies) {
            If ($policy.AllowUrlPreviews -eq $true){
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

Return Inspect-MSTeamsLinkPreview
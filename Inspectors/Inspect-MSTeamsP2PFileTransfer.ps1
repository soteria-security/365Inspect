function Inspect-MSTeamsP2PFileTransfer {
    Try {
        $policies = Get-CsExternalUserCommunicationPolicy

        Foreach ($policy in $policies){
            If ($policy.EnableP2PFileTransfer -eq $true){
                Return $policy.Identity
            }
        }

        Return $null
    }
    Catch {
        Write-Warning -Message "Error processing request. Manual verification required."
        Return "Error processing request."
        }
}

return Inspect-MSTeamsP2PFileTransfer
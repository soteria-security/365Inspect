Function Inspect-MSTeamsConsumerSettings {
	Try {
        $configuration = Get-CsTenantFederationConfiguration

        $result = $null

            If (($configuration.AllowTeamsConsumer -eq $true) -and ($configuration.AllowTeamsConsumerInbound -eq $true) -and ($configuration.AllowPublicUsers -eq $true)){
                $result = "No restricitons are in place for communication with public Skype or Teams users."
                }

            ElseIf (($configuration.AllowTeamsConsumerInbound -eq $true) -and ($configuration.AllowTeamsConsumer -eq $true)){
                $result = "Public Teams users can initiate unsolicited communication to internal recipients."
                }
        
            ElseIf (($configuration.AllowTeamsConsumer -eq $true) -and ($configuration.AllowTeamsConsumerInbound -eq $false)){
                $result = "Users are allowed to initiate communication with public Teams users."
               }

            ElseIf (($configuration.AllowPublicUsers -eq $true) -and ($configuration.AllowTeamsConsumer -eq $false)){
                $result = "No restricitons are in place for communication with public Skype users.."
                }

        Return $result
        }
	Catch {
        Write-Warning -Message "Error processing request. Manual verification required."
        Return "Error processing request."
        }
}
return Inspect-MSTeamsConsumerSettings
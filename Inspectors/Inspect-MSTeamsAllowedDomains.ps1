Function Inspect-MSTeamsAllowedDomains {
	Try {
		 $configuration = Get-CsTenantFederationConfiguration

         If (($configuration.AllowedDomains -like "*AllowAllKnownDomains*") -and ($configuration.AllowFederatedUsers -eq $true)){
             Return "All Domains Allowed"
         }

         If (($configuration.AllowedDomains -like "*AllowAllKnownDomains*") -and ($configuration.AllowFederatedUsers -eq $false)){
            Return "All External Domains Blocked"
        }

         If ($configuration.AllowedDomains -Like "Domain=*"){
             Return "Allowed domains: $($configuration.AllowedDomains)"
         }

         If ($configuration.BlockedDomains){
             Return "Blocked domains: $($configuration.BlockedDomains)"
         }

         Return $null
	}
	Catch {
        Write-Warning -Message "Error processing request. Manual verification required."
        Return "Error processing request."
        }
}
return Inspect-MSTeamsAllowedDomains
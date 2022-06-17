$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-MSTeamsAllowedDomains {
Try {

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
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
Write-Verbose "Errors written to log"
}

}
return Inspect-MSTeamsAllowedDomains



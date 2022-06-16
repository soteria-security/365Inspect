$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-MSTeamsConsumerSettings {
Try {

	Try {
        $configuration = Get-CsTenantFederationConfiguration

        $result = $null

            If (($configuration.AllowTeamsConsumer -eq $true) -and ($configuration.AllowTeamsConsumerInbound -eq $true) -and ($configuration.AllowPublicUsers -eq $true)){
                $result = "No restrictions are in place for communication with public Skype or Teams users."
                }

            ElseIf (($configuration.AllowTeamsConsumerInbound -eq $true) -and ($configuration.AllowTeamsConsumer -eq $true)){
                $result = "Public Teams users can initiate unsolicited communication to internal recipients."
                }
        
            ElseIf (($configuration.AllowTeamsConsumer -eq $true) -and ($configuration.AllowTeamsConsumerInbound -eq $false)){
                $result = "Users are allowed to initiate communication with public Teams users."
               }

            ElseIf (($configuration.AllowPublicUsers -eq $true) -and ($configuration.AllowTeamsConsumer -eq $false)){
                $result = "No restrictions are in place for communication with public Skype users."
                }

        Return $result
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
return Inspect-MSTeamsConsumerSettings



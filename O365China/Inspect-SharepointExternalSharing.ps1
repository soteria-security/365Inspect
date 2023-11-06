$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SharepointExternalSharing {
    Try {
        $sharing_capability = (Get-PnPTenant).SharingCapability
        $restrictedSharing = (Get-PnPTenant).SharingAllowedDomainList
        If ($sharing_capability -ne "Disabled") {
            If ($sharing_capability -eq "ExternalUserAndGuestSharing") {
                $sharing_capability = "ExternalUserAndGuestSharing (Anyone)"
            }
            elseif ($sharing_capability -eq "ExternalUserSharingOnly") {
                $sharing_capability = "ExternalUserSharingOnly (New and Existing Guests)"
            }
            elseif ($sharing_capability -eq "ExistingExternalUserSharingOnly") {
                $sharing_capability = "ExistingExternalUserSharingOnly (Existing Guests)"
            }
		
            If ($restrictedSharing) {
                $message = "$(@($org_name)) : Sharing capability is $sharing_capability. External sharing limited by domain. Allowed domains: $($restrictedSharing -join ",")"
            }
            Else {
                $message = "$(@($org_name)) : Sharing capability is $sharing_capability."
            }

            return @($message)
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

return Inspect-SharepointExternalSharing
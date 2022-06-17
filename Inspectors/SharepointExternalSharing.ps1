$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SharepointExternalSharing {
Try {

	$sharing_capability = (Get-SPOTenant).SharingCapability
	If ($sharing_capability -ne "Disabled") {
		If ($sharing_capability -eq "ExternalUserAndGuestSharing"){
			$sharing_capability = "ExternalUserAndGuestSharing (Anyone)"}
			elseif ($sharing_capability -eq "ExternalUserSharingOnly"){
				$sharing_capability = "ExternalUserSharingOnly (New and Existing Guests)"}
				elseif ($sharing_capability -eq "ExistingExternalUserSharingOnly"){
					$sharing_capability = "ExistingExternalUserSharingOnly (Existing Guests)"}
		$message = $org_name + ": " + "Sharing capability is " + $sharing_capability + "."
		return @($message)
	}
	
	return $null

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

return Inspect-SharepointExternalSharing



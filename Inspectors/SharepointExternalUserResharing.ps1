$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SharepointExternalUserResharing {
Try {

	If ((Get-SPOTenant).SharingCapability -ne "Disabled"){
		If (-NOT (Get-SPOTenant).PreventExternalUsersFromResharing) {
			return "Tenant PreventExternalUsersFromResharing configuration: $((Get-SPOTenant).PreventExternalUsersFromResharing)"
		}
	Else{
		return $null
		}
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

return Inspect-SharepointExternalUserResharing



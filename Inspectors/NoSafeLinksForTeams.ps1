$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-NoSafeLinksForTeams {
Try {

	Try {
		$safelinks_for_teams_policies = Get-SafeLinksPolicy | Where-Object {$_.EnableSafeLinksForTeams -ne $true}
		If (($safelinks_for_teams_policies | Measure-Object).Count -ne 0) {
			return $safelinks_for_teams_policies.EnableSafeLinksForTeams
		}
	} Catch [System.Management.Automation.CommandNotFoundException] {
		return $null
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

return Inspect-NoSafeLinksForTeams



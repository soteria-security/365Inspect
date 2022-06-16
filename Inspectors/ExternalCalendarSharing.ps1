$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-ExternalCalendarSharing {
Try {

	$enabled_share_policies = Get-SharingPolicy | Where-Object -FilterScript {$_.Enabled}
	$enabled_external_share_policies = @()
	
	ForEach ($policy in $enabled_share_policies) {
		$domains = $policy | Select-Object -ExpandProperty Domains
		$calendar_sharing_anon = ($domains -like 'Anonymous:Calendar*')
		If ($calendar_sharing_anon.Count -NE 0) {
			$enabled_external_share_policies += $policy.Name
		}
	}
	
	If ($enabled_external_share_policies.Count -NE 0) {
		return $enabled_external_share_policies
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

return Inspect-ExternalCalendarSharing



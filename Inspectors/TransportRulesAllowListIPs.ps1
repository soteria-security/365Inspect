$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-TransportRulesallowlistIPs {
Try {

	$ip_allowlist_rules = (Get-TransportRule | Where { $_.SetSCL -AND ($_.SetSCL -as [int] -LE 0) -AND $_.SenderIPRanges }).Name
	
	If ($ip_allowlist_rules.Count -eq 0) {
		return $null
	}
	
	return $ip_allowlist_rules

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

return Inspect-TransportRulesallowlistIPs



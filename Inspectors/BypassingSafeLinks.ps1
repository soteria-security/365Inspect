$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-BypassingSafeLinks {
Try {

	$safe_links_bypass_rules = (Get-TransportRule | Where-Object {($_.State -eq "Enabled") -and ($_.SetHeaderName -eq "X-MS-Exchange-Organization-SkipSafeLinksProcessing")}).Identity
	
	If ($safe_links_bypass_rules.Count -ne 0) {
		return $safe_links_bypass_rules
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

return Inspect-BypassingSafeLinks



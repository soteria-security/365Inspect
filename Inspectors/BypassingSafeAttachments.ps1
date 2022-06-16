$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


# Define a function that we will later invoke.
# 365Inspect's built-in modules all follow this pattern.
function Inspect-BypassingSafeAttachments {
Try {

	# Query some element of the O365 environment to inspect. Note that we did not have to authenticate to Exchange
	# to fetch these transport rules within this module; assume main 365Inspect harness has logged us in already.
	$safe_attachment_bypass_rules = (Get-TransportRule | Where-Object { $_.SetHeaderName -eq "X-MS-Exchange-Organization-SkipSafeAttachmentProcessing" }).Identity
	
	# If some of the parsed O365 objects were found to have the security flaw this module is inspecting for,
	# return a list of those objects.
	If ($safe_attachment_bypass_rules.Count -ne 0) {
		return $safe_attachment_bypass_rules
	}
	
	# If none of the parsed O365 objects were found to have the security flaw this module is inspecting for,
	# returning $null indicates to 365Inspect that there were no findings for this module.
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

# Return the results of invoking the inspector function.
return Inspect-BypassingSafeAttachments



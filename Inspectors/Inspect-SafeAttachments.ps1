$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-ATPSafeAttachments {
Try {

	# This will throw an error if the environment under test does not have an ATP license,
	# but should still work.
	Try {
		$safe_attachment_policies = Get-SafeAttachmentPolicy
		If ($safe_attachment_policies.Enable -ne $true) {
			return $safe_attachment_policies.Enable
		}
	} Catch {
		return @($org_name)
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

return Inspect-ATPSafeAttachments



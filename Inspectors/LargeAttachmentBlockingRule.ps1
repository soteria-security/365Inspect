$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-LargeAttachmentBlockingRule {
Try {

	$rules = Get-TransportRule
	$flag = $False

	ForEach ($rule in $rules) {
		if (($rule.AttachmentSizeOver -like "*") -AND (($rule.DeleteMessage -ne $false) -OR ($null -ne $rule.RejectMessageReasonText))) {
			$flag = $True
		}
	}
	
	If (-NOT $flag) {
		return @($org_name)
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

return Inspect-LargeAttachmentBlockingRule



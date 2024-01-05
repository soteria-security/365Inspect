$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-AutoForwarding {
Try {

	$externalForwarding = Get-HostedOutboundSpamFilterPolicy

    If ($externalForwarding.AutoForwardingMode -eq "On") {
		$rules = Get-TransportRule
		$flag = $False

		ForEach ($rule in $rules) {
			If (($rule.MessageTypeMatches -eq "AutoForward") -AND ($rule.DeleteMessage -OR $rule.RejectMessageReasonText)) {
				$flag = $True
			}
		}

		If (-NOT $flag) {
			return @($org_name)
		}
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

return Inspect-AutoForwarding



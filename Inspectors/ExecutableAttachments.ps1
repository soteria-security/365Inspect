$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-ExecutableAttachments {
Try {

	$rules = Get-TransportRule
	$action1 = "Microsoft.Exchange.MessagingPolicies.Rules.Tasks.DeleteMessageAction"
	$action2 = "Microsoft.Exchange.MessagingPolicies.Rules.Tasks.RejectMessageAction"
    $flag = $False

	ForEach ($rule in $rules) {
		If (($rule.AttachmentHasExecutableContent -eq $true) -and (($rule.Actions -contains $action1) -or ($rule.Actions -contains $action2) -or ($rule.DeleteMessage -eq $true))) {
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

return Inspect-ExecutableAttachments



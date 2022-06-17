$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-IPInUrlIsSpam {
Try {
	$policies = Get-HostedContentFilterPolicy

	$settingOff = @()

	$settingOn = @()

	Foreach ($policy in $policies){
		If ($policy.IncreaseScoreWithNumericIps -eq "On") {
			$settingOn += $policy.Name
		}
		elseif ($policy.IncreaseScoreWithNumericIps -ne "On") {
			$settingOff += "$($policy.Name): $($policy.IncreaseScoreWithNumericIps)"
		}
	}

	If (($settingOn | Measure-Object).Count -eq 0){
		return $settingOff
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

return Inspect-IPInUrlIsSpam



$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-MailFlowRules {
Try {

	$rules = Get-TransportRule

	If ($rules.count -gt 0) {
		$path = New-Item -ItemType Directory -Force -Path "$($path)\Mail-Flow-Rules"

		ForEach ($rule in $rules) {
			$name = $rule.Name

            $pattern = '[\\\[\]\{\}/():;\*]'

            $name = $name -replace $pattern, '-'

			$rule | Format-List | Out-File -FilePath "$($path)\$($name)_Mail-Flow-Rule.txt"
		}
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

return Inspect-MailFlowRules



$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-ATPSafeLinks {
Try {

	# This will throw an error if the environment under test does not have an ATP license,
	# but should still work.
	Try {
		$flag = $false
		
		$safe_links_policies = Get-SafeLinksPolicy

		$disabledPolicy = @()
		
		Foreach ($policy in $safe_links_policies){
			If (($policy.EnableSafeLinksForEmail -eq $false) -and ($policy.EnableSafeLinksForTeams -eq $false) -and ($policy.EnableSafeLinksForOffice -eq $false) -and ($policy.EnableForInternalSenders -eq $false) -and ((Get-SafeLinksRule -Identity ($policy).Identity).State -eq "Enabled")) {
				$flag = $true
				$disabledPolicy += "SafeLinks disabled for policy: $($policy.Identity)"
			}
		}

		If ($flag -eq $true){
			Return $disabledPolicy
		}
	} Catch [System.Management.Automation.CommandNotFoundException] {
		return $null
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

return Inspect-ATPSafeLinks



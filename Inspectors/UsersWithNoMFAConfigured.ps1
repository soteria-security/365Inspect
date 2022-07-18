$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-UsersWithNoMFAConfigured {
Try {

	$conditionalAccess = Get-MgIdentityConditionalAccessPolicy

	$flag = $false
	
	Foreach ($policy in $conditionalAccess) {
		If (($policy.conditions.users.includeusers -eq "All") -and ($policy.grantcontrols.builtincontrols -like "Mfa")){
			$flag = $true
		}
	}

	If (!$flag){
		$unenabled_users = (Get-MsolUser -All | Where-Object {($_.isLicensed -eq $true) -and ($_.StrongAuthenticationMethods.Count -eq 0) -and ($_.BlockCredential -eq $False) -and ($_.StrongAuthenticationRequirements.State -NE "Enforced")}).UserPrincipalName
		
		If ($unenabled_users -ne 0) {
			return $unenabled_users
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
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $strace
Write-Verbose "Errors written to log"
}

}

return Inspect-UsersWithNoMFAConfigured



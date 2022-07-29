$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-UsersWithNoMFAEnforced {
Try {

	# Query Security defaults to see if it's enabled. If it is, skip this check.
	$secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
    If ($secureDefault.IsEnabled -eq $false){
		$conditionalAccess = Get-AzureADMSConditionalAccessPolicy

		$flag = $false
		
		Foreach ($policy in $conditionalAccess) {
			If (($policy.conditions.users.includeusers -eq "All") -and ($policy.grantcontrols.builtincontrols -like "Mfa")){
				$flag = $true
			}
		}

		If (!$flag){
			$unenforced_users = (Get-MsolUserByStrongAuthentication -MaxResults 999999 | Where-Object {($_.isLicensed -eq $true) -and ($_.StrongAuthenticationRequirements.State -NE "Enforced")}).UserPrincipalName
			$num_unenforced_users = $unenforced_users.Count
			If ($num_unenforced_users -NE 0) {
				return $unenforced_users
			}
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

return Inspect-UsersWithNoMFAEnforced



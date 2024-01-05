$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Get-AntiSpoofingPolicy {
Try {

	$policies = Get-AntiPhishPolicy | Where-object {$_.enabled -eq $true}
	$flag = $False

    If ($policies.Count -ne 0){
        ForEach ($policy in $policies) {    
            if (($policy.EnableSpoofIntelligence -eq $true) -and (($policy.EnableOrganizationDomainsProtection -eq $true) -or ($policy.EnableTargetedDomainsProtection -eq $true) -or ($policy.EnableTargetedUserProtection -eq $true))) {
                $flag = $True
            }
        }
    }
	
	If (-NOT $flag) {
		return $False
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

return Get-AntiSpoofingPolicy



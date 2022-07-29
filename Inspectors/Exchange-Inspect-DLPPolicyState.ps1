$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-DLPPolicyState {
Try {

	$dlpPolicies = Get-DlpCompliancePolicy | Where-Object {$_.Mode -notlike "Enable"}

    $policies = @()
    
    foreach ($policy in $dlpPolicies){
        $policies += "$($policy.Name) state is $($policy.mode)"
    }

    If ($policies.Count -gt 0){
        Return $policies
    }
    Return $null

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
return Inspect-DLPPolicyState



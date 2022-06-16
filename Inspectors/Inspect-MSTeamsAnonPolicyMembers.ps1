$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-MSTeamsAnonPolicyMembers{
Try {

    Try{
        $teamsPolicies = Get-CsTeamsMeetingPolicy
        $policies = @()
        $results = Get-CsOnlineUser | Where-Object {$null -eq $_.TeamsMeetingPolicy}

        Foreach ($policy in $teamsPolicies) {
            If ($policy.AllowAnonymousUsersToJoinMeeting -eq $true){
                $policies += $policy.Identity
            }
        }

        If ($results.count -ne 0){
            Return $results.UserPrincipalName
        }
    }
    Catch {
        Write-Warning -Message "Error processing request. Manual verification required."
        Return "Error processing request."
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

Return Inspect-MSTeamsAnonPolicyMembers



$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-MSTeamsAnonUsers{
Try {

    Try {
        $defaultPolicies = @("Tag:AllOn","Tag:RestrictedAnonymousAccess","Tag:AllOff","Tag:RestrictedAnonymousNoRecording","Tag:Default","Tag:Kiosk")
    
    $teamsPolicies = Get-CsTeamsMeetingPolicy | Where-Object {$_.Identity -notmatch ($defaultPolicies -join '|')}
        $policies = @()

        Foreach ($policy in $teamsPolicies) {
            If ($policy.AllowAnonymousUsersToJoinMeeting -eq $true){
                $policies += $policy.Identity
            }
        }

        If (($policies | Measure-Object).count -ne 0){
            Return $policies
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

Return Inspect-MSTeamsAnonUsers



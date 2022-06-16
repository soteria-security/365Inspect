$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-MSTeamsLinkPreview{
Try {

    Try{
        $users = Get-CsOnlineUser

        $teamsPolicies = Get-CsTeamsMessagingPolicy | Where-Object {$_.AllowUrlPreviews -eq $true}

        $results = @()
        
        Foreach ($user in $users) {
            If ((($user.TeamsMessagingPolicy.Name).length -lt 1) -or ($teamsPolicies -match $user.TeamsMessagingPolicy.Name)){
            $results += $user.UserPrincipalName
            }
        }

        If ($results.count -ne 0){
            Return $results
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

Return Inspect-MSTeamsLinkPreview



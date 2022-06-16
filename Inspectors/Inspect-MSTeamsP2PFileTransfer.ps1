$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-MSTeamsP2PFileTransfer {
Try {

    Try {
        $policies = Get-CsExternalUserCommunicationPolicy

        Foreach ($policy in $policies){
            If ($policy.EnableP2PFileTransfer -eq $true){
                Return "Policy Name: $($policy.Identity); P2PFTP Enabled: $($policy.EnableP2PFileTransfer)"
            }
        }

        Return $null
    }
    Catch {
        Write-Warning -Message "Error processing request. Manual verification required."
        Return "Error processing request."
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

return Inspect-MSTeamsP2PFileTransfer



$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-EXOSendOnBehalfOf{
Try {

    
    $GrantSendOnBehalfTo = Get-Mailbox -ResultSize Unlimited | Where-Object {$_.GrantSendOnBehalfTo -like "*"}

    if ($GrantSendOnBehalfTo.Count -gt 0) {
        $GrantSendOnBehalfTo | Select-Object Identity, GrantSendOnBehalfTo | Out-File -FilePath "$($path)\EXOGrantSendOnBehalfToPermissions.txt" -Append
        Return $GrantSendOnBehalfTo.Identity
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

Inspect-EXOSendOnBehalfOf



$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-EXOSendAsPermissions{
Try {

    
    $sendAs = Get-Mailbox -ResultSize Unlimited | Get-RecipientPermission | Where-Object {($_.Trustee -ne 'NT AUTHORITY\SELF') -and ($_.AccessControlType -eq "Allow")}

    if ($sendAs.Count -gt 0) {
        $sendAs | Out-File -FilePath "$($path)\EXOSendAsPermissions.txt" -Append
        Return $sendAs.Identity
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

Inspect-EXOSendAsPermissions



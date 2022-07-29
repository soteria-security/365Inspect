$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-EXOFullAccess{
Try {

    
    $fullAccess = Get-Mailbox -ResultSize Unlimited | Where-Object {($_.User -ne 'NT AUTHORITY\SELF') -and ($_.AccessRights -eq 'FullAccess')}

    if ($fullAccess.Count -gt 0) {
        $fullAccess | Out-File -FilePath "$($path)\EXOFullAccessPermissions.txt" -Append
        Return $fullAccess.Identity
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

Inspect-EXOFullAccess



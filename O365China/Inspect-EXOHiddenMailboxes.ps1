$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-EXOHiddenMailboxes{
Try {
    if ((Test-path "$path\Exchange") -eq $true){
        $path = "$path\Exchange"
    }
    Else {
        $path = New-Item -ItemType Directory -Force -Path "$($path)\Exchange"
    }
    
    $hiddenMailboxes = Get-Mailbox -ResultSize Unlimited | Where-Object {($_.HiddenFromAddressListsEnabled -eq $true) -and ($_.Identity -notlike "DiscoverySearchMailbox*")}

    if ($hiddenMailboxes.Count -gt 0) {
        $hiddenMailboxes | Export-CSV "$($path)\EXOHiddenMailboxes.csv" -Delimiter ';' -NoTypeInformation -Append
        Return $hiddenMailboxes.Identity
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
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $strace
Write-Verbose "Errors written to log"
}

}

Inspect-EXOHiddenMailboxes



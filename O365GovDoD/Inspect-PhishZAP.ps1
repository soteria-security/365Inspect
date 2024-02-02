$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-PhishZAP {
    Try {

        $antimalwarePolicies = Get-HostedContentFilterPolicy | Where-Object {$_.PhishZapEnabled -eq $false}
            
        $results = @()
        
        Foreach ($policy in $antimalwarePolicies){
            $results += "Policy Name: $($policy.Name); PhishZAPEnabled: $($policy.PhishZAPEnabled)"
            }

        Return $results

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

return Inspect-PhishZAP
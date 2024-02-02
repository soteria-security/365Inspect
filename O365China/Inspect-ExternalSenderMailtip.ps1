$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-ExternalSenderMailtip {
    Try {
        $rules = Get-TransportRule | Where-Object { ($_.FromScope -eq 'NotInOrganization') -and (($_.ApplyHtmlDisclaimerLocation -eq 'Append') -or ($_.ApplyHtmlDisclaimerLocation -eq 'Prepend')) }

        If (!$rules) {
            If ((Get-ExternalInOutlook).Enabled -eq $false) {
                return [string](Get-ExternalInOutlook).Enabled
            }

        
        }
        Else {
        
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

return Inspect-ExternalSenderMailtip
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-DMARCPolicyAction {
    Try {
        $domains = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.us/beta/domains" -ErrorAction Stop).Value | Where-Object { $_.Id -notlike "*.*microsoft*.com" }
        $domains_without_actions = @()
	
        ForEach ($domain in $domains.Id) {
            Try {
		    ($dmarc_record = ((nslookup -querytype=txt _dmarc.$domain 2>&1 | Select-String "DMARC1") -replace "`t", "")) | Out-Null
            }
            Catch {
                $exception = $_.Exception
            }
		
            If ($dmarc_record -Match "p=none;") {
                $domains_without_actions += "$domain policy: $(($dmarc_record -split ";")[1])"
            }
        }
	
        If ($null -ne $domains_without_actions) {
            return $domains_without_actions
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

return Inspect-DMARCPolicyAction
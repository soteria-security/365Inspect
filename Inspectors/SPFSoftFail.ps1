$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SPFSoftFail {
    Try {
        $domains = (Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/beta/domains").Value | Where-Object { $_.id -notlike "*.*microsoft*.com" }
        $domains_with_soft_fail = @()
	
        ForEach ($domain in $domains.Id) {
            Try {
            ($spf_record = (Resolve-DnsName -Name $domain -Type TXT -Server 8.8.8.8 -ErrorAction Stop | Where-Object { $_.strings -match "spf" } | Select-Object @{N = "Strings"; e = { $_.Strings } }).Strings) | Out-Null
            }
            Catch {
                $exception = $_.Exception
                If ($exception -like "*Non-existent domain*") {
            
                }
            }
    
            If (($spf_record) -and (-NOT ($spf_record -Match "-all"))) {
                $domains_with_soft_fail += $domain
            }
        }
	
        If ($domains_with_soft_fail.Count -ne 0) {
            return $domains_with_soft_fail
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

return Inspect-SPFSoftFail
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-DMARCRecords {
    Try {
        $domains = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/domains" -ErrorAction Stop).Value | Where-Object { $_.Id -notlike "*.*microsoft*.com" }
        $domains_without_records = @()
	
        ForEach ($domain in $domains.Id) {
            Try {
		    ($dmarc_record = (Resolve-DnsName -Name "_dmarc.$domain" -Type TXT -Server 8.8.8.8 -ErrorAction Stop | Where-Object { $_.strings -match "DMARC1" } | Select-Object @{N = "Strings"; e = { $_.Strings } }).Strings) | out-null
            }
            Catch {
                $exception = $_.Exception
                $domains_without_records += $domain
            }
		
            If (-NOT $dmarc_record) {
                $domains_without_records += $domain
            }
        }
	
        If ($null -ne $domains_without_records) {
            return $domains_without_records
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

return Inspect-DMARCRecords
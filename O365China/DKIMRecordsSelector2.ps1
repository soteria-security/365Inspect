$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-DKIMRecordsSelector2 {
    Try {
        $domains = (Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/domains" -ErrorAction Stop).Value | Where-Object { $_.Id -notlike "*.*microsoft*.com" }
        $domains_without_records = @()
	
        ForEach ($domain in $domains.Id) {
            Try {
		    ($dkim_two_output = (Resolve-DnsName -Name "selector2._domainkey.$domain" -Type CNAME -Server 8.8.8.8 -ErrorAction Stop).Name) | Out-Null
            }
            Catch {
                $exception = $_.Exception
                If ($exception -like "*Non-existent domain*") {
                    $domains_without_records += $domain
                }
            }
		
            If (-NOT $dkim_two_output) {
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

return Inspect-DKIMRecordsSelector2
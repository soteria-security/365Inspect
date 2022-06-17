$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SPFSoftFail {
Try {

	$domains = Get-MgDomain | Where-Object {$_.Id -notlike "*.onmicrosoft.com"}
    $domains_with_soft_fail = @()
	
    ForEach($domain in $domains.name) {
        ($spf_record = ((nslookup -querytype=txt $domain 2>&1 | Select-String "spf1") -replace "`t", "")) | Out-Null
		
        If ( -NOT ( $spf_record -Match "-all" ) ) {
            $domains_with_soft_fail += $domain
        }
    }
	
    If ($domains_with_soft_fail.Count -ne 0) {
        return $domains_with_soft_fail
    }
	
    return $null

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

return Inspect-SPFSoftFail



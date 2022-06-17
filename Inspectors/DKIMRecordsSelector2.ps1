$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-DKIMRecordsSelector2 {
Try {

	$domains = Get-MgDomain | Where-Object {$_.Id -notlike "*.onmicrosoft.com"}
	$domains_without_records = @()
	
	ForEach($domain in $domains.Id) {
		($dkim_two_output = (nslookup -querytype=cname selector2._domainkey.$domain 2>&1 | Select-String "canonical name")) | Out-Null
		
		If (-NOT $dkim_two_output) {
			$domains_without_records += $domain
		}
	}
	
	If (($domains_without_records | Measure-Object).Count -ne 0) {
		return $domains_without_records
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

return Inspect-DKIMRecordsSelector2



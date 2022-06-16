$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-SPFRecords {
Try {

	$domains = Get-MgDomain | Where-Object {$_.Id -notlike "*.onmicrosoft.com"}
	$domains_without_records = @()
	
	# The redirection is kind of a cheesy hack to prevent the output from
	# cluttering the screen.
	ForEach($domain in $domains.Name) {
		($spf_record = ((nslookup -querytype=txt $domain 2>&1 | Select-String "spf1") -replace "`t", "")) | Out-Null
		
		If (-NOT $spf_record) {
			$domains_without_records += $domain
		}
	}
	
	If ($domains_without_records.Count -ne 0) {
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

return Inspect-SPFRecords



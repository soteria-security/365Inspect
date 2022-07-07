$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-DMARCPolicyAction {
Try {

	$domains = Get-MgDomain | Where-Object {$_.Id -notlike "*.*microsoft*.com"}
	$domains_without_actions = @()
	
	ForEach($domain in $domains.Id) {
		($dmarc_record = ((nslookup -querytype=txt _dmarc.$domain 2>&1 | Select-String "DMARC1") -replace "`t", "")) | Out-Null
		
		If ($dmarc_record -Match "p=none;") {
			$domains_without_actions += "$domain policy: $(($dmarc_record -split ";")[1])"
		}
	}
	
	If ($domains_without_actions.Count -ne 0) {
		return $domains_without_actions
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

return Inspect-DMARCPolicyAction



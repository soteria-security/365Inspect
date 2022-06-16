$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-ADFSConfiguration {
Try {

	$orgs_with_ADFS = @()
	Get-OrganizationConfig | 
		ForEach-Object -Process {if ($null -ne $_.AdfsIssuer) {$orgs_with_ADFS += $_.Name;}}
		
	If ($orgs_with_ADFS.Count -NE 0) {
		return $orgs_with_ADFS
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

return Inspect-ADFSConfiguration



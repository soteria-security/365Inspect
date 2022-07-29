$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-DocumentSharingWLBL{
try{
$DocumentSharingWLBLData = @()
$DocumentSharingWLBL = Get-SPOTenant | select SharingDomainRestrictionMode,SharingAllowedDomainList
if ($DocumentSharingWLBL.SharingDomainRestrictionMode -match 'None' -and $DocumentSharingWLBL.SharingAllowedDomainList -eq $null){
foreach ($DocumentSharingWLBLObj in $DocumentSharingWLBL){
$DocumentSharingWLBLData += " SharingDomainRestrictionMode: "+$DocumentSharingWLBL.SharingDomainRestrictionMode
$DocumentSharingWLBLData += "`n SharingAllowedDomainList: "+$DocumentSharingWLBL.SharingAllowedDomainList
}
return $DocumentSharingWLBLData
}
return $null
}catch{
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
return Audit-DocumentSharingWLBL
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-SafeLinksCheckEnabled{
try{
$auditsafelinkscheckdata = @()
$auditsafelinkscheck = Get-SafeLinksPolicy | select IsEnabled,AllowClickThrough,DoNotAllowClickThrough,ScanUrls,EnableForInternalSenders,EnableSafeLinksForTeams
if ($auditsafelinkscheck.IsEnabled -match 'False' -and $auditsafelinkscheck.AllowClickThrough -match 'True' -and $auditsafelinkscheck.DoNotAllowClickThrough -match 'False' -and $auditsafelinkscheck.ScanUrls -match 'False' -and $auditsafelinkscheck.EnableSafeLinksForTeams -match 'False'){
$auditsafelinkscheckdata += " IsEnabled: "+$auditsafelinkscheck.IsEnabled
$auditsafelinkscheckdata += "`n AllowClickThrough: "+$auditsafelinkscheck.AllowClickThrough
$auditsafelinkscheckdata += "`n DoNotAllowClickThrough: "+$auditsafelinkscheck.DoNotAllowClickThrough
$auditsafelinkscheckdata += "`n ScanUrls: "+$auditsafelinkscheck.ScanUrls
$auditsafelinkscheckdata += "`n EnableSafeLinksForTeams: "+$auditsafelinkscheck.EnableSafeLinksForTeams
return $auditsafelinkscheckdata
}
return $null
}Catch{
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
return Audit-SafeLinksCheckEnabled
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-SPOUnmanagedDevicesBlock{
try{
$SPOUnmanagedDevicesBlockData = @()
$SPOUnmanagedDevicesBlock = Get-SPOTenantSyncClientRestriction | select TenantRestrictionEnabled,AllowedDomainList,BlockMacSync
if ($SPOUnmanagedDevicesBlock.TenantRestrictionEnabled -match 'False' -or $SPOUnmanagedDevicesBlock.BlockMacSync -match 'False'){
$SPOUnmanagedDevicesBlockData += " TenantRestrictionEnabled: "+$SPOUnmanagedDevicesBlock.TenantRestrictionEnabled
$SPOUnmanagedDevicesBlockData += "`n AllowedDomainList: "+$SPOUnmanagedDevicesBlock.AllowedDomainList
$SPOUnmanagedDevicesBlockData += "`n BlockMacSync: "+$SPOUnmanagedDevicesBlock.BlockMacSync
return $SPOUnmanagedDevicesBlockData
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
return Audit-SPOUnmanagedDevicesBlock
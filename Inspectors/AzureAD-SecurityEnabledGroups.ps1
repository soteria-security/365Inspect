$ErrorActionPreference = "SilentlyContinue"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-SecurityEnabledADGroups{
try{
$object = @()
$groups = Get-AzureADGroup -All $true | Where-Object {$_.SecurityEnabled -eq $False} | select DisplayName,SecurityEnabled
$groupscount = $groups.SecurityEnabled.Count
if ($groupscount -ne 0){
foreach ($group in $groups){
$object += "$($group.DisplayName): $($group.SecurityEnabled)"
}
return $object
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
return Audit-SecurityEnabledADGroups
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-ATPPolicyForO365OptimalConfiguration{
try{
$finalobject = @()
#Checks if AntiPhish Policies have a optimal configuration
$ATPPolicies = Get-AtpPolicyForO365 | select TrackClicks, AllowClickThrough, EnableATPForSPOTeamsODB, EnableSafeDocs, EnableSafeLinksForO365Clients, AllowSafeDocsOpen
foreach ($ATPPolicy in $ATPPolicies){
$finalobject += $ATPPolicy.Name
#Array for values that are false
$array = @("AllowClickThrough","AllowSafeDocsOpen")
#Array for values that are true
$array2 = @("EnableSafeDocs","TrackClicks","EnableATPForSPOTeamsODB","EnableMailboxIntelligence", "EnableSafeLinksForO365Clients")
foreach($object in $array){
if ($ATPPolicy.$object -eq $true){
$object = "$($object): $($ATPPolicy.$object)"
$finalobject += $object
}
}
foreach($object in $array2){
if($ATPPolicy.$object -eq $false){
$object = "$($object): $($ATPPolicy.$object)"
$finalobject += $object
}
}
}
if ($finalobject.Count -ne 0){
return $finalobject
}else{
return $null
}
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

return Audit-ATPPolicyForO365OptimalConfiguration
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-AntiPhishPolicyOptimalConfiguration{
try{
$finalobject = @()
#Checks if AntiPhish Policies have a optimal configuration
$AntiPhishPolicies = Get-AntiPhishPolicy | where Enabled -eq $True | select Name, Enabled, EnableTargetedUserProtection, EnableMailboxIntelligenceProtection, EnableTargetedDomainsProtection, EnableOrganizationDomainsProtection, EnableMailboxIntelligence, EnableFirstContactSafetyTips, EnableSimilarUsersSafetyTips, EnableSimilarDomainsSafetyTips, EnableUnusualCharactersSafetyTips
foreach ($AntiPhishPolicy in $AntiPhishPolicies){
$finalobject += $AntiPhishPolicy.Name
$array = @("EnableTargetedUserProtection", "EnableMailboxIntelligenceProtection", "EnableTargetedDomainsProtection", "EnableOrganizationDomainsProtection", "EnableMailboxIntelligence", "EnableFirstContactSafetyTips", "EnableSimilarUsersSafetyTips", "EnableSimilarDomainsSafetyTips", "EnableUnusualCharactersSafetyTips")
foreach($object in $array){
if ($AntiPhishPolicy.$object -eq $false){
$object = "$($object): $($AntiPhishPolicy.$object)"
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

return Audit-AntiPhishPolicyOptimalConfiguration
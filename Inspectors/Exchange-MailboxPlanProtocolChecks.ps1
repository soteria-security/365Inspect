$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-MailboxPlanProtocolChecks{
try{
#Mailbox Plans
$finalobject = @()
$MailboxPlans = @()
$array = @("ActiveSyncEnabled","PopEnabled","ImapEnabled","EwsEnabled","MapiEnabled")
$MailboxPlan = Get-CASMailboxPlan | select Name #Define the Names
foreach ($Plan in $MailboxPlan){
$unit = Get-CASMailboxPlan $Plan.Name | Select Name,ActiveSyncEnabled,ImapEnabled,MAPIEnabled,PopEnabled,PopMessageDeleteEnabled,EwsEnabled
$MailboxPlans += $unit
}
foreach ($plan in $MailboxPlans){
$finalobject += $Plan.Name
foreach ($object in $Array){
if ($plan.$object -ne $false){
$object = "$($object): $($plan.$object)"
$finalobject += $object
}
}
}
if ($finalobject.Count -ne 0){
return $finalobject
}else{
return null
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
return Audit-MailboxPlanProtocolChecks
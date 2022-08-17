$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

function Audit-ConfigAnalyzerPolicyRecommendation{
try{
$finalobject = @()
$ConfigAnalyzerPolicyRecommendation = Get-ConfigAnalyzerPolicyRecommendation -RecommendedPolicyType Strict 
foreach ($recommendation in $ConfigAnalyzerPolicyRecommendation){
$finalobject += $recommendation.SettingName
}

if ($ConfigAnalyzerPolicyRecommendation.Count -ne 0){
Get-ConfigAnalyzerPolicyRecommendation -RecommendedPolicyType Strict | ft PolicyGroup,SettingName,SettingNameDescription,Recommendation | Out-File "$path\ConfigAnalyzerPolicyRecommendations.txt"
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
return Audit-ConfigAnalyzerPolicyRecommendation
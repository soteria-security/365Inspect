#Applies to CIS P2.6+2.7 and the URL https://soteria.io/azure-ad-default-configuration-blunders/ for extra audit material!
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-DURPAZAPPT2{
try{
$DURPAZAPPT2Data = @()
$DURPAZAPPT2 = Get-MsolCompanyInformation | select UsersPermissionToReadOtherUsersEnabled,UsersPermissionToCreateGroupsEnabled,UsersPermissionToUserConsentToAppEnabled
if ($DURPAZAPPT2.UsersPermissionToReadOtherUsersEnabled -match 'True' -or $DURPAZAPPT2.UsersPermissionToCreateGroupsEnabled -match 'True' -or $DURPAZAPPT2.UsersPermissionToUserConsentToAppEnabled -match 'True'){
foreach ($DURPAZAPPT2DataObj in $DURPAZAPPT2){
$DURPAZAPPT2Data += " UsersPermissionToReadOtherUsersEnabled: "+$DURPAZAPPT2.UsersPermissionToReadOtherUsersEnabled
$DURPAZAPPT2Data += "`n UsersPermissionToCreateGroupsEnabled: "+$DURPAZAPPT2.UsersPermissionToCreateGroupsEnabled
$DURPAZAPPT2Data += "`n UsersPermissionToUserConsentToAppEnabled: "+$DURPAZAPPT2.UsersPermissionToUserConsentToAppEnabled
}
return $DURPAZAPPT2Data
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
return Audit-DURPAZAPPT2
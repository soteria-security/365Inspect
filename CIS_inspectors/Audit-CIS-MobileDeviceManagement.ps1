#Applies to CIS: 7.2, 7.3, 7.4 , 7.5, 7.6, 7.7, 7.8, 7.9, 7.10
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Audit-CISMobileDeviceAudit{
try{
$CISMobileDeviceAuditData = @()
$CISMobileDevice = Get-MobileDeviceMailboxPolicy | select AlphanumericPasswordRequired,PasswordEnabled,PasswordRecoveryEnabled,AllowSimplePassword,MinPasswordLength,MaxPasswordFailedAttempts,PasswordExpiration,PasswordHistory,MinPasswordComplexCharacters,MaxInactivityTimeLock,DeviceEncryptionEnabled
if ($CISMobileDevice -ne $null){
if ($CISMobileDevice.AlphanumericPasswordRequired -match 'False'){
$CISMobileDeviceAuditData += "AlphanumericPasswordRequired: "+$CISMobileDevice.AlphanumericPasswordRequired
}
if ($CISMobileDevice.PasswordEnabled -match 'False'){
$CISMobileDeviceAuditData += "`n PasswordEnabled: "+$CISMobileDevice.PasswordEnabled
}
if($CISMobileDevice.PasswordRecoveryEnabled -match 'False'){
$CISMobileDeviceAuditData += "`n PasswordRecoveryEnabled: "+$CISMobileDevice.PasswordRecoveryEnabled
}
if($CISMobileDevice.AllowSimplePassword -match 'True'){
$CISMobileDeviceAuditData += "`n AllowSimplePassword: "+$CISMobileDevice.AllowSimplePassword
}
if($CISMobileDevice.MinPasswordLength -ile 5 -or $null){
$CISMobileDeviceAuditData += "`n MinPasswordLength: "+$CISMobileDevice.MinPasswordLength
}
if(!$CISMobileDevice.MaxPasswordFailedAttempts -ilt 10){
$CISMobileDeviceAuditData += "`n MaxPasswordFailedAttempts: "+$CISMobileDevice.MaxPasswordFailedAttempts
}
if(!$CISMobileDevice.PasswordExpiration -eq 'Unlimited'){
$CISMobileDeviceAuditData += "`n PasswordExpiration: "+$CISMobileDevice.PasswordExpiration
}
if($CISMobileDevice.PasswordHistory -ile 4){
$CISMobileDeviceAuditData += "`n PasswordHistory: "+$CISMobileDevice.PasswordHistory
}
if(!$CISMobileDevice.MinPasswordComplexCharacters -eq 1){
$CISMobileDeviceAuditData += "`n MinPasswordComplexCharacters: "+$CISMobileDevice.MinPasswordComplexCharacters
}
if(!$CISMobileDevice.MaxInactivityTimeLock -ile 5){
$CISMobileDeviceAuditData += "`n MaxInactivityTimeLock: "+$CISMobileDevice.MaxInactivityTimeLock
}
if($CISMobileDevice.DeviceEncryptionEnabled -match 'False'){
$CISMobileDeviceAuditData += "`n DeviceEncryptionEnabled: "+$CISMobileDevice.DeviceEncryptionEnabled
}
return $CISMobileDeviceAuditData
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
return Audit-CISMobileDeviceAudit
#Applies to: 7.2, 7.3, 7.4 , 7.5, 7.6, 7.7, 7.8, 7.9, 7.10
function Audit-CISMobileDeviceAudit{
$CISMobileDeviceAudit = ''
$CISMobileDevice = Get-MobileDeviceMailboxPolicy | select AlphanumericPasswordRequired,PasswordEnabled,PasswordRecoveryEnabled,AllowSimplePassword,MinPasswordLength,MaxPasswordFailedAttempts,PasswordExpiration,PasswordHistory,MinPasswordComplexCharacters,MaxInactivityTimeLock,DeviceEncryptionEnabled
if ($CISMobileDevice -ne $null){
if ($CISMobileDevice.AlphanumericPasswordRequired -match 'False'){
$CISMobileDeviceAudit += "AlphanumericPasswordRequired: "+$CISMobileDevice.AlphanumericPasswordRequired
}
if ($CISMobileDevice.PasswordEnabled -match 'False'){
$CISMobileDeviceAudit += "`n PasswordEnabled: "+$CISMobileDevice.PasswordEnabled
}
if($CISMobileDevice.PasswordRecoveryEnabled -match 'False'){
$CISMobileDeviceAudit += "`n PasswordRecoveryEnabled: "+$CISMobileDevice.PasswordRecoveryEnabled
}
if($CISMobileDevice.AllowSimplePassword -match 'True'){
$CISMobileDeviceAudit += "`n AllowSimplePassword: "+$CISMobileDevice.PasswordEnabled
}
if($CISMobileDevice.MinPasswordLength -ile 5 -or $null){
$CISMobileDeviceAudit += "`n MinPasswordLength: "+$CISMobileDevice.MinPasswordLength
}
if(!$CISMobileDevice.MaxPasswordFailedAttempts -ilt 10){
$CISMobileDeviceAudit += "`n MaxPasswordFailedAttempts: "+$CISMobileDevice.MaxPasswordFailedAttempts
}
if(!$CISMobileDevice.PasswordExpiration -eq 'Unlimited'){
$CISMobileDeviceAudit += "`n PasswordExpiration: "+$CISMobileDevice.PasswordExpiration
}
if($CISMobileDevice.PasswordHistory -ile 4){
$CISMobileDeviceAudit += "`n PasswordHistory: "+$CISMobileDevice.PasswordHistory
}
if(!$CISMobileDevice.MinPasswordComplexCharacters -eq 1){
$CISMobileDeviceAudit += "`n MinPasswordComplexCharacters: "+$CISMobileDevice.MinPasswordComplexCharacters
}
if(!$CISMobileDevice.MaxInactivityTimeLock -ile 5){
$CISMobileDeviceAudit += "`n MaxInactivityTimeLock: "+$CISMobileDevice.MaxInactivityTimeLock
}
if($CISMobileDevice.DeviceEncryptionEnabled -match 'False'){
$CISMobileDeviceAudit += "`n DeviceEncryptionEnabled: "+$CISMobileDevice.DeviceEncryptionEnabled
}
return $CISMobileDeviceAudit
}
return $null
}
return Audit-CISMobileDeviceAudit
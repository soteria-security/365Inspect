function Audit-MSTeamsSettings{
$MSTeamsSettingsData = @()
$MSTeamsSettings_1 = Get-CsTenantFederationConfiguration | select Identity,AllowedDomains,AllowPublicUsers
$MSTeamsSettings_2 = Get-CsExternalAccessPolicy -Identity Global
if ($MSTeamsSettings_1 -or $MSTeamsSettings_2 -ne $null){
if ($MSTeamsSettings_1.AllowedDomains -match 'AllowAllKnownDomains' -or $MSTeamsSettings_1.AllowPublicUsers -match 'True' -or $MSTeamsSettings_2.EnableFederationAccess -match 'True' -or $MSTeamsSettings_2.EnablePublicCloudAccess -match 'True'){
$MSTeamsSettingsData += " AllowedDomains: "+$MSTeamsSettings_1.AllowedDomains
$MSTeamsSettingsData += "`n AllowPublicUsers: "+$MSTeamsSettings_1.AllowPublicUsers
$MSTeamsSettingsData += " EnableFederationAccess: "+$MSTeamsSettings_2.EnableFederationAccess
$MSTeamsSettingsData += "`n EnablePublicCloudAccess: "+$MSTeamsSettings_2.EnablePublicCloudAccess
return $MSTeamsSettingsData
}
}
return $null
}
return Audit-MSTeamsSettings
function Audit-MSTeamsSettings{
$MSTeamsSettings_1 = Get-CsTenantFederationConfiguration | select Identity,AllowedDomains,AllowPublicUsers
$MSTeamsSettings_2 = Get-CsExternalAccessPolicy -Identity Global
if ($MSTeamsSettings_1.AllowedDomains -match 'AllowAllKnownDomains' -or $MSTeamsSettings_1.AllowPublicUsers -match 'True' -or $MSTeamsSettings_2.EnableFederationAccess -match 'True' -or $MSTeamsSettings_2.EnablePublicCloudAccess -match 'True'){
$MSTeamsSettings = $MSTeamsSettings_1+$MSTeamsSettings_2
return $MSTeamsSettings
}
return $null
}
return Audit-MSTeamsSettings
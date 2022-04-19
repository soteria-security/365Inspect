function Audit-MSTeamsSettingsFileSharingOptions{
$MSTeamsSettings_3 = Get-CsTeamsClientConfiguration | select allow*
if ($MSTeamsSettings_3.AllowDropBox -or $MSTeamsSettings_3.AllowGoogleDrive -or $MSTeamsSettings_3.AllowShareFile -or $MSTeamsSettings_3.AllowBox -or $MSTeamsSettings_3.AllowEgnyte -match 'True'){
return $MSTeamsSettings_3
}
return $null
}
return Audit-MSTeamsSettingsFileSharingOptions
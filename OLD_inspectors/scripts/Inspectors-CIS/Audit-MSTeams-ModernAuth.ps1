function Audit-MSTeams-ModernAuth{
$msteamsmodernauth = Get-CsOAuthConfiguration | select ClientAdalAuthOverride
if (!$msteamsmodernauth.ClientAdalAuthOverride -match 'Allowed'){
return $additionalstorageprovider
}
return $null
}
return Audit-MSTeams-ModernAuth
function Audit-MSTeams-ModernAuth{
$msteamsmodernauth = Get-CsOAuthConfiguration | select ClientAdalAuthOverride
if (!$msteamsmodernauth.ClientAdalAuthOverride -match 'Allowed'){
return 'msteamsmodernauth: '+$msteamsmodernauth.ClientAdalAuthOverride
}
return $null
}
return Audit-MSTeams-ModernAuth
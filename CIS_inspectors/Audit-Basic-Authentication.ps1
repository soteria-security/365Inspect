function Audit-Basic-Authentication{
$basicauthdata = @()
$basicauth1 = Get-OrganizationConfig | Select-Object -ExpandProperty DefaultAuthenticationPolicy | ForEach { Get-AuthenticationPolicy $_ | Select- Object AllowBasicAuth* }
$basicauth2 = Get-OrganizationConfig | Select-Object DefaultAuthenticationPolicy
$basicauth3 = Get-User -ResultSize Unlimited | Select-Object UserPrincipalName, AuthenticationPolicy
if($basicauth1.DefaultAuthenticationPolicy -contains "" -and $basicauth2.DefaultAuthenticationPolicy -contains "" -and $basicauth3.AuthenticationPolicy -contains ""){
foreach ($basicauthuser in $basicauth3){
$basicauthdata += "$($basicauth3.UserPrincipalName), $($basicauth3.AuthenticationPolicy)"
}
return $basicauthdata
}
return $null
}
return Audit-Basic-Authentication
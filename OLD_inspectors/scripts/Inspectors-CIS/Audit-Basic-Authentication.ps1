function Audit-Basic-Authentication{
$basicauth1 = Get-OrganizationConfig | Select-Object -ExpandProperty DefaultAuthenticationPolicy | ForEach { Get-AuthenticationPolicy $_ | Select- Object AllowBasicAuth* }
$basicauth2 = Get-OrganizationConfig | Select-Object DefaultAuthenticationPolicy
$basicauth3 = Get-User -ResultSize Unlimited | Select-Object UserPrincipalName, AuthenticationPolicy
if($basicauth1.DefaultAuthenticationPolicy -contains "" -and $basicauth2.DefaultAuthenticationPolicy -contains "" -and $basicauth3.AuthenticationPolicy -contains ""){
return $basicauth1 + $basicauth2 + $basicauth3
}
if($basicauth1.DefaultAuthenticationPolicy -contains "" -and $basicauth2.DefaultAuthenticationPolicy -contains "" -and !$basicauth3.AuthenticationPolicy -contains ""){
return $basicauth1 + $basicauth2
}
if($basicauth1.DefaultAuthenticationPolicy -contains "" -and !$basicauth2.DefaultAuthenticationPolicy -contains "" -and $basicauth3.AuthenticationPolicy -contains ""){
return $basicauth1 + $basicauth3
}
if(!$basicauth1.DefaultAuthenticationPolicy -contains "" -and $basicauth2.DefaultAuthenticationPolicy -contains "" -and $basicauth3.AuthenticationPolicy -contains ""){
return $basicauth2 + $basicauth3
}
return $null
}
return Audit-Basic-Authentication
function Audit-ModernAuthentication{
$auditmodernauthentication = Get-OrganizationConfig | select Name,OAuth2ClientProfileEnabled
if (!$auditmodernauthentication.OAuth2ClientProfileEnabled -match 'True'){
return 'OAuth2ClientProfileEnabled: '+$auditmodernauthentication.OAuth2ClientProfileEnabled
}
return $null
}
return Audit-ModernAuthentication
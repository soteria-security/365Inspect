function Audit-ModernAuthentication{
$auditmodernauthentication = Get-OrganizationConfig | select Name,OAuth2ClientProfileEnabled
if (!$auditmodernauthentication.OAuth2ClientProfileEnabled -match 'True'){
return $auditmodernauthentication
}
return $null
}
return Audit-ModernAuthentication
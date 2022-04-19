function Audit-SharepointLegacyAuthChecker{
$splegacyauth = Get-SPOTenant | select LegacyAuthProtocolsEnabled
if ($splegacyauth.LegacyAuthProtocolsEnabled -match 'True'){
return 'LegacyAuthProtocolsEnabled: '+$splegacyauth.LegacyAuthProtocolsEnabled
}
return $null
}
return Audit-SharepointLegacyAuthChecker
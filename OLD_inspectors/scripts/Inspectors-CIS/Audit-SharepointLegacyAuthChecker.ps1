function Audit-SharepointLegacyAuthChecker{
$splegacyauth = Get-SPOTenant | select LegacyAuthProtocolsEnabled
if ($splegacyauth.LegacyAuthProtocolsEnabled -match 'True'){
return $splegacyauth
}
return $null
}
return Audit-SharepointLegacyAuthChecker
function Audit-AnonymousLinksExpireSP{
$AnonymousLinksExpireSP = Get-SPOTenant | select RequireAnonymousLinksExpireInDays
if ($AnonymousLinksExpireSP.RequireAnonymousLinksExpireInDays -eq -1){
return 'RequireAnonymousLinksExpireInDays: '+ $AnonymousLinksExpireSP.RequireAnonymousLinksExpireInDays
}
return $null
}
return Audit-AnonymousLinksExpireSP
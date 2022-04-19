function Audit-AnonymousLinksExpireSP{
$AnonymousLinksExpireSP = Get-SPOTenant | select RequireAnonymousLinksExpireInDays
if ($AnonymousLinksExpireSP.RequireAnonymousLinksExpireInDays -eq -1){
return $AnonymousLinksExpireSP
}
return $null
}
return Audit-AnonymousLinksExpireSP

Connect-SPOService -Url https://astercomputers-admin.sharepoint.com
$audit = Get-SPOTenant | select RequireAnonymousLinksExpireInDays
if ($audit.RequireAnonymousLinksExpireInDays -eq -1){'Anonymous Sharing Links are not set to expire'}else{'Anonymous Sharing Links expire in:'+$audit.RequireAnonymousLinksExpireInDays+'Days'}
Disconnect-SPOService
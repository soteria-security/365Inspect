function Audit-SA4SPODMST{
$SA4SPODMST = Get-AtpPolicyForO365 | select Name,EnableATPForSPOTeamsODB
if (-NOT $SA4SPODMST.EnableATPForSPOTeamsODB -match 'True'){
return 'EnableATPForSPOTeamsODB: '+$SA4SPODMST.EnableATPForSPOTeamsODB
}
return $null
}
return Audit-SA4SPODMST

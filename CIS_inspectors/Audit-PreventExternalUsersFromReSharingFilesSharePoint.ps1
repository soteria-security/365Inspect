function Audit-PEUFRSFSP{
$PEUFRSFSP = Get-SPOTenant | select PreventExternalUsersFromResharing 
if ($PEUFRSFSP.PreventExternalUsersFromResharing -match 'False'){
return 'PreventExternalUsersFromResharing: '+$PEUFRSFSP.PreventExternalUsersFromResharing
}
return $null
}
return Audit-PEUFRSFSP
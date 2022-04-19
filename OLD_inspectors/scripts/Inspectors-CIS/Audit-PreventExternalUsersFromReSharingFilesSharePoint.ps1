function Audit-PEUFRSFSP{
$PEUFRSFSP = Get-SPOTenant | select PreventExternalUsersFromResharing 
if ($PEUFRSFSP.PreventExternalUsersFromResharing -match 'False'){
return $additionalstorageprovider
}
return $null
}
return Audit-PEUFRSFSP
function Audit-GlobalAdmins{
$rolegba = Get-MsolRole -RoleName "Company Administrator" 
$count = (Get-MsolRoleMember -RoleObjectId $rolegba.objectid).Count
if ($count -ile 1 -or $count -igt 4){
return $additionalstorageprovider
}
return $null
}
return Audit-GlobalAdmins
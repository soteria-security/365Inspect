function Inspect-ProperAdminCount {
	$global_admins = (Get-MsolRoleMember -RoleObjectId (Get-MsolRole -RoleName "Company Administrator").ObjectId).EmailAddress
	$num_global_admins = $global_admins.Count

	If (($num_global_admins -lt 2) -or ($num_global_admins -gt 4)) {
		return $global_admins
	}
	
	return $null
}

return Inspect-ProperAdminCount
#Checks if there are users that do not have MFA active. 
function Audit-MFAUsers{
$auditmfausers = (Get-MsolUser -all | select DisplayName,UserPrincipalName,@{N='MFAStatus'; E={if($_.StrongAuthenticationRequirements.Count -ne 0){$_.StrongAuthenticationRequirements[0].State} else {'Disabled'}}} | Where{$_.MFASTATUS -eq 'Disabled'})
if ($auditmfausers.Count -igt 0){
return $auditmfausers
}
return $null
}
return Audit-MFAUsers
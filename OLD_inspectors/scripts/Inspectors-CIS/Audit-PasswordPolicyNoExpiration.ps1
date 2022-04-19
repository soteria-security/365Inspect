function Audit-PasswordPolicyNoExpiration{
$ppnoexpire = Get-MsolPasswordPolicy -DomainName "$org_name.onmicrosoft.com"
if (-NOT $ppnoexpire.ValidityPeriod -eq 2147483647){
return @($org_name)
}
return $null
}
return Audit-PasswordPolicyNoExpiration
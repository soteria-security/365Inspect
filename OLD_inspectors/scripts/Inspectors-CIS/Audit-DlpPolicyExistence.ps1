function Audit-DLPPolicyExistence{
$dlppolicy = Get-DlpPolicy 
if ($dlppolicy -eq $null){
return $dlppolicy
}
return $null
}
return Audit-DLPPolicyExistence
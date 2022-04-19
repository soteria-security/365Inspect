function Audit-DLPPolicyExistence{
$dlppolicy = Get-DlpPolicy 
if ($dlppolicy -eq $null){
return 'No DLP Policy Existing!: '+$dlppolicy
}
return $null
}
return Audit-DLPPolicyExistence
function Inspect-MailboxesWithPOPEnabled {
	# Query Security defaults to see if it's enabled. If it is, skip this check.
	$secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
    If ($secureDefault.IsEnabled -eq $false){
		$pop = (Get-CasMailbox -ResultSize Unlimited | Where-Object { $_.PopEnabled }).Name
	}
	
	If ($pop.Count -NE 0) {
		return $pop
	}
	
	return $null
}

return Inspect-MailboxesWithPOPEnabled
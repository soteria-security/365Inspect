function Inspect-MailboxesWithIMAPEnabled {
	# Query Security defaults to see if it's enabled. If it is, skip this check.
	$secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
    If ($secureDefault.IsEnabled -eq $false){
		return (Get-CasMailbox -ResultSize Unlimited | Where-Object {$_.ImapEnabled}).Name
	}
}

return Inspect-MailboxesWithIMAPEnabled
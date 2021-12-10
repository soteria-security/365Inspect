function Inspect-ExecutableAttachments {
	$rules = Get-TransportRule
	$action1 = "Microsoft.Exchange.MessagingPolicies.Rules.Tasks.DeleteMessageAction"
	$action2 = "Microsoft.Exchange.MessagingPolicies.Rules.Tasks.RejectMessageAction"
    $flag = $False

	ForEach ($rule in $rules) {
		If (($rule.AttachmentHasExecutableContent -eq $true) -and (($rule.Actions -contains $action1) -or ($rule.Actions -contains $action2) -or ($rule.DeleteMessage -eq $true))) {
			$flag = $True
		}
	}

	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-ExecutableAttachments
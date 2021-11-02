function Inspect-ExecutableAttachments {
	$rules = Get-TransportRule
	$action = @("Microsoft.Exchange.MessagingPolicies.Rules.Tasks.DeleteMessageAction","Microsoft.Exchange.MessagingPolicies.Rules.Tasks.RejectMessageAction")
    $flag = $False

	ForEach ($rule in $rules) {
		If (($rule.AttachmentHasExecutableContent -eq $true) -and ($action -contains $rule.Actions)) {
			$flag = $True
		}
	}

	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-ExecutableAttachments
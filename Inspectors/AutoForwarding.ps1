function Inspect-AutoForwarding {
	$rules = Get-TransportRule
	$flag = $False

	ForEach ($rule in $rules) {
		If (($rule.MessageTypeMatches -eq "AutoForward") -AND ($rule.DeleteMessage -OR $rule.RejectMessageReasonText)) {
			$flag = $True
		}
	}

	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-AutoForwarding
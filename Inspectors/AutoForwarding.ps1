function Inspect-AutoForwarding {
	$rules = Get-TransportRule
	$flag = $False

	ForEach ($rule in $rules) {
		If (($rule.IfMessageTypeMatches -eq "AutoForward") -AND ($rule.DeleteMessage -OR $rule.RejectMessage)) {
			$flag = $True
		}
	}

	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-AutoForwarding
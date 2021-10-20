$path = @($out_path)

Function Inspect-MailFlowRules {
	$rules = Get-TransportRule

	ForEach ($rule in $rules) {
		$rule | Format-List | Out-File -FilePath "$($path)\$($rule.Name)_Mail-Flow-Rule.txt"
	}
}

return Inspect-MailFlowRules
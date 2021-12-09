$path = @($out_path)

Function Inspect-MailFlowRules {
	$rules = Get-TransportRule

	If ($rules.count -gt 0) {
		$path = New-Item -ItemType Directory -Force -Path "$($path)\Mail-Flow-Rules"

		ForEach ($rule in $rules) {
			$name = $rule.Name

            $pattern = '[\\/]'

            $name = $name -replace $pattern, '-'

			$name

			$rule | Format-List | Out-File -FilePath "$($path)\$($name)_Mail-Flow-Rule.txt"
		}
	}
}

return Inspect-MailFlowRules
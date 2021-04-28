function Inspect-LargeAttachmentBlockingRule {
	$rules = Get-TransportRule
	$flag = $False

	ForEach ($rule in $rules) {
		if ($rule.AttachmentSizeOver -AND ($rule.DeleteMessage -OR $rule.RejectMessage)) {
			$flag = $True
		}
	}
	
	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-LargeAttachmentBlockingRule
function Inspect-LargeAttachmentBlockingRule {
	$rules = Get-TransportRule
	$flag = $False

	ForEach ($rule in $rules) {
		if (($rule.AttachmentSizeOver -like "*") -AND (($rule.DeleteMessage -ne $false) -OR ($null -ne $rule.RejectMessageReasonText))) {
			$flag = $True
		}
	}
	
	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-LargeAttachmentBlockingRule
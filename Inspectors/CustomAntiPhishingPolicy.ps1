function Inspect-CustomAntiPhishingPolicy {
	If (-NOT (Get-AntiPhishPolicy | Where-Object {!$_.IsDefault})) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-CustomAntiPhishingPolicy
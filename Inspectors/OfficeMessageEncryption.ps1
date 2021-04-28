function Inspect-OfficeMessageEncryption {
	If (-NOT (Get-IRMConfiguration).AzureRMSLicensingEnabled) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-OfficeMessageEncryption
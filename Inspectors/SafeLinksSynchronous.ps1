function Inspect-SafeLinksSynchronous {
	Try {
		$synchronous = Get-SafeLinksPolicy | Where { $_.IsEnabled -AND $_.DeliverMessageAfterScan }		
		If ($synchronous.Count -eq 0) {
			return @($org_name)
		}
	} Catch [System.Management.Automation.CommandNotFoundException] {
		return $null
	}
	
	return $null
}

return Inspect-SafeLinksSynchronous
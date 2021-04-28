function Inspect-IframesAreSpam {
	If (-NOT (Get-HostedContentFilterPolicy).MarkAsSpamFramesInHtml) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-IframesAreSpam
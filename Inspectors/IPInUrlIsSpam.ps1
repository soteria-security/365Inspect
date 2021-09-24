function Inspect-IPInUrlIsSpam {
	If (-NOT (Get-HostedContentFilterPolicy).IncreaseScoreWithNumericIps) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-IPInUrlIsSpam
function Inspect-ExternalForwarding {
    $externalForwarding = Get-HostedOutboundSpamFilterPolicy

    If ($externalForwarding.AutoForwardingMode -eq "On") {
        Return @($org_name)
        }
	Return $null
    }

return Inspect-ExternalForwarding
function Inspect-ExternalForwarding {
    $externalForwarding = Get-HostedOutboundSpamFilterPolicy | Select-Object autoforwardingmode

    If (!$externalForwarding -eq "On") {
        Return $null
        }
	Return @($org_name)
    }

return Inspect-ExternalForwarding
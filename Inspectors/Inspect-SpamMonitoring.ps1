function Inspect-SpamMonitoring {
    $spamMonitoring = Get-HostedOutboundSpamFilterPolicy | Select-Object BccSuspiciousOutboundMail

    If ($spamMonitoring -eq $true) {
        Return $null
        }
	Return @($org_name)
    }

return Inspect-SpamMonitoring
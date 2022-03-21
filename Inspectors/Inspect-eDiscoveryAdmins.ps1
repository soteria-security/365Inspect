Function Inspect-eDiscoveryAdmins {
	$eDiscoveryAdmins = Get-eDiscoveryCaseAdmin

    if ($null -ne $eDiscoveryAdmins){
        Return $eDiscoveryAdmins.Name
    }
    Return $null
}
return Inspect-eDiscoveryAdmins
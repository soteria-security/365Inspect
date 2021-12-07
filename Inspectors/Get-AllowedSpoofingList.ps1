$path = @($out_path)

function Get-AllowedSpoofingList {
	$Objects = Get-TenantAllowBlockListSpoofItems | Where-Object {$_.Action -eq "Allow"}
    $sendingInfrastructure = @()

    If ($Objects.Count -ne 0){
        ForEach ($Object in $Objects) {
            $Object | Export-Csv -Path "$($path)\AllowedSpoofingList.csv" -NoTypeInformation -Append
            $sendingInfrastructure += $Object.SendingInfrastructure
        }
        Return $sendingInfrastructure
    }
	
	return $null
}

return Get-AllowedSpoofingList
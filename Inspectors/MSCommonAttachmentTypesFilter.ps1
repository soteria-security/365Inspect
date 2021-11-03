function Inspect-MSCommonAttachmentTypesFilter {
	# These file types are from Microsoft's default definition of the common attachment types filter.
	$common_file_types = @("ace", "ani", "app", "docm", "exe", "jar", "reg", "scr", "vbe", "vbs")
	$unfiltered_file_types = @()
	$malware_filters = Get-MalwareFilterPolicy

	If ($malware_filters.count -gt 1){
        ForEach ($filter in $malware_filters) {
            ForEach ($common_file_type in $common_file_types) {
                If (($filter.FileTypes -notcontains $common_file_type) -and ($filter.EnableFileFilter -eq $true)) {
                    $unfiltered_file_types += $common_file_type
					$name = $filter.name
                }
            }
        }
		if ($unfiltered_file_types.count -gt 0){
			return "FileTypes not filtered: $unfiltered_file_types, Filter name: $name"
		}
		Else {
			Return $null
		}
    }
    Else {
        If ($malware_filters.EnableFileFilter -eq $false) {
            Return $malware_filters.Name
            }
        Else {
            ForEach ($common_file_type in $common_file_types) {
                If ($malware_filters.FileTypes -notcontains $common_file_type) {
                    $unfiltered_file_types += $common_file_type
                }
            }
            return $unfiltered_file_types
        }
    }
	
	return $null
}

return Inspect-MSCommonAttachmentTypesFilter
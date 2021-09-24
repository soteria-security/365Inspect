function Inspect-MSCommonAttachmentTypesFilter {
	# These file types are from Microsoft's default definition of the common attachment types filter.
	$common_file_types = @("ace", "ani", "app", "docm", "exe", "jar", "reg", "scr", "vbe", "vbs")
	$unfiltered_file_types = @()
	$malware_filters = Get-MalwareFilterPolicy | Where-Object -FilterScript {!$_.EnableFileFilter}

	ForEach ($common_file_type in $common_file_types) {
		$file_type_filtered = $false
		ForEach ($filter in $malware_filters) {
			If ($filter.FileTypes -contains $common_file_type) {
				$file_type_filtered = $true
			}
		}
		If (-NOT $file_type_filtered) {
			$unfiltered_file_types += $common_file_type
		}
	}
	
	If ($unfiltered_file_types.Count -NE 0) {
		return $unfiltered_file_types
	}
	
	return $null
}

return Inspect-MSCommonAttachmentTypesFilter
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-MaliciousAttachmentTypesFilter {
Try {

	# These file types are known to be used for malicious purposes.
    $malicious_file_types = @("xll", "wll", "rtf", "reg", "pif", "msi", "gadget", "application", "com", "cpl", "msc", "hta", "msp", "bat", "cmd", "js", "jse", "ws", "wsf", "vb", "wsc", "wsh", "msh", "msh1", "msh2", "mshxml", "msh1xml", "msh2xml", "ps1", "ps1xml", "ps2", "ps2xml", "psc1", "psc2", "scf", "lnk", "inf", "dotm", "xlsm", "xltm", "xlam", "pptm", "potm", "ppam", "ppsm", "sldm")
	$unfiltered_file_types = @()
	$malware_filters = Get-MalwareFilterPolicy | Where-Object {$_.Name -notlike "*Preset*"}
    $resultingPolicies = @()
    $remediatedPolicies = @()
    $filteredExtensions = @()

	If ($malware_filters.count -gt 0){
        ForEach ($filter in $malware_filters) {
            ForEach ($malicious_file_type in $malicious_file_types) {
                If (($filter.FileTypes -notcontains $malicious_file_type) -and ($filter.EnableFileFilter -eq $true)) {
                    $unfiltered_file_types += $malicious_file_type
					$name = $filter.name
                }
                If (($filter.FileTypes -contains $malicious_file_type) -and ($filter.EnableFileFilter -eq $true)) {
                    $filteredExtensions += $malicious_file_type
					$name = $filter.name
                }
            }
            If ($null -eq (Compare-Object -ReferenceObject $filteredExtensions -DifferenceObject $malicious_file_types)){
                $remediatedPolicies += $filter.name
            }
        }
		if ($unfiltered_file_types.count -gt 0){
			$resultingPolicies += "File Types not filtered: $($unfiltered_file_types -join ", " | Select-Object -Unique); Filter name: $name"
		} Else {
			Return $null
		}
    } Else {
        If ($malware_filters.EnableFileFilter -eq $false) {
            Return $malware_filters.Name
            } Else {
            ForEach ($malicious_file_type in $malicious_file_types) {
                If ($malware_filters.FileTypes -notcontains $malicious_file_type) {
                    $unfiltered_file_types += $malicious_file_type
                }
            }
            return $($unfiltered_file_types | Select-Object -Unique)
        }
    }
	
    If ((($resultingPolicies | Measure-Object).Count -gt 0) -and (($remediatedPolicies | Measure-Object).Count -eq 0)){
        return $resultingPolicies
    } Elseif (($remediatedPolicies | Measure-Object).Count -gt 0){
        return $null
    }
}
Catch {
Write-Warning "Error message: $_"
$message = $_.ToString()
$exception = $_.Exception
$strace = $_.ScriptStackTrace
$failingline = $_.InvocationInfo.Line
$positionmsg = $_.InvocationInfo.PositionMessage
$pscommandpath = $_.InvocationInfo.PSCommandPath
$failinglinenumber = $_.InvocationInfo.ScriptLineNumber
$scriptname = $_.InvocationInfo.ScriptName
Write-Verbose "Write to log"
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $strace
Write-Verbose "Errors written to log"
}

}

return Inspect-MaliciousAttachmentTypesFilter
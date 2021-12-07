$path = @($out_path)

Function Inspect-MSTeamsExternalAccessPolicy {
	Try {
		$rules = Get-CsExternalAccessPolicy 

		$rules | Out-File -FilePath "$($path)\Teams-External-Access-Policies.txt"

		Return $rules.identity
	}
	Catch {
        Write-Warning -Message "Error processing request. Manual verification required."
        Return "Error processing request."
        }
}
return Inspect-MSTeamsExternalAccessPolicy
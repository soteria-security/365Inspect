function Inspect-SelfServePasswordReset {
	$self_serve_reset_enabled = $(Get-MsolCompanyInformation).SelfServePasswordResetEnabled

	If (-NOT $self_serve_reset_enabled) {
		return @($org_name)
	}
	
	return $null
}

return Inspect-SelfServePasswordReset
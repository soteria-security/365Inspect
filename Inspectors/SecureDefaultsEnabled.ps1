<#
.Synopsis
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
.Description
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
.Inputs
    None
.Component
    Microsoft Graph PowerShell Module
.Role
    Scope for Policy.Read.All is required
.Functionality
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
#>


function Inspect-SecureDefaults {
    $secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
    $enabled = "Secure Defaults Enabled on this Tenant"
    $disabled = "Secure Defaults Not Enabled on this Tenant."
    If ($secureDefault.IsEnabled -eq $true){
        return $enabled
    }
    Else{
        return $disabled
    }
	
	return $null
}

Inspect-SecureDefaults
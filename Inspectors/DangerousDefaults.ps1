<#
.Synopsis
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
.Description
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
.Inputs
    None
.Component
    PowerShell
.Role
    Secuirty Reader Rights Required
.Functionality
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
#>


function Inspect-DangerousDefaults {
    #Define Dangerous Defaults
    $permissions = Get-MsolCompanyInformation
    $authPolicy = Get-AzureADMSAuthorizationPolicy

    If (($permissions.UsersPermissionToReadOtherUsersEnabled -eq $true) -or ($permissions.UsersPermissionToCreateGroupsEnabled -eq $true) -or ($authPolicy.AllowEmailVerifiedUsersToJoinOrganization -eq $true)){
        return @($org_name)
    }
	
	return $null
}

return Inspect-DangerousDefaults
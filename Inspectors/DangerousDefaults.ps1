$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


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
Try {

    $permissions = (Get-MgPolicyAuthorizationPolicy).defaultuserrolepermissions
    $authPolicy = Get-MgPolicyAuthorizationPolicy

    $dangerousDefaults = @()


    If ($permissions.AllowedToReadOtherUsers -eq $true) {
        $dangerousDefaults += "Users can read all attributes in Azure AD"
    }
    if ($permissions.AllowedToCreateSecurityGroups -eq $true){
        $dangerousDefaults += "Users can create security groups"
    }
    if ($permissions.AllowedToCreateApps -eq $true){
        $dangerousDefaults += "Users are allowed to create and register applications"
    }
    if ($authPolicy.AllowEmailVerifiedUsersToJoinOrganization -eq $true){
        $dangerousDefaults += "Users with a verified mail domain can join the tenant"
    }
    if ($authPolicy.AllowInvitesFrom -like "everyone"){
        $dangerousDefaults += "Guests can invite other guests into the tenant"
    }

    If ($dangerousDefaults.count -ne 0){
        Return $dangerousDefaults
    }
	
	return $null

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
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
Write-Verbose "Errors written to log"
}

}

return Inspect-DangerousDefaults



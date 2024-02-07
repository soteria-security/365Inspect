$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Inspect-DangerousDefaults {
    Try {
        $permissions = (Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/beta/policies/AuthorizationPolicy").Value.defaultUserRolePermissions
        $authPolicy = (Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/beta/policies/AuthorizationPolicy").Value
        $caPolicy = (Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/v1.0/policies/conditionalAccessPolicies").Value | Where-Object { $_.Conditions.Applications.IncludeApplications -eq '797f4846-ba00-4fd7-ba43-dac1f8f63013' }
        $tenantCreation = $permissions.allowedToCreateTenants

        $dangerousDefaults = @()


        If (! $caPolicy) {
            $dangerousDefaults += "No Conditional Access Policy exists to restrict non-administrator access to Azure Active Directory or Entra."
        }
        foreach ($policy in $caPolicy) {
            If ($policy.State -eq 'disabled') {
                $dangerousDefaults += "Conditional Access Policy ($($policy.displayName)) to restrict non-administrator access to Azure Active Directory or Entra exists in a disabled state."
            }
            ElseIf ($policy.State -eq 'enabledForReportingButNotEnforced') {
                $dangerousDefaults += "Conditional Access Policy ($($policy.displayName)) to restrict non-administrator access to Azure Active Directory or Entra exists in a report-only state."
            }
        }
        If ($permissions.AllowedToReadOtherUsers -eq $true) {
            $dangerousDefaults += "Users can read all attributes in Azure AD"
        }
        if ($permissions.AllowedToCreateSecurityGroups -eq $true) {
            $dangerousDefaults += "Users can create security groups"
        }
        if ($permissions.AllowedToCreateApps -eq $true) {
            $dangerousDefaults += "Users are allowed to create and register applications"
        }
        if ($authPolicy.AllowEmailVerifiedUsersToJoinOrganization -eq $true) {
            $dangerousDefaults += "Users with a verified mail domain can join the tenant"
        }
        if ($authPolicy.AllowInvitesFrom -like "everyone") {
            $dangerousDefaults += "Guests can invite other guests into the tenant"
        }
        if ($tenantCreation -eq $true) {
            $dangerousDefaults += "Users are allowed to create new Azure Active Directory Tenants."
        }
        If ($dangerousDefaults.count -ne 0) {
            Return $dangerousDefaults
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

return Inspect-DangerousDefaults
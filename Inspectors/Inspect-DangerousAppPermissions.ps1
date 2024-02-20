$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

Function Inspect-DangerousAppPermissions {
    Try {
        <# 
            API Permissions used by 'Midnight Blizzard' to compromise Microsoft the week of 1/12/2024
            '06b708a9-e830-4db3-a914-8e69da51d44f' = 'AppRoleAssignment.ReadWrite.All';
            '9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8' = 'RoleManagement.ReadWrite.Directory';
        #>

        $permissionList = @{
            '06b708a9-e830-4db3-a914-8e69da51d44f' = 'AppRoleAssignment.ReadWrite.All';
            '9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8' = 'RoleManagement.ReadWrite.Directory';
        }
    
        $registeredApps = @()
        Try {
            $query = (Invoke-GraphRequest -Method Get -Uri "https://graph.microsoft.com/beta/applications")
        }
        Catch {
            If ($_.Exception.Message -match "(429)") {
                $query = (Invoke-GraphRequest -Method Get -Uri "https://graph.microsoft.com/beta/applications")
            }
            Else {
                Return $_.Exception.Message
            }
        }
        $registeredApps += ($query).Value
        if ($query.'@odata.nextlink') {
            Try {
                $request = (Invoke-GraphRequest -Method Get -Uri "$($query.'@odata.nextlink')")
                $registeredApps += $request.Value
                while ($null -ne $request.'@odata.nextlink') {
                    $request = (Invoke-GraphRequest -Method Get -Uri "$($request.'@odata.nextlink')")
                    $registeredApps += $request.Value
                }
            }
            Catch {
                If ($_.Exception.Message -match "(429)") {
                    $request = (Invoke-GraphRequest -Method Get -Uri "$($query.'@odata.nextlink')")
                    $registeredApps += $request.Value
                    while ($null -ne $request.'@odata.nextlink') {
                        $request = (Invoke-GraphRequest -Method Get -Uri "$($request.'@odata.nextlink')")
                        $registeredApps += $request.Value
                    }
                }
                Else {
                    Return $_.Exception.Message
                }
            }
        }
    
        $orgTenant = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/organization").value.id
    
        $consents = @()
        
        $servicePrincipals = @()
    
        $query = (Invoke-GraphRequest -Method Get -Uri "https://graph.microsoft.com/beta/servicePrincipals?filter=servicePrincipalType eq 'Application'&count=true")
        
        $servicePrincipals += ($query).Value
        
        if ($query.'@odata.nextlink') {
            $request = (Invoke-GraphRequest -Method Get -Uri "$($query.'@odata.nextlink')")
            $servicePrincipals += $request.Value
            while ($null -ne $request.'@odata.nextlink') {
                $request = (Invoke-GraphRequest -Method Get -Uri "$($request.'@odata.nextlink')")
                $servicePrincipals += $request.Value
            }
        }
    
        # Add Service Principals (Primarily external apps/Enterprise Applications)
        $consents += ($servicePrincipals | Where-Object { (($_.publishedPermissionScopes.value -like "*AppRoleAssignment.ReadWrite.All*") -or ($_.publishedPermissionScopes.value -like "*RoleManagement.ReadWrite.Directory*")) }) 
    
        # Add Service Principals (Internal apps/Registered Applications)
        $consents += ($registeredApps | Where-Object { ($_.requiredResourceAccess.resourceAccess.type -eq 'Role') -and (($_.requiredResourceAccess.resourceAccess.id -eq '06b708a9-e830-4db3-a914-8e69da51d44f') -or ($_.requiredResourceAccess.resourceAccess.id -eq '9e3f62cf-ca93-4989-b6ce-bf83c28f9fe8')) }) 
    
        $results = @()
    
        foreach ($consent in $consents) {
            $result = [PSCustomObject]@{
                Name                       = $consent.displayName
                AppID                      = $consent.appId
                'Application Source'       = ''
                Assignment                 = ''
                Publisher                  = ''
                'Application Owner Tenant' = ''
                'API Permissions'          = ''
            }
    
            If ($consent.requiredResourceAccess) {
                $result.'Application Source' = 'Internal'
    
                $permissions = $consent.requiredResourceAccess
                $appPermissions = @()
    
                $sp = (Invoke-GraphRequest -Method Get -Uri "https://graph.microsoft.com/beta/servicePrincipals?filter=appId eq '$($consent.appId)'").value
    
                foreach ($permission in $permissions) {
                    If ($permission.resourceAccess.type -eq 'Role') {
                        foreach ($id in (($permission.resourceAccess | Where-Object { $_.type -eq 'Role' }).id)) {
                            if ($permissionList.Get_Item($id)) {
                                $appPermissions += $permissionList.Get_Item($id)
                            }
                        }
                    }
                }
    
                $result.Publisher = $sp.publisherName
                $result.'Application Owner Tenant' = $sp.appOwnerOrganizationId
                $result.'API Permissions' = $appPermissions
    
                If ($sp.AppRoleAssignmentRequired -eq $true) {
                    $result.Assignment = $true
                }
                Else {
                    $result.Assignment = $false
                }
            }
            ElseIf ($consent.publishedPermissionScopes) {
                $result.'Application Source' = 'External'
                $result.'Application Owner Tenant' = $consent.appOwnerOrganizationId
    
                $permissions = $consent.publishedPermissionScopes | Where-Object { $_.type -eq 'Admin' }
                $appPermissions = @()
    
                foreach ($permission in $permissions) {
                    if ($permissionList.Get_Item($permission.id)) {
                        $appPermissions += $permissionList.Get_Item($permission.id)
                    }
                }
    
                $result.Publisher = $consent.publisherName
                $result.'API Permissions' = $appPermissions
    
                If ($consent.AppRoleAssignmentRequired -eq $true) {
                    $result.Assignment = $true
                }
                Else {
                    $result.Assignment = $false
                }
            }
            If ([string]::IsNullOrWhiteSpace($result.Publisher)) {
                $result.Publisher = 'None'
            }
            If ((-NOT [string]::IsNullOrWhiteSpace($result.'API Permissions'))) {
                $results += "Application Name: $($result.Name); Publisher: $($result.Publisher); Application Source: $($result.'Application Source'); Assignment Required: $($result.Assignment); Application Owner Tenant: $($result.'Application Owner Tenant'); Tenant-wide Permissions: $($result.'API Permissions')"
            }
        }
    
        Return $results
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

Return Inspect-DangerousAppPermissions
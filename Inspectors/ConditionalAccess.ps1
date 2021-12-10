$path = @($out_path)

function Inspect-CAPolicies {
    $secureDefault = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy -Property IsEnabled | Select-Object IsEnabled
    $conditionalAccess = Get-AzureADMSConditionalAccessPolicy

	If ($secureDefault.IsEnabled -eq $true) {
        Return $null
    }
    ElseIf (($secureDefault.IsEnabled -eq $false) -and ($conditionalAccess.count -eq 0)) {
		return $false
	}
    else {
        $path = New-Item -ItemType Directory -Force -Path "$($path)\ConditionalAccess"
        
        Foreach ($policy in $conditionalAccess) {

            $name = $policy.DisplayName

            $pattern = '[\\/]'

            $name = $name -replace $pattern, '-'

            $result = New-Object psobject
            $result | Add-Member -MemberType NoteProperty -name Name -Value $policy.DisplayName -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name State -Value $policy.State -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedApps -Value $policy.conditions.applications.includeapplications -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name ExcludedApps -Value $policy.conditions.applications.excludeapplications -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedUserActions -Value $policy.conditions.includeuseractions -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedProtectionLevels -Value $policy.conditions.includeprotectionlevels -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedUsers -Value $policy.conditions.users.includeusers -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name ExcludedUsers -Value $policy.conditions.users.excludeusers -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedGroups -Value $policy.conditions.users.includegroups -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name ExcludedGroups -Value $policy.conditions.users.excludegroups -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedRoles -Value $policy.conditions.users.includeroles -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name ExcludedRoles -Value $policy.conditions.users.excluderoles -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedPlatforms -Value $policy.conditions.platforms.includeplatforms -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name ExcludedPlatforms -Value $policy.conditions.platforms.excludeplatforms -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedLocations -Value $policy.conditions.locations.includelocations -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name ExcludedLocations -Value $policy.conditions.locations.excludelocations -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name IncludedSignInRisk -Value $policy.conditions.SignInRiskLevels -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name ClientAppTypes -Value $policy.conditions.ClientAppTypes -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name GrantConditions -Value $policy.grantcontrols.builtincontrols -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name ApplicationRestrictions -Value $policy.sessioncontrols.ApplicationEnforcedRestrictions -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name CloudAppSecurity -Value $policy.sessioncontrols.CloudAppSecurity -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name SessionLifetime -Value $policy.sessioncontrols.signinfrequency -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name PersistentBrowser -Value $policy.sessioncontrols.PersistentBrowser -ErrorAction SilentlyContinue


            $result | Out-File -FilePath "$($path)\$($name)_Policy.txt"
        }
        Return $true
    }
}

return Inspect-CAPolicies
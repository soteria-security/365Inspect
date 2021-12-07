$path = @($out_path)

Function Inspect-AADRoles{
    $path = New-Item -ItemType Directory -Force -Path "$($path)\AzureAD-Roles"
    $roles =  Get-AzureADDirectoryRole
    $messages = @()
    foreach ($role in $roles) {
        $members = Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Select-Object CompanyName, Department, DisplayName, JobTitle, Mail 
        $members | Export-CSV "$($path)\$($role.DisplayName)_AzureDirectoryRoleMembers.csv" -Force -NoTypeInformation
        $message = Write-Output "$($role.DisplayName) - $(@($members).count) members found"
        $messages += $message
        Get-ChildItem $path | Where-Object {($_.Length -eq 0) -and ($_.Name -like "$($role.DisplayName)*.csv")} | Remove-Item
    }
    Return $messages
}

Return Inspect-AADRoles
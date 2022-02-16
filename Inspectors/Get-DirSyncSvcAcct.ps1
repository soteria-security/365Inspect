Function Get-DirSyncSvcAcct{
    $permissions = Get-MsolCompanyInformation

        If ($permissions.DirectorySynchronizationEnabled -eq $true) {
            $serviceAcct = $permissions.DirSyncServiceAccount
            return $serviceAcct
        }
    Return $null
}

Return Get-DirSyncSvcAcct


$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Get-DirSyncSvcAcct{
Try {

    $permissions = Get-MgOrganization

            If ($permissions.OnPremisesSyncEnabled -eq $true) {
            $directoryRole = Get-MgDirectoryRole | Where-Object {$_.DisplayName -eq "Directory Synchronization Accounts"} 
            $roleMembers =  Get-MgDirectoryRoleMember -DirectoryRoleId $directoryRole.Id
            $serviceAcct = Get-MgUser -UserId ($roleMembers).Id
            return $serviceAcct.DisplayName
        }
    Return $null

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

Return Get-DirSyncSvcAcct





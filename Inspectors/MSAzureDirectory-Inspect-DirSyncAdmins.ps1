$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-DirSyncAdmins{
Try {

	$path = New-Item -ItemType Directory -Force -Path "$($path)\DirSync"

	$adminRoles = Get-MgDirectoryRole | Where-Object {$_.DisplayName -like "*Administrator"}

	$allDirsyncAdmins = @()

	ForEach ($role in $adminRoles) {
		$roleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id

		Foreach ($user in $roleMembers) {
			$member = Get-MgUser -UserId $user.Id
			If ($member.OnPremisesSyncEnabled -eq $true){
				$dirsyncAdmins += "$role : $($member.UserPrincipalName)`n"
			}
		}

		If ($dirsyncAdmins.count -ne 0){
			$dirsyncAdmins | Out-File "$path\$($role.DisplayName).txt"
			$allDirsyncAdmins += $dirsyncAdmins
		}
	}
	
	If ($allDirsyncAdmins.count -ne 0){
		return $allDirsyncAdmins
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

Return Inspect-DirSyncAdmins



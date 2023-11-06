$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-DirSyncAdmins {
    Try {
        $dirsyncAdmins = @()

        $syncEnabled = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/organization").Value.onPremisesSyncEnabled
        
        If ($syncEnabled -eq $true) {
            $adminRoles = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/directoryRoles").Value | Where-Object { $_.displayName -match "Administrator" }

            foreach ($role in $adminRoles) {
                $members = (Invoke-GraphRequest -method get -uri "https://dod-graph.microsoft.us/beta/directoryRoles/$($role.id)/members").Value
                
                foreach ($user in $members) {
                    If ($user.onPremisesSyncEnabled -eq $true) {
                        $dirsyncAdmins += "$($user.displayName) - $($role.displayName)"
                    }
                }
            }
        }

        If ($dirsyncAdmins) {
            Return $dirsyncAdmins
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

Return Inspect-DirSyncAdmins
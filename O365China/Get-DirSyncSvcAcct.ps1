$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Get-DirSyncSvcAcct {
    Try {
        $syncEnabled = (Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/organization").Value.onPremisesSyncEnabled

        $syncSvcAccounts = @()
    
        If ($syncEnabled -eq $true) {
            $syncSvcAccount = (Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/users?filter=startswith(displayName, 'On-Premises')").Value
            
            Foreach ($acct in $syncSvcAccount) {
                $syncSvcAccounts += "$($acct.displayName) - $($acct.userPrincipalName)"
            }
        }
    
        If ($syncSvcAccounts) {
            Return $syncSvcAccounts
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

Return Get-DirSyncSvcAcct
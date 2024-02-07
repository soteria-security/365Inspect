$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

Function Inspect-AppPasswords {
    Try {
        $results = @()

        $apps = (Invoke-GraphRequest -Method Get -Uri "https://$(@($global:graphURI))/beta/applications").value | Where-Object { $null -ne $_.passwordCredentials.KeyId }
        
        ForEach ($app in $apps) {
            $result = [PSCustomObject]@{
                Name       = $app.displayName
                Credential = @()
            }

            $credentials = $app.passwordCredentials
            Foreach ($credential in $credentials) {
                $result.Credential += "CredentialName: $($credential.displayName) ValidFrom: $($credential.startDateTime) ValidTo: $($credential.endDateTime)"
            }

            $result.Credential = $result.Credential -join ', '
            $results += "$($result.Name) - $($result.Credential)"
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

Return Inspect-AppPasswords
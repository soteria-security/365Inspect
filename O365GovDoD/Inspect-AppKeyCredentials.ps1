$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

Function Inspect-AppKeyCredentials {
    Try {
        $results = @()

        $applications = @()

        $query = (Invoke-GraphRequest -Method Get -Uri "https://dod-graph.microsoft.us/beta/applications")
        
        $applications += ($query).Value
        
        if ($query.'@odata.nextlink') {
            $request = (Invoke-GraphRequest -Method Get -Uri "$($query.'@odata.nextlink')")
            $applications += $request.Value
            while ($null -ne $request.'@odata.nextlink') {
                $request = (Invoke-GraphRequest -Method Get -Uri "$($request.'@odata.nextlink')")
                $applications += $request.Value
            }
        }
        
        $applications = $applications | Where-Object { $_.keyCredentials.KeyId }

        ForEach ($app in $applications) {
            $result = [PSCustomObject]@{
                Name       = $app.displayName
                AppId      = $app.appId
                Credential = @()
            }

            $credentials = $app.keyCredentials

            Foreach ($credential in $credentials) {
                $result.Credential += "CredentialName: $($credential.displayName), Type: $($credential.type), Usage: $($credential.usage), ValidFrom: $($credential.startDateTime), ValidTo: $($credential.endDateTime)"
            }

            $result.Credential = $result.Credential -join '; '
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

Return Inspect-AppKeyCredentials
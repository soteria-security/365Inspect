$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

Function Inspect-ServicePrincipalPasswordCredentials {
    Try {
        $results = @()

        $servicePrincipals = @()

        $query = (Invoke-GraphRequest -Method Get -Uri "https://graph.microsoft.com/beta/servicePrincipals")

        $servicePrincipals += ($query).Value

        if ($query.'@odata.nextlink') {
            $request = (Invoke-GraphRequest -Method Get -Uri "$($query.'@odata.nextlink')")
            $servicePrincipals += $request.Value
            while ($null -ne $request.'@odata.nextlink') {
                $request = (Invoke-GraphRequest -Method Get -Uri "$($request.'@odata.nextlink')")
                $servicePrincipals += $request.Value
            }
        }

        $servicePrincipals = $servicePrincipals | Where-Object { $_.passwordCredentials.KeyId }

        ForEach ($sp in $servicePrincipals) {
            $result = [PSCustomObject]@{
                Name                  = $sp.displayName
                ServicePrincipalType  = $sp.servicePrincipalType
                AssociatedApplication = $sp.appDisplayName
                AppId                 = $sp.appId
                Credential            = @()
            }

            $credentials = $sp.passwordCredentials

            Foreach ($credential in $credentials) {
                $result.Credential += "CredentialName: $($credential.displayName), ValidFrom: $($credential.startDateTime), ValidTo: $($credential.endDateTime)"
            }

            $result.Credential = $result.Credential -join '; '
            $results += "ServicePrincipal: $($result.Name), Type: $($result.ServicePrincipalType), AssociatedApplication: $($result.AssociatedApplication), AppId: $($result.AppId) - $($result.Credential)"
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

Return Inspect-ServicePrincipalPasswordCredentials
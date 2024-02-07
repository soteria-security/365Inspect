$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

Function Inspect-AZPSModules {
    Try {
        $applications = @("Microsoft Graph Command Line Tools", "Microsoft Graph PowerShell", "Azure Active Directory PowerShell")

        $void = "No Service Principals Found"

        $aad = $false

        $graph = $false

        #Check for Service Prinicpals
        Foreach ($application in $applications) {
            Try {
                $app = (Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/beta/servicePrincipals?filter=displayName eq '$application'").Value
            }
            Catch {
                return $void
            }
            
            If ($null -ne $app) {
                if ($app.AppDisplayName -eq "Azure Active Directory PowerShell") {
                    $aad = $true
                }
                elseif ($app.AppDisplayName -eq "Microsoft Graph Command Line Tools") {
                    $graph = $true
                }
            }
        }

        $appAAD = "Azure Active Directory PowerShell is not configured"

        $appGraph = "Microsoft Graph Command Line Tools is not configured"

        $both = "Neither Azure Active Directory PowerShell nor Microsoft Graph Command Line Tools is configured"

        If ($aad -eq $false -and $graph -eq $false) {
            Return $both
        }
        elseif ($aad -eq $false -and $graph -eq $true) {
            Return $appAAD
        }
        elseif ($aad -eq $true -and $graph -eq $false) {
            Return $appGraph
        }
        else {
                
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

Return Inspect-AZPSModules
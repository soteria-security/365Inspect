$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

Function Inspect-AZPSAssignment {
    Try {
        $applications = @("Microsoft Graph Command Line Tools", "Microsoft Graph PowerShell", "Azure Active Directory PowerShell")

        $aad = $false

        $graph = $false

        #Check for Service Prinicpals
        Foreach ($application in $applications) {
            Try {
                $app = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/servicePrincipals?filter=displayName eq '$application'").Value
            }
            Catch {
                
            }
        
            If ($null -ne $app) {
                if ($app.DisplayName -eq 'Azure Active Directory PowerShell' -and $app.AppRoleAssignmentRequired -eq $true) {
                    $aad = $true
                }
                elseif ((($app.DisplayName -eq 'Microsoft Graph Command Line Tools') -or ($app.DisplayName -eq 'Microsoft Graph PowerShell')) -and $app.AppRoleAssignmentRequired -eq $true) {
                    $graph = $true
                }
            }
        }

        $appAAD = "Azure Active Directory PowerShell assignment is not required"

        $appGraph = "Microsoft Graph Command Line Tools (Formerly Microsoft Graph PowerShell) assignment is not required"

        $both = "Neither Azure Active Directory PowerShell nor Microsoft Graph Command Line Tools (Formerly Microsoft Graph PowerShell) assignment is required"

        If ($aad -eq $false -and $graph -eq $false) {
            Return $both
        }
        elseif ($aad -eq $false -and $graph -eq $true) {
            Return $appAAD
        }
        elseif ($aad -eq $true -and $graph -eq $false) {
            Return $appGraph
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

Return Inspect-AZPSAssignment
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

Function Inspect-LinkedInConnection {
    Try {
        $result = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.us/beta/servicePrincipals?filter=displayname eq 'O365 LinkedIn Connection'").Value

        If ($result.accountEnabled -and ($null -eq $result.tags)) {
            Return 'All users allowed to connect their work or school account with LinkedIn'
        }
        ElseIf ($result.accountEnabled -and ($null -ne $result.tags)) {
            $pattern = "^[0-9A-Za-z]{8}-[0-9A-Za-z]{4}-[0-9A-Za-z]{4}-[0-9A-Za-z]{4}-[0-9A-Za-z]{12}"
            $grpAssigned = ''

            ForEach ($tag in $result.tags) {
                If ($tag -match $pattern) {
                    $grpAssigned = $tag
                }
            }

            $group = (Invoke-GraphRequest -Method GET -Uri "https://graph.microsoft.us/beta/groups?filter=id eq '$grpAssigned'&select=displayName").Value.displayName
            
            Return "Members of the group $group are allowed to connect their work or school account with LinkedIn"
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

Return Inspect-LinkedInConnection
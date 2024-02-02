$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-MSTeamsFileSharing {
    Try {

        $configPolicies = Get-CsTeamsClientConfiguration

        $results = @()

        Foreach ($clientConfig in $configPolicies){
            $policyName = $clientConfig.Identity

            $result = New-Object psobject
            $result | Add-Member -MemberType NoteProperty -name AllowDropBox -Value $clientConfig.AllowDropBox -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name AllowBox -Value $clientConfig.AllowBox -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name AllowGoogleDrive -Value $clientConfig.AllowGoogleDrive -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name AllowShareFile -Value $clientConfig.AllowShareFile -ErrorAction SilentlyContinue
            $result | Add-Member -MemberType NoteProperty -name AllowEgnyte -Value $clientConfig.AllowEgnyte -ErrorAction SilentlyContinue

            $values = @()

            Foreach ($item in $result){
                If ($item -match $true){
                    $values += $item -join ','
                }

            if (($values | Measure-Object).Count -gt 0){
                $results += "Policy: $policyName ; Enabled file sharing options: $values"
                }
            }
        }

        If (($results | Measure-Object).Count -gt 0){
            Return $results
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

return Inspect-MSTeamsFileSharing
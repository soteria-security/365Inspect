$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


<#
.Synopsis
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
.Description
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
.Inputs
    None
.Component
    Microsoft Graph Command Line Tools Module
.Role
    Scope for Policy.Read.All is required
.Functionality
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
#>


function Inspect-SecureDefaults {
    Try {
        $conditionalAccess = (Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/policies/conditionalAccessPolicies" -ErrorAction Stop).Value

        If (($conditionalAccess | Measure-Object).Count -eq 0) {
            $SDCreationDate = "October 22, 2019"
            $tenantCreationDate = (Invoke-GraphRequest -Method Get -Uri "https://microsoftgraph.chinacloudapi.cn/beta/organization?select=createdDateTime").Value.CreatedDateTime
            $secureDefault = (Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/policies/identitySecurityDefaultsEnforcementPolicy" -ErrorAction Stop).IsEnabled
            $disabled = "Secure Defaults Not Enabled on this Tenant."
            $olderThan = "Tenant creation predates Secure Defaults, and as a result Secure Defaults is not enabled"
            If (([datetime]$tenantCreationDate -lt [datetime]$SDCreationDate) -and ($secureDefault.IsEnabled -eq $false)) {
                Return "$($secureDefault.IsEnabled): $olderThan"
            }
            elseif ($secureDefault.IsEnabled -eq $false) {
                return $null
            }
        }
        Else {
        
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

Return Inspect-SecureDefaults
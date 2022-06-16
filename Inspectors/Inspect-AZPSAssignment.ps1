$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


<#
.SYNOPSIS
    Check for Microsoft Azure Active Directory and Microsoft Graph PowerShell Service Prinicipals.
.DESCRIPTION
    This script checks for configured Service Prinicipals needed to secure access to Microsoft Azure Active Directory and Microsoft Graph PowerShell modules.  
.COMPONENT
    PowerShell, Azure Active Directory PowerShell Module, and sufficient rights to change Tenant settings
.ROLE
    Recommended to run as Global Admin or Application Admin
.FUNCTIONALITY
    Check for Microsoft Azure Active Directory and Microsoft Graph PowerShell Service Prinicipals.
#>


Function Inspect-AZPSAssignment {
Try {

    $appIds = @("1b730954-1685-4b74-9bfd-dac224a7b894","14d82eec-204b-4c2f-b7e8-296a70dab67e")

    $void = "No Service Principals Found"

    $aad = $false

    $graph = $false

    #Check for Service Prinicpals
    Foreach ($appId in $appIds){
        Try{
            $sp = Get-MgServicePrincipal -Filter "appId eq '$appId'"
            $app = Get-MgServicePrincipal -ServicePrincipalId $sp.Id
            }
        Catch{
            return $void
            }
        
        If ($null -ne $app){
            if ($app.appID -eq '1b730954-1685-4b74-9bfd-dac224a7b894' -and $app.AppRoleAssignmentRequired -eq $true){
                $aad = $true
            }
            elseif ($app.appID -eq '14d82eec-204b-4c2f-b7e8-296a70dab67e' -and $app.AppRoleAssignmentRequired -eq $true) {
                $graph = $true
            }
        }
    }

    $appAAD = "Azure Active Directory PowerShell is not assigned"

    $appGraph = "Microsoft Graph PowerShell is not assigned"

    $both = "Neither Azure Active Directory PowerShell or Microsoft Graph PowerShell are assigned"

    If ($aad -eq $false -and $graph -eq $false) {
        Return $both
        }elseif ($aad -eq $false -and $graph -eq $true) {
            Return $appAAD
        }elseif ($aad -eq $true -and $graph -eq $false) {
            Return $appGraph
        }else {
            Return $null
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
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
Write-Verbose "Errors written to log"
}

}

Return Inspect-AZPSAssignment



$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-FederationTrust{
Try {

    
    $federationTrust = Get-FederationTrust

    $federationTrust | Out-File "$path\FederationTrust_Configuration.txt"



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

Inspect-FederationTrust



<#
INVESTIGATIVE TIPS:
    - Review existing Federations. Identify unauthorized or unrecognized Federations then revoke them.
    - Threat actors can create unauthorized federations and use them to log into your tenant and perform actions. The user accounts used to do this will not appear in your directory, thereby allowing the threat actor to persist longer.
    - NOTE: This is a known SUNBURST TTP." 
#> 



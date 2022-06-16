$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Get-BasicAuthConfig {
Try {

    $authMethods = @("AllowBasicAuthActiveSync","AllowBasicAuthAutodiscover","AllowBasicAuthImap","AllowBasicAuthMapi","AllowBasicAuthOfflineAddressBook","AllowBasicAuthOutlookService","AllowBasicAuthPop","AllowBasicAuthReportingWebServices","AllowBasicAuthRest","AllowBasicAuthRpc","AllowBasicAuthSmtp","AllowBasicAuthWebServices","AllowBasicAuthPowershell")

    $authPolicy =  Get-AuthenticationPolicy

    $methods = @()
    foreach ($method in $authMethods){
        If ($authPolicy.$method -eq $true){
            $methods += $method
        }
    }
    If (!$methods){
    Return $null
    }

    Return $methods

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

Return Get-BasicAuthConfig



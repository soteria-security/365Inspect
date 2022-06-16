$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-DomainExpiration {
Try {

    $domains = Get-AcceptedDomain |  Where-Object {$_.Name -notlike "*.onmicrosoft.com"}

    $results = @()

    foreach ($domain in $domains.DomainName){
        $expDate = (Invoke-WebRequest "https://whois.com/whois/$domain" -UseBasicParsing | Select-Object -ExpandProperty RawContent | Select-String -Pattern "Registry Expiry Date: (.*)" -ErrorAction SilentlyContinue).Matches.Groups[1].Value

        $expDate = ($expDate).Split('T')[0]
        
        $today = Get-Date -Format yyyy/MM/dd

        If ($expDate -lt $today){
            $results += "$domain - $expDate"
        }
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
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
Write-Verbose "Errors written to log"
}

}

Return Inspect-DomainExpiration



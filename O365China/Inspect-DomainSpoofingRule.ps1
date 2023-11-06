$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-DomainSpoofingRule {
Try {

	$rules = Get-TransportRule
	$flag = $False
    $domains = (Get-AcceptedDomain).DomainName

    $disabledRules = @()

	ForEach ($domain in $domains) {
        ForEach ($rule in $rules) {    
            if (($rule.FromScope -eq "NotInOrganization") -AND ($rule.SenderDomainIs -contains $domain) -AND (($rule.DeleteMessage -eq $true) -OR ($null -ne $rule.RejectMessageReasonText) -OR ($rule.Quarantine -eq $true))) {
                $flag = $True
                if (($flag -eq $true) -AND ($rule.State -eq "Disabled")) {
                $disabledRules += "Rule `"$($rule.Identity)`" is disabled."
                }
            }
        }
    }
	
	If (($flag -eq $false) -and (($disabledRules | Measure-Object).Count -eq 0)) {
		return @($org_name)
	} elseif (($flag -eq $true) -and (($disabledRules | Measure-Object).Count -gt 0)) {
        Return $disabledRules
    }
	
	return $null

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

return Inspect-DomainSpoofingRule



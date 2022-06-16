$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-SimPhish {
Try {

	$rules = Get-TransportRule | Where-Object {($_.State -eq "Enabled") -and (($_.Identity -like "*phish*") -or ($null -ne $_.HeaderContainsMessageHeader) -or ($_.HeaderContainsMessageHeader -like "X-MS-Exchange-Organization-SkipSafe*Processing") -or (($_.SetSCL -eq "-1") -and ($null -ne $_.SenderIpRanges)))} 

    $bypasses = @()

	If (($rules | measure-object).count -gt 0) {
		$path = New-Item -ItemType Directory -Force -Path "$($path)\Mail-Flow-Rules\Simulated-Phishing"

		ForEach ($rule in $rules) {
			$name = $rule.Name

            $pattern = '[\\/():;]'

            $name = $name -replace $pattern, '-'

            $rule | Format-List | Out-File -FilePath "$($path)\$($name)_Simulated-Phish-Spam-Bypass-Rule.txt"

            If ($rule.SetHeaderName -eq "X-MS-Exchange-Organization-SkipSafeLinksProcessing"){
                $bypasses += "Safe Links Bypass"
            }
            If ($rule.SetHeaderName -eq "X-MS-Exchange-Organization-SkipSafeAttachmentProcessing"){
                $bypasses += "Safe Attachments Bypass"
            }
            If ($rule.SetHeaderName -eq "X-Forefront-Antispam-Report"){
                $bypasses += "Spam Bypass"
            }
            If ($rule.SetHeaderName -eq "X-MS-Exchange-Organization-BypassClutter"){
                $bypasses += "Junk Folder Bypass"
            }
            If (($rule.HeaderContainsMessageHeader -eq "X-PHISHTEST") -or ($rule.HeaderContainsMessageHeader -eq "X-PhishingTackle") -or ($rule.HeaderContainsMessageHeader -eq "X-EPHISHIENCY")){
                $bypasses += "Use of default simulated phishing platform header"
            }
		}

        $allBypasses = $bypasses | Sort-Object

        Return $allBypasses
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

return Inspect-SimPhish



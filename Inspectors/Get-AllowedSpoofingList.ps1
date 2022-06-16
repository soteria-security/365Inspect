$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

function Get-AllowedSpoofingList {
Try {

	$Objects = Get-TenantAllowBlockListSpoofItems | Where-Object {$_.Action -eq "Allow"}
    $sendingInfrastructure = @()

    If ($Objects.Count -ne 0){
        ForEach ($Object in $Objects) {
            $Object | Export-Csv -Path "$($path)\AllowedSpoofingList.csv" -NoTypeInformation -Append
            $sendingInfrastructure += $Object.SendingInfrastructure
        }
        Return $sendingInfrastructure
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

return Get-AllowedSpoofingList



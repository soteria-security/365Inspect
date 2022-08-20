$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)
Function Inspect-AllUsersNonMFAStatus {
Try {
    
$Users = Get-MsolUser -All
$NonMFAUsers = @()
$Results = @()

foreach ($User in $Users){
$Roles = Get-AzureADUserMembership -ObjectId $User.UserPrincipalName -All $true | Where-Object { $_.ObjectType -eq "Role"}
if (($Roles.Count -eq 0) -and ($User.StrongAuthenticationRequirements.State -eq $Null) -and ($_.StrongAuthenticationMethods.MethodType -eq $Null)){
$NonMFAUsers += $User
}
}


foreach ($User in $NonMFAUsers){
$Result = New-Object -TypeName PSObject -Property @{
 DisplayName = $User.DisplayName
 UserName = $User.UserPrincipalName
 Role = "User"
 Licensed = $User.IsLicensed
 BlockedFromSignIn = $User.BlockCredential
}
$Results += $Result
}

if ($Results.Count -ne 0){
$Results | Format-Table -AutoSize | Out-File "$path\GetAllNonAdminsNonMFAStatus.txt"
return "Number of Users (Non-Admins) without MFA: $($Results.Count)"
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

Return Inspect-AllUsersNonMFAStatus
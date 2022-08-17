$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-AllUsersNonMFAStatus {
Try {
    $NonMFACount = 0
    $AllUsersNonMFAStatusResults = @()

    foreach ($MsolUser in $MsolUsers) {

      $MFAMethod = $MsolUser.StrongAuthenticationMethods | Where-Object {$_.IsDefault -eq $true} | Select-Object -ExpandProperty MethodType
      $Method = ""

      If (($MsolUser.StrongAuthenticationRequirements) -or ($MsolUser.StrongAuthenticationMethods)) {
        Switch ($MFAMethod) {
            "OneWaySMS" { $Method = "SMS token" }
            "TwoWayVoiceMobile" { $Method = "Phone call verification" }
            "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $Method = "Authenticator app" }
        }
      }
        # List only the user that don't have MFA enabled
        if (-not($MsolUser.StrongAuthenticationMethods) -or -not($MsolUser.StrongAuthenticationRequirements)) {

          $object = [PSCustomObject]@{
            DisplayName       = $MsolUser.DisplayName
            UserPrincipalName = $MsolUser.UserPrincipalName
            isAdmin           = if ($listAdmins -and ($admins.EmailAddress -match $MsolUser.UserPrincipalName)) {$true} else {"-"}
            MFAEnabled        = $false
            MFAType           = "-"
			MFAEnforced       = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
            "Email Verification" = if ($msoluser.StrongAuthenticationUserDetails.Email) {$msoluser.StrongAuthenticationUserDetails.Email} else {"-"}
            "Registered phone" = if ($msoluser.StrongAuthenticationUserDetails.PhoneNumber) {$msoluser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
          }
          $NonMFACount++
        }
        $AllUsersNonMFAStatusResults += $object
      }

    $AllUsersNonMFAStatusResults | Format-Table -AutoSize | Out-File "$path\GetAllUsersNonMFAStatus.txt" 

    Return "Number of Non MFA Accounts Found: $($NonMFACount.ToString())"

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
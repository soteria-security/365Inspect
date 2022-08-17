$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-AllAdminsNonMFAStatus {
Try {

    $AllAdminsNonMFAStatusResults = @()

    # Get all licensed admins
$admins = Get-MsolRole | %{$role = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid} | Where-Object {$_.isLicensed -eq $true} | select @{Name="Role"; Expression = {$role}}, DisplayName, EmailAddress, ObjectId | Sort-Object -Property EmailAddress -Unique

# Get only the admins and check their MFA Status
  foreach ($admin in $admins) {
    $MsolUser = Get-MsolUser -ObjectId $admin.ObjectId | Sort-Object UserPrincipalName -ErrorAction Stop

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
    
    $AllAdminsNonMFAStatusResults += $object
  }

    $AllAdminsNonMFAStatusResults | Format-Table -AutoSize | Out-File "$path\GetAllAdminsNonMFAStatus.txt" 

    Return "Number of Non MFA Admin Accounts Found: $($NonMFACount.ToString())"

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

Return Inspect-AllAdminsNonMFAStatus
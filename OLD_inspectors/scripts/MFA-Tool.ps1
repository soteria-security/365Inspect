function Disable-MFA{
$user = Read-Host -Prompt ("Email of MFA User")
Write-Output("Please Login with Administrator Credentials!")
Connect-MsolService

# Set MFA state in Microsoft 365
Set-MsolUser -UserPrincipalName $user | Set-MsolUser -StrongAuthenticationRequirements @()
Write-Output "MFA of $user has succesfully been disabled!"
}

function Enable-MFA{
$user = Read-Host -Prompt ("Email of MFA User")
Write-Output("Please Login with Administrator Credentials!")
Connect-MsolService

$authenticationRequirements = New-Object "Microsoft.Online.Administration.StrongAuthenticationRequirement"
$authenticationRequirements.RelyingParty = "*"
$authenticationRequirements.State = "Enabled"

# Set MFA state in Microsoft 365
Set-MsolUser -UserPrincipalName $user -StrongAuthenticationRequirements $authenticationRequirements
Write-Output "MFA of $user has succesfully been enabled!"
}

function Reset-MFA{
$user = Read-Host -Prompt ("Email of MFA User")
Write-Output("Please Login with Administrator Credentials!")
Connect-MsolService

# Reset MFA
Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $user
}

function MFA-Report{

Connect-MsolService
Write-Host "Finding Azure Active Directory Accounts..."
$Users = Get-MsolUser -All | ? { $_.UserType -ne "Guest" }
$Report = [System.Collections.Generic.List[Object]]::new() # Create output file
Write-Host "Processing" $Users.Count "accounts..." 
ForEach ($User in $Users) {
    $MFAEnforced = $User.StrongAuthenticationRequirements.State
    $MFAPhone = $User.StrongAuthenticationUserDetails.PhoneNumber
    $DefaultMFAMethod = ($User.StrongAuthenticationMethods | ? { $_.IsDefault -eq "True" }).MethodType
    If (($MFAEnforced -eq "Enforced") -or ($MFAEnforced -eq "Enabled")) {
        Switch ($DefaultMFAMethod) {
            "OneWaySMS" { $MethodUsed = "One-way SMS" }
            "TwoWayVoiceMobile" { $MethodUsed = "Phone call verification" }
            "PhoneAppOTP" { $MethodUsed = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $MethodUsed = "Authenticator app" }
        }
    }
    Else {
        $MFAEnforced = "Not Enabled"
        $MethodUsed = "MFA Not Used" 
    }
  
    $ReportLine = [PSCustomObject] @{
        User        = $User.UserPrincipalName
        Name        = $User.DisplayName
        MFAUsed     = $MFAEnforced
        MFAMethod   = $MethodUsed 
        PhoneNumber = $MFAPhone
    }
                 
    $Report.Add($ReportLine) 
}

Write-Host "MFAUsers.csv saved in C:\temp\"
$Report | Select User, Name, MFAUsed, MFAMethod, PhoneNumber | Sort Name | Out-GridView
$Report | Sort Name | Export-CSV -NoTypeInformation -Encoding UTF8 c:\temp\MFAUsers.csv
}

function Show-Menu
{
    param (
        [string]$Title = 'MFA TOOL V1.0'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for Disable MFA."
    Write-Host "2: Press '2' for Enable MFA."
    Write-Host "3: Press '3' for Reset MFA."
    Write-host "4: Press '4' for MFA Report"
    Write-Host "Q: Press 'Q' to quit."
}


Show-Menu –Title 'MFA TOOL V1.0'
 $selection = Read-Host "Please make a selection"
 switch ($selection)
 {
       '1' {
     Write-Host
         Disable-MFA
     } '2' {
         Enable-MFA
     } '3' {
         Reset-MFA
     } '4' {
        MFA-Report
     } 'q' {
         return
     }
 }
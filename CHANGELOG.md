# v0.0.1+beta 29-04-2022
## Added:
- SkipUpdateCheck Parameter so no updates will be installed! This is a [switch] parameter
- Username & Password Parameter so you can authenticate with an username and or password.
- Update function where all the modules will be updated to their latest versions
- Added an remove function that will remove earlier versions of the respective modules
- Added the function that will correctly install the AzureADPreview module instead of the normal one
- Expected value to the .html report where the expected value could be determined. This can be statically assigned in the .json file. 
- Default value to the .html report where users could check if their value corresponds with the default value configured. This is also statically assigned in the .json file.

## Changed:
- MFA Parameter so it is now a [switch] value instead of a [string] value.
- Renewed the authentication process and made it easier for MFA to authenticate. 
- The catch{} now contains an Exception function that contains the code of the errorhandling. This is to remove code redundancy. 
- Used dynamic paths instead of hard-coded paths. By using the $PSScriptRoot variable

## Fixed:
- An issue where in CMD and Powershell the commands could not be executed.
- An issue where the AzureADPreview Module in the normal version would not install correctly somehow if you have the normal version installed. This is caused of a missing parameter. 

## Removed:
- Already_Auth and CMDLINE function, this will be implemented in the next release. This could be added as an switch parameter instead. 

## Common Issues:
- There are multiple error logs being generated. I am looking into this issue and will hopefully fix this in the next release. This is due the Write-ErrorLog.ps1 that is provided. 
- There is a weird bug with Microsoft Teams that when it is not executed at first authentication it might throw an aggregate exception and break the program. I am looking into this issue and temporarily fixed it by first signing in with MicrosoftTeams module. 
- The removing feature is often buggy. I am looking into this and this hopefully be fixed in the new release.
- The Uninstall-Module might be buggy this is an issue with the PowerShellGet 2.x. A workaround is to use the 3.x CMDlet and change the commands to PSResource instead. This might be tested and implemented in the next releases to see if this method is faster than the 2.x
- The installation of missing PowerShell modules is not implemented. In the next version more functions will be seperated so code redundancy will be reduced. 

# v0.0.3beta+ 21-06-2022

## Added:
- SkipUpdateCheck is now fully implemented and working 
- The method of installing modules when they are not installed in the script itself
- Statistics Summary about Critical, High, Medium, Low and Informational in the report to give a brief overview of for example how many critical issues there are found
- Thanks to Soteria's new commit the disconnection of the modules is possible so no errors will occur when trying to do another audit
- A proper try & catch and exception function inside the program for each important module that could fail due issues.
- Thanks to Soteria the modules give now proper error feedback if there are errors found in the code. Documentation about creating a new module will be updated later.
- Soteria's New .json information
- Implemented a run as admin system so the user could elevate to admin if they accidently ran the script in non-admin mode
- A beautiful banner that will be displayed at startup containing the version info and such.
- A simplified authentication scheme as MFA can be combined with an username to allow easier authentication by using the -Username parameter

## Changed:
- Merged the latest commit from 365Inspect with this version

## Fixed:
- A bug where the Update Function is unable to update the modules to their latest version
- A bug where the Uninstall Function was unable to delete Microsoft Teams due a Cloud error. This is only mitigated when using PowerShellGet 3.x
- A bug where the Update Function did not work as expected as updates were available but they were not found by the script
- A bug where the Uninstall function did not correctly report back if there were multiple versions installed of a module

## Removed:
- The MSTeams Inspector: Inspect-MSTeamsP2PFileTransfer which is not able to be ran when having MicrosoftTeams Module 4.x or later installed. A replacement will be designed later!
- Some old redundant code that was not working properly

## Common Issues:
- There are some issues with the report where a table is not displaying the statistics properly this is due that function is not implemented yet.
- There are some ugly errors in the script of Soteria's modules sometimes, I will be looking into the modules that might have issues and try to fix them.
- When the PowerShell script is downloaded with their inspector modules it might cause issues due files are not unblocked. I am aware of this issue and fix this by adding some extra code before actually running the inspectors so no problems will occur
- Additional Authentication is required when running the AuditLogSearchEnabled inspector. I will look into this module to see if this can be fixed in the next version
- DomainExpiration throws an error

## Expected in the future:
- CVSS where possible to implement risk and impact. 
- Write mitigation steps (maybe on GitHub about each issue to update the reference)
- Create a auto-mitigation script that will allow the user to correct the issues after they are found

# v0.0.5beta+ 23-06-2022
## Added:
- Implemented cosmetic features in the template such as: IMPACT Rating now displayed in color at detailed view, CVS score tag when CVS scores are defined correctly, added a date stamp where the execution date of the audit is now displayed in the report itself and multiple statistics (counts) of the critical, high, medium, low and informational findings.
- Added the Azure Powershell Module (no this is not the Azure AD Powershell module, this is a different one). This allows more audit functionalitity as Azure instances could be audited as well 

## Changed:
- Changed the Risk tab to CVS because that should be in detailed view. CVS is an important aspect and should be sorted on in the future
- Some aspects that caused cosmetic failures or imperfections in the template

## Fixed:
- An issue with uninstallation of the same module that was updated at first. This was caused by a descending sort-object problem. This has been fixed now!
- An issue that cause 365Inspect+ to hang when modules are updated
- Added Out-Null values to some of the authentication processes so no output is displayed. 

## Removed:
Removed some non-functional things inside the template that were not displaying in the template at all.

## Common Issues/remarks:
- When updating a module it could take some time until the module is installed, please be patient.
- When removing a module it could take some time until it is removed, please be patient.
- When generating an error it would generate multiple logs. The goal is to append to this log afterwards so no multiple logs are created. This will be looked into later.

## Expected in the future:
- CVSS Score implementation
- More professional cosmetic changes to the report
- Simplified authentication mechanism (prototype is ready)


# v0.0.6beta+ 13-07-2022
## Added:
- The Az (Azure PowerShell) module 
- Added an audit started and finished timestamp to the report
- Added a brief overview 

## Changed:
- Merged the Soteria Inspectors with the CIS Inspectors to remove duplicates
- Changed the Update and Removal engine for the 365 Modules

## Fixed:
- An issue where the incorrect version would be removed leading to a update loop. This has been fixed by implementing the new update en removal engine
- An issue where Azure Powershell would not disconnect at the end. This has been added to the Disconnect function.

## Removed:
- Duplicate CIS Modules to merge with the Soteria Inspectors

## Common Issues/remarks:
- Updating modules (especially the Az module) could take a while, please be patient.
- The new update engine has not been tested properly yet, it could have some issues. Bugs can be reported in the issue tab!
- When removing a module it could take some time until it is removed, please be patient.
- When generating an error it would generate multiple logs. The goal is to append to this log afterwards so no multiple logs are created. This will be looked into later.

## Expected in the future:
- CVSS Score implementation
- More professional cosmetic changes to the report
- Simplified authentication mechanism (prototype is ready)


# v0.0.7 beta 29-07-2022
## Added:
- Added new values such as ProductFamily and CVS Score to the template and the 365Inspect script
- Added the column for CVS Scores
- Added the CVS Score to the description as well

## Changed:
- Changed the lay-out of the template and ordered some things differently in the template
- Optimized the template and removed unnecessary classes
- Renamed all the inspectors so the productfamily could be determined 
- Changed the filtering as it now filters on CVS score instead of impact!

## Fixed:
- Fixed an issue with the updating module where the module encountered an error during the update process
- Fixed an issue with the removing module where the module encountered an error during the removing process

## Removed:
- Duplicate CIS Modules to merge with the Soteria Inspectors again
- Removed an old MSTeams module which was for Skype for Business.

## Common Issues/remarks:
- Updating modules (especially the Az module) could take a while, please be patient.
- There could be issues with the updating and removing module. This is being investigated and eventually a fix will be issued in the next release.
- When removing a module it could take some time until it is removed, please be patient.
- When generating an error it would generate multiple logs. The goal is to append to this log afterwards so no multiple logs are created. This will be looked into later.
- There is an issue with the DomainExpiration inspector, this will be investigated and in the next release it will be fixed.
- Removing a module with PowerShellGetVersion version less than 2.2.5 could result into errors because the old PowerShellGet version has a bug in the uninstall module. Recommended is to update to the latest version of PowerShellGet to fix this issue.

## Expected in the future:
- More professional cosmetic changes to the report
- Simplified authentication mechanism
- More Inspectors!!!
- Integration PnP Powershell
- Merging new inspectors with 

# v0.0.8 beta 01-08-2022
## Added:
- Merged the latest version changes from the primary github repo to Inspect365+
- Added the changes to enable CSV, XML or HTML reporting (Thanks to Soteria's new version)
- Added Powershell PnP module and the mechanism to actually login to the Powershell PnP
- Added all MFA, Regular and Credential Authentication methods for Powershell PnP and tested them succesfully

## Changed:
- Some code in the update / removal mechanism to make it work properly
- Changed MailboxeswithIMAPEnabled, MailboxesWithPOPEnabled, ProperAdminCount, SecureDefaultsEnabled, ThirdPartyIntegratedAppPermission, UsersWithNoMFAConfigured and UsersWithNoMFAEnforced to Soteria's version which uses partially Graph now to get better processing results
- Updated the README.md and Dutch version so PnP SharePoint is added to the list. 

## Fixed:
- Fixed an issue with the DomainValidation.ps1 script by first merging it with the Soteria's version. This is done by adding another try & catch within the process to not output an nullarray error.

## Removed
- Nothing removed this time!

## Common Issues/remarks:
- Updating modules (especially the Az module) could take a while, please be patient.
- There could be issues with the updating and removing module. This is being investigated further and a definitive fix will be in the stable version
- When removing a module it could take some time until it is removed, please be patient.
- When generating an error it would generate multiple logs. The goal is to append to this log afterwards so no multiple logs are created. This will be fixed in the stable version
- Removing a module with PowerShellGetVersion version less than 2.2.5 could result into errors because the old PowerShellGet version has a bug in the uninstall module. Recommended is to update to the latest version of PowerShellGet to fix this issue.

# Coming soon in v0.0.9
- Proper CVS score calculation
- More NEW Inspector modules
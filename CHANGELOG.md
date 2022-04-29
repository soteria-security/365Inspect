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
# (365)Inspect+
## From 1st of December 2022 the Project will go further under a different name: M365SAT. The public release of M365SAT is scheduled on 1st of January 2023
<div>
  <p align="center">
    <b>The Open-Source, Automated Microsoft 365 Security Assessment Tool</b> </br></br>
    <img src="https://i.imgur.com/yLZ9SCp.png" width="800"> 
  </p>
</div>

[![OS](https://img.shields.io/badge/OS-Windows-blue?style=flat&logo=Windows)](https://www.microsoft.com/en-gb/windows/?r=1)
[![made-with-powershell](https://img.shields.io/badge/Made%20with-Powershell-1f425f.svg?logo=Powershell)](https://github.com/powershell/powershell)
[![Docker](https://img.shields.io/badge/Docker-Coming_Soon-red.svg?style=flat&logo=docker)](https://github.com/asterictnl-lvdw/365Inspect)
[![Maintenance](https://img.shields.io/badge/Maintained-yes-green.svg)](https://github.com/asterictnl-lvdw/365Inspect)
[![GitHub](https://img.shields.io/github/license/asterictnl-lvdw/365inspect)](https://github.com/asterictnl-lvdw/365Inspect/blob/main/LICENSE)
[![Documentation](https://img.shields.io/badge/Documentation-complete-green.svg?style=flat)](https://github.com/asterictnl-lvdw/365Inspect/)
	

## 1. Table of contents

<!-- TOC -->

- [365Inspect+](#365inspect)
    - [1. Table of contents](#1-table-of-contents)
    - [2. Purpose](#2-purpose)
    - [3. About 365Inspect+](#3-about-365inspect)
    - [4. Configuration:](#4-configuration)
    - [5. How-To-Use](#5-how-to-use)
    - [6. Output](#6-output)
    - [7. Necessary Privileges](#7-necessary-privileges)
    - [8. Developing Additional Inspector Modules](#8-developing-additional-inspector-modules)
        - [8.1. Example](#81-example)
    - [9. About Program's Security](#9-about-programs-security)
    - [10. License](#10-license)
    - [11. Who talks about 365Inspect+](#11-who-talks-about-365inspect)
    - [12. Special Thanks To...](#12-special-thanks-to)

<!-- /TOC -->

## 2. Purpose

Further the state of M365 security by authoring a PowerShell script that automates the security assessment of Microsoft 365 environments.

## 3. About 365Inspect+

365*Inspect+* is a command-line utility that automatically audits an M365 environment. 365*Inspect+* retrieves configuration information from your M365 instance and validates whether or not a series of security best practices have been followed. 365*Inspect* creates a simple graphical HTML report that provides descriptions of any discovered security flaws as well as actionable recommendations you can use to improve the security state of your M365 instance.

365*Inspect+* is open-source and completely free. It is authored in PowerShell, and all you need to use it are the appropriate PowerShell modules and credentials to your M365 administrator account. For our fellow tinkerers and security analysts out there, 365Inspect also supports a simple module system that allows you to easily author your own additions to the audit functionality. This means you can use it out of the box as a powerful M365 security scanner, or nerd out and expand the functionality using your own or other modules. Detailed directions are provided on the project’s Github page.

## 4. Configuration:

365Inspect+ requires the administrative PowerShell modules for Azure AD (We recommend installing the AzureADPreview module), Exchange administration, Microsoft Graph, Microsoft Intune, Microsoft Teams, and both the Sharepoint and PnP SharePoint administration modules.

The 365Inspect+.ps1 PowerShell script will validate the installed modules and minimum version of the modules necessary for the Inspectors to function.

If you do not have these modules installed, you will be prompted to install them, and with your approval, the script will attempt installation. Otherwise, you should be able to install them with the following commands in an administrative PowerShell prompt, or by following the instructions at the references below:

	Install-Module -Name MSOnline

	Install-Module -Name AzureADPreview

	Install-Module -Name Az

	Install-Module -Name ExchangeOnlineManagement

	Install-Module -Name Microsoft.Online.SharePoint.PowerShell

	Install-Module -Name Microsoft.Graph

 	Install-Module -Name PnP.PowerShell

	Install-Module -Name MicrosoftTeams

	Install-Module -Name Microsoft.Graph.Intune

References:

* [Install MSOnline PowerShell](https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-msonlinev1?view=azureadps-1.0)

* [Install Azure AD PowerShell](https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0)

* [Install Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-8.0.0)

* [Install PnP SharePoint](https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets)

* [Install Exchange Online PowerShell](https://docs.microsoft.com/en-us/powershell/exchange/exchange-online-powershell-v2?view=exchange-ps)

* [Install SharePoint](https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/connect-sharepoint-online?view=sharepoint-ps)

* [Install Microsoft Graph SDK](https://docs.microsoft.com/en-us/graph/powershell/installation)

* [Install Microsoft Teams PowerShell Module](https://docs.microsoft.com/en-us/microsoftteams/teams-powershell-install)

* [Install Microsoft Intune PowerShell SDK](https://github.com/microsoft/Intune-PowerShell-SDK)

Once the above are installed, download the 365*Inspect* source code folder from Github using your browser or by using *git clone*.

As you will run 365*Inspect* with administrative privileges, you should place it in a logical location and make sure the contents of the folder are readable and writable only by the administrative user. This is especially important if you intend to install 365*Inspect+* in a location where it will be executed frequently or used as part of an automated process.

To make sure you will not encounter any issues run the following commands:

	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
	Get-ChildItem -Path 'Directoryof365Inspect+' -Recurse | Unblock-File

## 5. How-To-Use

To run 365*Inspect+*, open a PowerShell console and navigate to the folder you downloaded 365*Inspect+* into:

	cd 365Inspect

You will interact with 365*Inspect+* by executing the main script file, 365Inspect.ps1, from within the PowerShell command prompt. 

All 365*Inspect+* requires to inspect your O365 tenant is access via an O365 account with proper permissions, so most of the command line parameters relate to the organization being assessed and the method of authentication.

Execution of 365*Inspect+* looks like this:

	.\365Inspect+.ps1 -OrgName <value> -OutPath <value> -reportType <HTML/CSV/XML> (-Username <username> -Password <password> -SkipUpdateCheck *these are optional*)

For example, to log in by entering your credentials in a browser with MFA support and exporting an HTML report:

	.\365Inspect+.ps1 -OrgName mycompany -OutPath ..\365_report -reportType HTML

365*Inspect+* can be run with only specified Inspector modules, or conversely, by excluding specified modules.

For example, to log in by entering your credentials in a browser with MFA support and exporting an HTML report:

	.\365Inspect+.ps1 -OrgName mycompany -OutPath ..\365_report -reportType HTML -SelectedInspectors inspector1, inspector2

or

	.\365Inspect+.ps1 -OrgName mycompany -OutPath ..\365_report -reportType HTML -ExcludedInspectors inspector1, inspector2, inspector3

* *OrgName* is the name of the core organization or "company" of your O365 instance, which will be inspected. 
	* If you do not know your organization name, you can navigate to the list of all Exchange domains in O365. The topmost domain should be named *domain_name*.onmicrosoft.com. In that example, *domain_name* is your organization name and should be used when executing 365*Inspect*.
* *OutPath* is the path to a folder where the report generated by 365*Inspect* will be placed.
* *reportType* is an choice paramers where users can specify the output of the report. Choices are HTML, CSV or XML format.
* *Username* is an string paramter that could be provided if the Username is constantly the same for authentication
	* The *Password* parameter is optional to use if you use it with the *Username* parameter.
* *Password* is an string parameter that allows the user to authenticate with their password.
* *SelectedInspectors* is the name or names of the inspector or inspectors you wish to run with 365*Inspect*. If multiple inspectors are selected they must be comma separated. Only the named inspectors will be run.
* *ExcludedInspectors*  is the name or names of the inspector or inspectors you wish to prevent from running with 365*Inspect*. If multiple inspectors are selected they must be comma separated. All modules other included modules will be run.
* *SkipUpdateCheck* allows the user to skip the update and installation check. Only use this parameter if you know that your modules are up-to-date and are all installed correctly. 

When you execute 365*Inspect+* normally, it may produce several graphical login prompts that you must sequentially log into. This is normal behavior as Exchange, SharePoint etc. have separate administration modules and each requires a different login session. If you simply log in the requested number of times, 365*Inspect+* should begin to execute. For semi-automation you should specify the -Username parameter that would allow logging in into some of the modules automatically. Sadly there are some modules where it is required to login with full credentials, we cannot mitigate this issue. So we have to wait for an update in the future to allow the support of this functionality.

As 365*Inspect+* executes, it will steadily print status updates indicating which inspection task is running.

365*Inspect+* may take some time to execute. This time scales with the size and complexity of the environment under test. For example, some inspection tasks involve scanning the account configuration of all users. This may occur near-instantly for an organization with 50 users, or could take entire minutes (!) for an organization with 10000. 

## 6. Output

365*Inspect+* creates a directory specified in the out_path parameter e.g. (orgname_timestamp). This directory is the result of the entire 365*Inspect* inspection. The following items are included:
* *Report_timestamp_orgname.html/csv/xml*: graphical report that describes the M365 security issues identified by 365*Inspect+*, lists O365 objects that are misconfigured, and provides remediation advice.
* *Various text files named [Inspector-Name]*: these are raw output from inspector modules and contain a list (one item per line) of misconfigured O365 objects that contain the described security flaw. For example, if a module Inspect-FictionalMFASettings were to detect all users who do not have MFA set up, the file "Inspect-FictionalMFASettings" in the report ZIP would contain one user per line who does not have MFA set up. This information is only dumped to a file in cases where more than 15 affected objects are discovered. If less than 15 affected objects are discovered, the objects are listed directly in the main HTML report body.
* *Report_timestamp_orgname.zip*: zipped version of this entire directory, for convenient distribution of the results in cases where some inspector modules generated a large amount of findings.
* *Log directory*: 365*Inspect+* logs any errors encountered during the scripts execution to a timestamped log file found in the Log directory.

## 7. Necessary Privileges

365*Inspect+* can't run properly unless the O365 account you authenticate with has appropriate privileges. 365*Inspect+* requires, at minimum, the following:

* Global Administrator
* SharePoint Administrator

We realize that these are extremely permissive roles, unfortunately due to the use of Microsoft Graph, we are restricted from using lesser prileges by Microsoft. Application and Cloud Application Administrator roles (used to grant delegated and application permissions) are restricted from granting permissions for Microsoft Graph or Azure AD PowerShell modules. [https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#application-administrator](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#application-administrator)

## 8. Developing Additional Inspector Modules

365*Inspect+* is designed to be easy to expand, with the hope that it enables individuals and organizations to either utilize their own 365*Inspect* modules internally, or publish those modules for the O365 community.

All of 365*Inspect+*'s inspector modules are stored in the .\inspectors folder. 

It is simple to create an inspector module. Inspectors have two files:

* *ModuleName.ps1*: the PowerShell source code of the inspector module. Should return a list of all O365 objects affected by a specific issue, represented as strings.
* *ModuleName.json*: metadata about the inspector itself. For example, the finding name, description, remediation information, and references.

The PowerShell and JSON file names must be identical for 365*Inspect* to recognize that the two belong together. There are numerous examples in 365*Inspect*'s built-in suite of modules, but we'll put an example here too.

### 8.1. Example

Example .ps1 file, Exchange-BypassingSafeAttachments.ps1:
```
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


# Define a function that we will later invoke.
# 365Inspect's built-in modules all follow this pattern.
function Inspect-BypassingSafeAttachments {
Try {

	# Query some element of the O365 environment to inspect. Note that we did not have to authenticate to Exchange
	# to fetch these transport rules within this module; assume main 365Inspect harness has logged us in already.
	$safe_attachment_bypass_rules = (Get-TransportRule | Where-Object { $_.SetHeaderName -eq "X-MS-Exchange-Organization-SkipSafeAttachmentProcessing" }).Identity
	
	# If some of the parsed O365 objects were found to have the security flaw this module is inspecting for,
	# return a list of those objects.
	If ($safe_attachment_bypass_rules.Count -ne 0) {
		return $safe_attachment_bypass_rules
	}
	
	# If none of the parsed O365 objects were found to have the security flaw this module is inspecting for,
	# returning $null indicates to 365Inspect that there were no findings for this module.
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

# Return the results of invoking the inspector function.
return Inspect-BypassingSafeAttachments
```

Example .json file, Exchange-BypassingSafeAttachments.json:
```
{
	"FindingName": "Do Not Bypass the Safe Attachments Filter",
	"ProductFamily": "Microsoft Exchange",
	"CVS": "7.5",
	"Description": "In Exchange, it is possible to create mail transport rules that bypass the Safe Attachments detection capability. The rules listed above bypass the Safe Attachments capability. Consider reviewing these rules, as bypassing the Safe Attachments capability even for a subset of senders could be considered insecure depending on the context or may be an indicator of compromise.",
	"Remediation": "Navigate to the Mail Flow → Rules screen in the Exchange Admin Center. Look for the offending rules and begin the process of assessing who created them and whether they are necessary to the continued function of the organization. If they are not, remove the rules.",
	"DefaultValue" : "None",
    "ExpectedValue" : "None",
    "ReturnedValue" : "",
    "Impact": "High",
	"RiskRating" : "High",
    "AffectedObjects": "",
	"References": [
		{
			"Url": "https://docs.microsoft.com/en-us/exchange/security-and-compliance/mail-flow-rules/manage-mail-flow-rules",
			"Text": "Manage Mail Flow Rules in Exchange Online"
		},
		{
			"Url": "https://www.undocumented-features.com/2018/05/10/atp-safe-attachments-safe-links-and-anti-phishing-policies-or-all-the-policies-you-can-shake-a-stick-at/#Bypass_Safe_Attachments_Processing",
			"Text": "Undocumented Features: Safe Attachments, Safe Links, and Anti-Phishing Policies"
		}
	]
}
```

Once you drop these two files in the .\inspectors folder, they are considered part of 365*Inspect+*'s module inventory and will run the next time you execute 365*Inspect+*.

You have just created the BypassingSafeAttachments Inspector module. Yay!

365*Inspect+* will throw a pretty loud and ugly error if something in your module doesn't work or doesn't follow 365*Inspect+* conventions, so monitor the command line output.

## 9. About Program's Security

365*Inspect+* is a script harness that runs other inspector script modules stored in the .\inspectors folder. As with any other script you may run with elevated privileges, you should observe certain security hygiene practices:

* No untrusted user should have write access to the 365*Inspect+* folder/files, as that user could then overwrite scripts or templates therein and induce you to run malicious code.
* No script module should be placed the Inspectors folder unless you trust the source of that script module.

## 10. License

365Inspect+ is an open-source and free software released under the [MIT License](https://github.com/asterictnl-lvdw/365Inspect/blob/main/LICENSE).

## 11. Who talks about 365Inspect+
- [SoteriaSecurity](https://soteria.io/soteria-365-inspect/)

## 12. Special Thanks To...
* [SoteriaSecurity](https://github.com/soteria-security/365Inspect): For allowing me to create the fork and this version!
* [CISSecurity](https://www.cisecurity.org/cis-benchmarks/): For providing the M365 benchmarks to make audit scripts

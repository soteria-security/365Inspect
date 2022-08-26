# (365)Inspect+

<div>
  <p align="center">
    <b>De Open-Source, Geautomatiseerde Microsoft 365 Security Audit Tool</b> </br></br>
    <img src="https://i.imgur.com/yLZ9SCp.png" width="800"> 
  </p>
</div>

[![OS](https://img.shields.io/badge/OS-Windows-blue?style=flat&logo=Windows)](https://www.microsoft.com/en-gb/windows/?r=1)
[![made-with-powershell](https://img.shields.io/badge/Gemaakt%20met-Powershell-1f425f.svg?logo=Powershell)](https://github.com/powershell/powershell)
[![Docker](https://img.shields.io/badge/Docker-Binnenkort-red.svg?style=flat&logo=docker)](https://github.com/asterictnl-lvdw/365Inspect)
[![Maintenance](https://img.shields.io/badge/Onderhouden-ja-green.svg)](https://github.com/asterictnl-lvdw/365Inspect)
[![GitHub](https://img.shields.io/github/license/asterictnl-lvdw/365inspect)](https://github.com/asterictnl-lvdw/365Inspect/blob/main/LICENSE)
[![Documentation](https://img.shields.io/badge/Documentatie-Compleet-green.svg?style=flat)](https://github.com/asterictnl-lvdw/365Inspect/)
	

## 1. Inhoudsopgave

<!-- TOC -->

- [365Inspect+](#365inspect)
    - [1. Inhoudsopgave](#1-inhoudsopgave)
    - [2. Doel](#2-doel)
    - [3. Over 365Inspect+](#3-over-365inspect)
    - [4. Configuratie:](#4-configuratie)
    - [5. Gebruiksaanwijzing](#5-gebruiksaanwijzing)
    - [6. Output](#6-output)
    - [7. Benodigde Rechten](#7-benodigde-rechten)
    - [8. Aanvullende inspectiemodules ontwikkelen](#8-aanvullende-inspectiemodules-ontwikkelen)
        - [8.1. Voorbeeld](#81-voorbeeld)
    - [9. Over de beveiliging van het programma](#9-over-de-beveiliging-van-het-programma)
    - [10. Licentie](#10-licentie)
    - [11. Wie heeft het over 365Inspect+](#11-wie-heeft-het-over-365inspect)
    - [12. Speciale Dank Naar...](#12-speciale-dank-naar)

<!-- /TOC -->

## 2. Doel

Verbeteren van de status van M365-beveiliging door een PowerShell-script te schrijven dat de beveiligingsbeoordeling van Microsoft 365-omgevingen automatiseert.

## 3. Over 365Inspect+

365Inspect+ is een opdrachtregelprogramma dat automatisch een M365-omgeving controleert. 365Inspect+ haalt configuratie-informatie op uit uw M365-instantie en valideert of een reeks best practices op het gebied van beveiliging is gevolgd. 365Inspect+ maakt een eenvoudig grafisch HTML-rapport met beschrijvingen van ontdekte beveiligingsfouten en bruikbare aanbevelingen die u kunt gebruiken om de beveiligingsstatus van uw M365-instantie te verbeteren.

365Inspect+ is open-source en volledig gratis. Het is geschreven in PowerShell en het enige dat u nodig hebt om het te gebruiken, zijn de juiste PowerShell-modules en referenties voor uw M365-beheerdersaccount. Voor beveiligingsanalisten ondersteunt 365Inspect+ ook een eenvoudig modulesysteem waarmee u eenvoudig uw eigen toevoegingen aan de auditfunctionaliteit kunt maken. Dit betekent dat je hem direct 'Out of The Box' kunt gebruiken als een krachtige M365-beveiligingsscanner.

## 4. Configuratie:

365*Inspect+* vereist de administratieve PowerShell-modules voor Microsoft Online, Azure AD (we raden aan om de AzureADPreview-module te installeren), Exchange Online Administration, Sharepoint Administration, Microsoft Intune, Microsoft Teams, Microsoft Graph en PnP Powershell.

Het 365*Inspect+*.ps1 PowerShell-script valideert de geïnstalleerde modules.

Als u deze modules niet hebt geïnstalleerd, wordt u gevraagd ze te installeren en met uw goedkeuring zal het script proberen te installeren. Anders zou u ze moeten kunnen installeren met de volgende opdrachten in een beheerders-PowerShell-prompt, of door de instructies te volgen bij de onderstaande verwijzingen:

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

Zodra het bovenstaande is geïnstalleerd, downloadt u de 365*Inspect* broncodemap van Github met uw browser of door *git clone* te gebruiken.

Aangezien u 365*Inspect* uitvoert met beheerdersrechten, moet u het op een logische locatie plaatsen en ervoor zorgen dat de inhoud van de map alleen leesbaar en beschrijfbaar is voor de gebruiker met beheerdersrechten. Dit is vooral belangrijk als u 365*Inspect+* wilt installeren op een locatie waar het vaak wordt uitgevoerd of als onderdeel van een geautomatiseerd proces wordt gebruikt.

Voer de volgende opdrachten uit om ervoor te zorgen dat u geen problemen ondervindt:

	Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
	Get-ChildItem -Path 'Directoryof365Inspect+' -Recurse | Unblock-File

## 5. Gebruiksaanwijzing

Om 365*Inspect+* uit te voeren, opent u een PowerShell-console en navigeert u naar de map waarin u 365*Inspect+* hebt gedownload:

	cd 365Inspect

U werkt met 365*Inspect+* door het hoofdscriptbestand 365Inspect.ps1 uit te voeren vanuit de PowerShell-opdrachtprompt.

Het enige dat 365*Inspect+* nodig heeft om uw O365-tenant te inspecteren, is toegang via een O365-account met de juiste machtigingen, dus de meeste opdrachtregelparameters hebben betrekking op de organisatie die wordt beoordeeld en de authenticatiemethode.

Uitvoering van 365*Inspect+* ziet er als volgt uit:

	.\365Inspect+.ps1 -OrgName <value> -OutPath <value> -reportType <HTML/CSV/XML> (-Username <username> -Password <password> -SkipUpdateCheck *these are optional*)

Om bijvoorbeeld in te loggen door uw inloggegevens in te voeren in een browser met MFA-ondersteuning en een HTML-rapport te exporteren:

	.\365Inspect+.ps1 -OrgName mycompany -OutPath ..\365_report -reportType HTML

365*Inspect+* kan worden uitgevoerd met alleen gespecificeerde Inspector-modules, of omgekeerd, door gespecificeerde modules uit te sluiten.

Om bijvoorbeeld in te loggen door uw inloggegevens in te voeren in een browser met MFA-ondersteuning en een HTML-rapport te exporteren:

	.\365Inspect+.ps1 -OrgName mycompany -OutPath ..\365_report -reportType HTML -SelectedInspectors inspector1, inspector2

or

	.\365Inspect+.ps1 -OrgName mycompany -OutPath ..\365_report -reportType HTML -ExcludedInspectors inspector1, inspector2, inspector3

* *OrgName* is de naam van de kernorganisatie of "bedrijf" van uw O365-instantie, die zal worden geïnspecteerd.
	* Als je de naam van je organisatie niet weet, kun je navigeren naar de lijst met alle Exchange-domeinen in O365. Het bovenste domein moet domain_name.onmicrosoft.com heten. In dat voorbeeld is domain_name de naam van uw organisatie en moet deze worden gebruikt bij het uitvoeren van 365Inspect. Dit is belangrijk dat dit hetzelfde is als de sharepoint domeinnaam, zodat er geen problemen met authenticeren van het sharepoint domein optreedt.
* *OutPath* is het pad naar een map waar het door 365Inspect+ gegenereerde rapport wordt geplaatst.
* *reportType* Selecteert de definitieve output van het hoofdrapport. Keuze uit HTML, CSV of XML.
* *Username* is een stringparameter die kan worden opgegeven als de gebruikersnaam constant hetzelfde is voor authenticatie
	* De parameter *Password* is optioneel om te gebruiken in combinatie met de Username parameter.
* *Password* is een stringparameter waarmee de gebruiker zich kan authenticeren met zijn wachtwoord.
* *SelectedInspectors* is de naam of namen van de inspecteur of inspecteurs die u wilt gebruiken met 365Inspect+. Als er meerdere inspecteurs zijn geselecteerd, moeten deze door komma's worden gescheiden. Alleen de genoemde inspecteurs zullen worden uitgevoerd.
* *ExcludedInspectors*  is de naam of namen van de inspecteur of inspecteurs waarvan u wilt voorkomen dat 365Inspect+ wordt uitgevoerd. Als er meerdere inspecteurs zijn geselecteerd, moeten deze door komma's worden gescheiden. Alle modules andere inbegrepen modules zullen worden uitgevoerd.
* *SkipUpdateCheck* stelt de gebruiker in staat de update- en installatiecontrole over te slaan. Gebruik deze parameter alleen als u weet dat uw modules up-to-date zijn en allemaal correct zijn geïnstalleerd. 

Wanneer u 365*Inspect+* normaal uitvoert, kan het verschillende grafische login-prompts produceren waarop u achtereenvolgens moet inloggen. Dit is normaal omdat Exchange, SharePoint enz. aparte beheermodules hebben en elk een andere inlogsessie vereist. Als u gewoon het gevraagde aantal keren inlogt, zou 365*Inspect+* moeten beginnen te werken. Voor semi-automatisering moet u de parameter -Username specificeren waarmee u automatisch bij sommige modules kunt inloggen. Helaas zijn er enkele modules waarbij het vereist is om in te loggen met volledige inloggegevens, we kunnen dit probleem niet verhelpen. We moeten dus wachten op een update in de toekomst om de ondersteuning van deze functionaliteit mogelijk te maken.

Terwijl 365*Inspect+* wordt uitgevoerd, zal het gestaag statusupdates afdrukken die aangeven welke inspectietaak wordt uitgevoerd.

365*Inspect+* kan enige tijd duren om uit te voeren. Deze tijd schaalt met de omvang en complexiteit van de te testen omgeving. Sommige inspectietaken omvatten bijvoorbeeld het scannen van de accountconfiguratie van alle gebruikers. Dit kan bijna onmiddellijk gebeuren voor een organisatie met 50 gebruikers, of kan hele minuten (!) duren voor een organisatie met 10000.

## 6. Output

365*Inspect+* maakt een map aan die gespecificeerd is in de out_path parameter, b.v. (orgnaam_tijdstempel). Deze directory is het resultaat van de gehele 365*Inspect* inspectie. De volgende items zijn inbegrepen:
* *Report_timestamp_orgname.html/csv/xml*: grafisch rapport dat de M365-beveiligingsproblemen beschrijft die zijn geïdentificeerd door 365*Inspect+*, een lijst geeft van O365-objecten die verkeerd zijn geconfigureerd, en hersteladvies geeft.
* *Verschillende tekstbestanden met de naam [Inspector-Name]*: dit zijn onbewerkte uitvoer van inspectiemodules en bevatten een lijst (één item per regel) van verkeerd geconfigureerde O365-objecten die de beschreven beveiligingsfout bevatten. Als een module Inspect-FictionalMFASettings bijvoorbeeld alle gebruikers zou detecteren die geen MFA hebben ingesteld, zou het bestand "Inspect-FictionalMFASettings" in het ZIP-rapport één gebruiker per regel bevatten die geen MFA heeft ingesteld. Deze informatie wordt alleen naar een bestand gedumpt in gevallen waarin meer dan 15 getroffen objecten worden ontdekt. Als er minder dan 15 getroffen objecten worden ontdekt, worden de objecten direct in de hoofdtekst van het HTML-rapport vermeld.
* *Report_timestamp_orgname.zip*: gecomprimeerde versie van deze hele directory, voor gemakkelijke distributie van de resultaten in gevallen waarin sommige inspectiemodules een grote hoeveelheid bevindingen genereerden.
* *Log directory*: 365*Inspect+* registreert eventuele fouten die tijdens de uitvoering van de scripts worden aangetroffen in een logbestand met tijdstempel dat in de Log-directory wordt gevonden.

## 7. Benodigde Rechten

365*Inspect+* kan niet correct worden uitgevoerd, tenzij het O365-account waarmee u authenticeert de juiste rechten heeft. 365*Inspect+* vereist minimaal het volgende:

* Global Administrator
* SharePoint-Administrator

We realiseren ons dat dit uiterst tolerante rollen zijn, helaas vanwege het gebruik van Microsoft Graph zijn we beperkt in het gebruik van minder rechten door Microsoft. Toepassings- en cloudtoepassingsbeheerdersrollen (gebruikt om gedelegeerde en toepassingsmachtigingen te verlenen) zijn beperkt in het verlenen van machtigingen voor Microsoft Graph- of Azure AD PowerShell-modules. [https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#application-administrator](https://docs.microsoft.com/en-us/azure/active- directory/rollen/permissions-reference#application-administrator)

## 8. Aanvullende inspectiemodules ontwikkelen

365*Inspect+* is ontworpen om eenvoudig uit te breiden, in de hoop dat het individuen en organisaties in staat stelt om ofwel hun eigen 365*Inspect*-modules intern te gebruiken, of deze modules te publiceren voor de O365-gemeenschap.

Alle inspectiemodules van 365*Inspect+* worden opgeslagen in de map .\inspectors.

Het is eenvoudig om een inspecteur-module te maken. Inspecteurs hebben twee bestanden:

* *ModuleName.ps1*: de PowerShell-broncode van de inspectiemodule. Moet een lijst retourneren van alle O365-objecten die zijn getroffen door een specifiek probleem, weergegeven als tekenreeksen.
* *ModuleName.json*: metadata over de inspecteur zelf. Bijvoorbeeld de naam van de bevinding, beschrijving, herstelinformatie en referenties.

De PowerShell- en JSON-bestandsnamen moeten identiek zijn voor 365*Inspect* om te herkennen dat de twee bij elkaar horen. Er zijn talloze voorbeelden in de ingebouwde reeks modules van 365*Inspect*, maar we zullen hier ook een voorbeeld geven.

### 8.1. Voorbeeld

voorbeeld .ps1 bestand, Exchange-BypassingSafeAttachments.ps1:
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

voorbeeld .json bestand, Exchange-BypassingSafeAttachments.json:
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

Zodra u deze twee bestanden in de map .\inspectors neerzet, worden ze beschouwd als onderdeel van de module-inventaris van 365*Inspect+* en worden ze uitgevoerd de volgende keer dat u 365*Inspect+* uitvoert.

U hebt zojuist de BypassingSafeAttachments Inspector-module gemaakt. Hoera!

365*Inspect+* zal een behoorlijk luide en lelijke foutmelding geven als iets in uw module niet werkt of de 365*Inspect+*-conventies niet volgt, dus controleer de uitvoer van de opdrachtregel.

## 9. Over de beveiliging van het programma

365Inspect+ is een scriptharnas dat andere inspecteur-scriptmodules uitvoert die zijn opgeslagen in de map .\inspectors. Zoals bij elk ander script dat u met verhoogde bevoegdheden kunt uitvoeren, moet u bepaalde veiligheidshygiënepraktijken in acht nemen:

* Geen enkele niet-vertrouwde gebruiker mag schrijftoegang hebben tot de 365Inspect+-map/bestanden, omdat die gebruiker dan scripts of sjablonen daarin kan overschrijven en u ertoe kan brengen kwaadaardige code uit te voeren.
* Er mag geen scriptmodule in .\inspectors worden geplaatst, tenzij u de bron van die scriptmodule vertrouwt.

## 10. Licentie

365Inspect+ is open-source en gratis software uitgebracht onder de [MIT Licentie](https://github.com/asterictnl-lvdw/365Inspect/blob/main/LICENSE).

## 11. Wie heeft het over 365Inspect+
- [SoteriaSecurity](https://soteria.io/soteria-365-inspect/)

## 12. Speciale Dank Naar...
* [SoteriaSecurity](https://github.com/soteria-security/365Inspect): Voor het toestaan van mij om de vork en deze versie te maken!
* [CISSecurity](https://www.cisecurity.org/cis-benchmarks/): Voor het leveren van de M365-benchmarks om auditscripts te maken

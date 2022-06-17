# 365Inspect+
**De Open-Source, Geautomatiseerde Microsoft 365 Security Assessment Tool**

## Over 365*Inspect+*

365*Inspect+* is een opdrachtregelprogramma dat automatisch een M365-omgeving controleert. 365*Inspect+* haalt configuratie-informatie op uit uw M365-instantie en valideert of een reeks best practices op het gebied van beveiliging is gevolgd. 365*Inspect+* maakt een eenvoudig grafisch HTML-rapport met beschrijvingen van ontdekte beveiligingsfouten en bruikbare aanbevelingen die u kunt gebruiken om de beveiligingsstatus van uw M365-instantie te verbeteren.

365Inspect+ is open-source en volledig gratis. Het is geschreven in PowerShell en het enige dat u nodig hebt om het te gebruiken, zijn de juiste PowerShell-modules en referenties voor uw M365-beheerdersaccount. Voor beveiligingsanalisten ondersteunt 365Inspect ook een eenvoudig modulesysteem waarmee u eenvoudig uw eigen toevoegingen aan de auditfunctionaliteit kunt maken. Dit betekent dat je hem direct 'Out of The Box' kunt gebruiken als een krachtige M365-beveiligingsscanner. 

## Voordelen

Met 365Inspect+ is het mogelijk om:
	
* M365 Environments of klanten met een M365 omgeving te auditen,
	
* Het creëren van additionele modules zogeheten 'inspectors' om de scanner uit te breiden,

* Het maken van een overzichtelijk rapport met de aanbevelingen, kwetsbaarheden en misconfiruaties met betrekking tot de gescande M365 omgeving.

## Verschillen Tussen De Standard en Plus Versie

De volgende verschillen zijn er ten opzichte van de standaard versie:
- Het authenticatieproces is gemakkelijker en verschillend.
- Er is minder output tijdens het authenticeren. Er wordt nu alleen een authenticatie bericht weergegeven als authenticatie is gelukt.
- Er is een module toegevoegd die de verreiste modules naar de meest recente versie updatet
- Er is een module toegevoegd die de verreiste modules installeert indien niet aanwezig.
- De error handling is verbeterd en er is minder repeterende code, waardoor de code schoner is.
- De tool vraagt om Administrator Privileges als deze niet zijn gegeven

## Setup

365*Inspect+* vereist de administratieve PowerShell-modules voor Microsoft Online, Azure AD (we raden aan om de AzureADPreview-module te installeren), Exchange Online Administration, Sharepoint Administration, Microsoft Intune, Microsoft Teams en Microsoft Graph.

Het 365*Inspect*.ps1 PowerShell-script valideert de geïnstalleerde modules.

Als u deze modules niet hebt geïnstalleerd, wordt u gevraagd ze te installeren en met uw goedkeuring zal het script proberen te installeren. Anders zou u ze moeten kunnen installeren met de volgende opdrachten in een beheerders-PowerShell-prompt, of door de instructies te volgen bij de onderstaande verwijzingen:

	Install-Module -Name MSOnline

	Install-Module -Name AzureADPreview

	Install-Module -Name ExchangeOnlineManagement

	Install-Module -Name Microsoft.Online.SharePoint.PowerShell

	Install-Module -Name Microsoft.Graph

	Install-Module -Name MicrosoftTeams

	Install-Module -Name Microsoft.Graph.Intune

[Install MSOnline PowerShell](https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-msonlinev1?view=azureadps-1.0)

[Install Azure AD PowerShell](https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0)

[Install Exchange Online PowerShell](https://docs.microsoft.com/en-us/powershell/exchange/exchange-online-powershell-v2?view=exchange-ps)

[Install SharePoint](https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/connect-sharepoint-online?view=sharepoint-ps)

[Install Microsoft Graph SDK](https://docs.microsoft.com/en-us/graph/powershell/installation)

[Install Microsoft Teams PowerShell Module](https://docs.microsoft.com/en-us/microsoftteams/teams-powershell-install)

[Install Microsoft Intune PowerShell SDK](https://github.com/microsoft/Intune-PowerShell-SDK)

Zodra het bovenstaande is geïnstalleerd, downloadt u de 365*Inspect+* broncodemap van Github met uw browser of door *git clone* te gebruiken.

git clone https://github.com/asterictnl-lvdw/365Inspect.git

Aangezien u 365*Inspect+* uitvoert met beheerdersrechten, moet u het op een logische locatie plaatsen en ervoor zorgen dat de inhoud van de map met write & execute rechten voorziet voor de gebruiker met beheerdersrechten. Dit is vooral belangrijk als u 365*Inspect+* wilt installeren op een locatie waar het vaak wordt uitgevoerd of wordt gebruikt als onderdeel van een geautomatiseerd proces.

## Usage

Om 365*Inspect+* uit te voeren, opent u een PowerShell-console en navigeert u naar de map waarin u 365*Inspect+* hebt gedownload:

	cd 365Inspect

U werkt met 365*Inspect+* door het hoofdscriptbestand 365Inspect+.ps1 uit te voeren vanuit de PowerShell-opdrachtprompt:

	.\365Inspect+.ps1

Het enige dat 365*Inspect+* nodig heeft om uw O365-tenant te inspecteren, is toegang via een O365-account met de juiste machtigingen, dus de meeste opdrachtregelparameters hebben betrekking op de organisatie die wordt beoordeeld en de authenticatiemethode.

Uitvoering van 365*Inspect+* ziet er als volgt uit:

	.\365Inspect.ps1 -OrgName <value> -OutPath <value> (-Username <username> -Password <password> -MFA -SkipUpdateCheck *parameters in de blokhaken zijnoptioneel*)

Om bijvoorbeeld in te loggen door uw inloggegevens in te voeren in een browser met MFA-ondersteuning:

	.\365Inspect.ps1 -OrgName mycompany -OutPath ..\365_report -MFA

365*Inspect+* kan worden uitgevoerd met alleen gespecificeerde Inspector-modules, of omgekeerd, door gespecificeerde modules uit te sluiten.

Om bijvoorbeeld in te loggen door uw inloggegevens in te voeren in een browser met MFA-ondersteuning:

	.\365Inspect.ps1 -OrgName mycompany -OutPath ..\365_report -MFA -SelectedInspectors inspector1, inspector2

or

	.\365Inspect.ps1 -OrgName mycompany -OutPath ..\365_report -MFA -ExcludedInspectors inspector1, inspector2, inspector3

Om de UpdateChecking over te slaan, voegt u gewoon de parameter *-SkipUpdateCheck* toe. Gebruik deze alleen als je de modules niet wilt updaten en alles al geïnstalleerd hebt.

Om de parameters verder uit te splitsen:

* *OrgName* is de naam van de kernorganisatie of "bedrijf" van uw O365-instantie, die zal worden geïnspecteerd.
	* Als je de naam van je organisatie niet weet, kun je navigeren naar de lijst met alle Exchange-domeinen in O365. Het bovenste domein moet *domain_name*.onmicrosoft.com heten. In dat voorbeeld is *domain_name* de naam van uw organisatie en moet deze worden gebruikt bij het uitvoeren van 365*Inspect*. Dit is belangrijk dat dit hetzelfde is als de sharepoint domeinnaam, zodat er geen problemen met authenticeren van het sharepoint domein optreedt. 
* *OutPath* is het pad naar een map waar het door 365*Inspect+* gegenereerde rapport wordt geplaatst.
* *MFA* is een schakelparameter die optioneel is en kan worden gebruikt als authenticatie MFA vereist
* *Username* is een stringparameter die kan worden opgegeven als de gebruikersnaam constant hetzelfde is voor authenticatie
	* De parameter *Password* is optioneel om te gebruiken in combinatie met de *Username* parameter.
* *Password* is een stringparameter waarmee de gebruiker zich kan authenticeren met zijn wachtwoord.
	* De MFA parameter werkt niet samen met de *Password* parameter!
* *SelectedInspectors* is de naam of namen van de inspecteur of inspecteurs die u wilt gebruiken met 365*Inspect+*. Als er meerdere inspecteurs zijn geselecteerd, moeten deze door komma's worden gescheiden. Alleen de genoemde inspecteurs zullen worden uitgevoerd.
* *ExcludedInspectors*  is de naam of namen van de inspecteur of inspecteurs waarvan u wilt voorkomen dat 365*Inspect+* wordt uitgevoerd. Als er meerdere inspecteurs zijn geselecteerd, moeten deze door komma's worden gescheiden. Alle modules andere inbegrepen modules zullen worden uitgevoerd.
* *SkipUpdateCheck* stelt de gebruiker in staat de update- en installatiecontrole over te slaan. Gebruik deze parameter alleen als u weet dat uw modules up-to-date zijn en allemaal correct zijn geïnstalleerd.

Wanneer u 365*Inspect+* uitvoert met *-MFA*, kan dit verschillende grafische aanmeldingsprompts produceren waarop u achtereenvolgens moet inloggen. Dit is normaal omdat Exchange, SharePoint enz. aparte beheermodules hebben en elk een andere inlogsessie vereist. Als u simpelweg het gevraagde aantal keren inlogt, zou 365*Inspect+* moeten beginnen te werken. Er wordt in de toekomst gekeken naar een workaround hoe MFA simpeler kan worden gebruikt door eventueel via een token te authenticeren, zodat met dezelfde token kan worden geauthenticeerd.

Terwijl 365*Inspect+* wordt uitgevoerd, drukt het regelmatig statusupdates af die aangeven welke inspectietaak wordt uitgevoerd.

365*Inspect+* kan enige tijd duren om uit te voeren. Deze tijd schaalt met de omvang en complexiteit van de te testen omgeving. Sommige inspectietaken omvatten bijvoorbeeld het scannen van de accountconfiguratie van alle gebruikers. Dit kan bijna onmiddellijk gebeuren voor een organisatie met 50 gebruikers, of kan hele minuten (!) duren voor een organisatie met 10000.

## Output

365*Inspect+* maakt de map aan die is opgegeven in de parameter *out_path*. Deze directory is het resultaat van de gehele 365*Inspect* inspectie. Het bevat vier aandachtspunten:

* *Report.html*: grafisch rapport dat de M365-beveiligingsproblemen beschrijft die zijn geïdentificeerd door 365*Inspect*, een lijst geeft van O365-objecten die verkeerd zijn geconfigureerd, en hersteladvies geeft.
* *Verschillende tekstbestanden met de naam [Inspector-Name]*: dit zijn onbewerkte uitvoer van inspectiemodules en bevatten een lijst (één item per regel) van verkeerd geconfigureerde O365-objecten die de beschreven beveiligingsfout bevatten. Als een module Inspect-FictionalMFASettings bijvoorbeeld alle gebruikers zou detecteren die geen MFA hebben ingesteld, zou het bestand "Inspect-FictionalMFASettings" in het ZIP-rapport één gebruiker per regel bevatten die geen MFA heeft ingesteld. Deze informatie wordt alleen naar een bestand gedumpt in gevallen waarin meer dan 15 getroffen objecten worden ontdekt. Als er minder dan 15 getroffen objecten worden ontdekt, worden de objecten direct in de hoofdtekst van het HTML-rapport vermeld.
* *Report.zip*: gezipte versie van deze volledige directory, voor gemakkelijke distributie van de resultaten in gevallen waarin sommige inspectiemodules een grote hoeveelheid bevindingen genereerden.
* *Log directory*: 365*Inspect+* logt eventuele fouten die tijdens de uitvoering van de scripts zijn tegengekomen in een logbestand met tijdstempel in de Log-directory

## Necessary Privileges

365*Inspect+* kan niet correct worden uitgevoerd, tenzij het O365-account waarmee u authenticeert de juiste rechten heeft. 365*Inspect* vereist minimaal het volgende:

* Global Administrator
* SharePoint Administrator

We realiseren ons dat dit uiterst tolerante rollen zijn, helaas vanwege het gebruik van Microsoft Graph zijn we beperkt in het gebruik van minder rechten door Microsoft. Toepassings- en cloudtoepassingsbeheerdersrollen (gebruikt om gedelegeerde en toepassingsmachtigingen te verlenen) zijn beperkt in het verlenen van machtigingen voor Microsoft Graph- of Azure AD PowerShell-modules. [https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#application-administrator](https://docs.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#application-administrator) 

## Developing Additional Inspector Modules

365*Inspect+* is ontworpen om eenvoudig uit te breiden, in de hoop dat het individuen en organisaties in staat stelt om ofwel hun eigen 365*Inspect*-modules intern te gebruiken, of die modules te publiceren voor de O365-gemeenschap.

Alle inspectiemodules van 365*Inspect* worden opgeslagen in de map .\inspectors.

Het is eenvoudig om een inspecteur-module te maken. Inspecteurs hebben twee bestanden:

* *ModuleName.ps1*: de PowerShell-broncode van de inspectiemodule. Moet een lijst retourneren van alle O365-objecten die zijn getroffen door een specifiek probleem, weergegeven als tekenreeksen.
* *ModuleName.json*: metadata over de inspecteur zelf. Bijvoorbeeld de naam van de bevinding, beschrijving, herstelinformatie en referenties.

De PowerShell- en JSON-bestandsnamen moeten identiek zijn voor 365*Inspect* om te herkennen dat de twee bij elkaar horen. Er zijn talloze voorbeelden in de ingebouwde reeks modules van 365*Inspect*, maar we zullen hier ook een voorbeeld geven.

### Example

Example .ps1 file, BypassingSafeAttachments.ps1:
```
# Define a function that we will later invoke.
# 365Inspect's built-in modules all follow this pattern.
function Inspect-BypassingSafeAttachments {
	# Query some element of the O365 environment to inspect. Note that we did not have to authenticate to Exchange
	# to fetch these transport rules within this module; assume main 365Inspect harness has logged us in already.
	$safe_attachment_bypass_rules = (Get-TransportRule | Where { $_.SetHeaderName -eq "X-MS-Exchange-Organization-SkipSafeAttachmentProcessing" }).Identity
	
	# If some of the parsed O365 objects were found to have the security flaw this module is inspecting for,
	# return a list of strings representing those objects. This is what will end up as the "Affected Objects"
	# field in the report.
	If ($safe_attachment_bypass_rules.Count -ne 0) {
		return $safe_attachment_bypass_rules
	}
	
	# If none of the parsed O365 objects were found to have the security flaw this module is inspecting for,
	# returning $null indicates to 365Inspect that there were no findings for this module.
	return $null
}

# Return the results of invoking the inspector function.
return Inspect-BypassingSafeAttachments
```

Example .json file, BypassingSafeAttachments.json:
```
{
	"FindingName": "Do Not Bypass the Safe Attachments Filter",
	"Description": "In Exchange, it is possible to create mail transport rules that bypass the Safe Attachments detection capability. The rules listed above bypass the Safe Attachments capability. Consider revie1wing these rules, as bypassing the Safe Attachments capability even for a subset of senders could be considered insecure depending on the context or may be an indicator of compromise.",
	"Remediation": "Navigate to the Mail Flow -> Rules screen in the Exchange Admin Center. Look for the offending rules and begin the process of assessing who created them and whether they are necessary to the continued function of your organization. If they are not, remove the rules.",
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

U hebt zojuist de BypassingSafeAttachments Inspector-module gemaakt. Dat is alles!

365*Inspect+* zal een behoorlijk luide en lelijke foutmelding geven als iets in uw module niet werkt of de 365*Inspect+*-conventies niet volgt, dus controleer de uitvoer van de opdrachtregel.

## About Security

365*Inspect+* is een scriptharnas dat andere inspecteur-scriptmodules uitvoert die zijn opgeslagen in de map .\inspectors. Zoals bij elk ander script dat u met verhoogde bevoegdheden kunt uitvoeren, moet u bepaalde veiligheidshygiënepraktijken in acht nemen:

* Geen enkele niet-vertrouwde gebruiker mag schrijftoegang hebben tot de 365*Inspect+*-map/bestanden, omdat die gebruiker dan scripts of sjablonen daarin kan overschrijven en u ertoe kan brengen kwaadaardige code uit te voeren.
* Er mag geen scriptmodule in .\inspectors worden geplaatst, tenzij u de bron van die scriptmodule vertrouwt.

## Special Thanks To...
* [CISSecurity](https://www.cisecurity.org/cis-benchmarks/): Voor het leveren van de M365-benchmarks om auditscripts te maken

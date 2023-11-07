$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

$skuids = @{
    'ADV_COMMS'                                              = 'Advanced Communications';
    'CDSAICAPACITY'                                          = 'AI Builder Capacity add-on';
    'SPZA_IW'                                                = 'App Connect IW';
    'MCOMEETADV'                                             = 'Microsoft 365 Audio Conferencing';
    'AAD_BASIC'                                              = 'Azure Active Directory Basic';
    'AAD_PREMIUM'                                            = 'Azure Active Directory Premium P1';
    'AAD_PREMIUM_FACULTY'                                    = 'Azure Active Directory Premium P1 for Faculty';
    'AAD_PREMIUM_P2'                                         = 'Azure Active Directory Premium P2';
    'RIGHTSMANAGEMENT'                                       = 'Azure Information Protection Plan 1';
    'SMB_APPS'                                               = 'Business Apps (free)';
    'CDS_DB_CAPACITY'                                        = 'Common Data Service Database Capacity';
    'CDS_DB_CAPACITY_GOV'                                    = 'Common Data Service Database Capacity for Government';
    'CDS_LOG_CAPACITY'                                       = 'Common Data Service Log Capacity';
    'MCOPSTNC'                                               = 'Communications Credtis';
    'CMPA_addon_GCC'                                         = 'Compliance Manager Premium Assessment Add-On for GCC';
    'CRMSTORAGE'                                             = 'Dynamics 365 - Additional Database Storage (Qualified Offer)';
    'CRMINSTANCE'                                            = 'Dynamics 365 - Additional Production Instance (Qualified Offer)';
    'CRMTESTINSTANCE'                                        = 'Dynamics 365 - Additional Non-Production Instance (Qualified Offer)';
    'SOCIAL_ENGAGEMENT_APP_USER'                             = 'Dynamics 365 AI for Market Insights (Preview)';
    'DYN365_ASSETMANAGEMENT'                                 = 'Dynamics 365 Asset Management Addl Assets';
    'DYN365_BUSCENTRAL_ADD_ENV_ADDON'                        = 'Dynamics 365 Business Central Additional Environment Addon';
    'DYN365_BUSCENTRAL_DB_CAPACITY'                          = 'Dynamics 365 Business Central Database Capacity';
    'DYN365_BUSCENTRAL_ESSENTIAL'                            = 'Dynamics 365 Business Central Essentials';
    'DYN365_FINANCIALS_ACCOUNTANT_SKU'                       = 'Dynamics 365 Business Central External Accountant';
    'PROJECT_MADEIRA_PREVIEW_IW_SKU'                         = 'Dynamics 365 Business Central for IWs';
    'DYN365_BUSCENTRAL_PREMIUM'                              = 'Dynamics 365 Business Central Premium';
    'DYN365_BUSCENTRAL_TEAM_MEMBER'                          = 'Dynamics 365 Business Central Team Members';
    'DYN365_ENTERPRISE_PLAN1'                                = 'Dynamics 365 Customer Engagement Plan';
    'DYN365_CUSTOMER_INSIGHTS_VIRAL'                         = 'Dynamics 365 Customer Insights vTrial';
    'Dynamics_365_Customer_Service_Enterprise_viral_trial'   = 'Dynamics 365 Customer Service Enterprise Viral Trial';
    'DYN365_AI_SERVICE_INSIGHTS'                             = 'Dynamics 365 Customer Service Insights Trial';
    'FORMS_PRO'                                              = 'Dynamics 365 Customer Voice Trial';
    'DYN365_CUSTOMER_SERVICE_PRO'                            = 'Dynamics 365 Customer Service Professional';
    'DYN365_CUSTOMER_VOICE_BASE'                             = 'Dynamics 365 Customer Voice';
    'Forms_Pro_AddOn'                                        = 'Dynamics 365 Customer Voice Additional Responses';
    'DYN365_CUSTOMER_VOICE_ADDON'                            = 'Dynamics 365 Customer Voice Additional Responses';
    'Forms_Pro_USL'                                          = 'Dynamics 365 Customer Voice USL';
    'CRM_ONLINE_PORTAL'                                      = 'Dynamics 365 Enterprise Edition - Additional Portal (Qualified Offer)';
    'Dynamics_365_Field_Service_Enterprise_viral_trial'      = 'Dynamics 365 Field Service Viral Trial';
    'DYN365_FINANCE'                                         = 'Dynamics 365 Finance';
    'DYN365_ENTERPRISE_CASE_MANAGEMENT'                      = 'Dynamics 365 for Case Management Enterprise Edition';
    'DYN365_ENTERPRISE_CUSTOMER_SERVICE'                     = 'Dynamics 365 for Customer Service Enterprise Edition';
    'D365_FIELD_SERVICE_ATTACH'                              = 'Dynamics 365 for Field Service Attach to Qualifying Dynamics 365 Base Offer';
    'DYN365_ENTERPRISE_FIELD_SERVICE'                        = 'Dynamics 365 for Field Service Enterprise Edition';
    'DYN365_FINANCIALS_BUSINESS_SKU'                         = 'Dynamics 365 for Financials Business Edition';
    'D365_MARKETING_USER'                                    = 'Dynamics 365 for Marketing USL';
    'DYN365_ENTERPRISE_SALES_CUSTOMERSERVICE'                = 'Dynamics 365 for Sales and Customer Service Enterprise Edition';
    'DYN365_ENTERPRISE_SALES'                                = 'Dynamics 365 for Sales Enterprise Edition';
    'DYN365_BUSINESS_MARKETING'                              = 'Dynamics 365 for Marketing Business Edition';
    'DYN365_REGULATORY_SERVICE'                              = 'Dynamics 365 Regulatory Service - Enterprise Edition Trial';
    'Dynamics_365_Sales_Premium_Viral_Trial'                 = 'Dynamics 365 Sales Premium Viral Trial';
    'D365_SALES_PRO'                                         = 'Dynamics 365 For Sales Professional';
    'D365_SALES_PRO_IW'                                      = 'Dynamics 365 For Sales Professional Trial';
    'D365_SALES_PRO_ATTACH'                                  = 'Dynamics 365 Sales Professional Attach to Qualifying Dynamics 365 Base Offer';
    'DYN365_SCM'                                             = 'Dynamics 365 for Supply Chain Management';
    'SKU_Dynamics_365_for_HCM_Trial'                         = 'Dynamics 365 for Talent';
    'Dynamics_365_Hiring_SKU'                                = 'Dynamics 365 Talent: Attract';
    'DYN365_ENTERPRISE_TEAM_MEMBERS'                         = 'Dynamics 365 for Team Members Enterprise Edition';
    'GUIDES_USER'                                            = 'Dynamics 365 Guides';
    'Dynamics_365_for_Operations_Devices'                    = 'Dynamics 365 Operations - Device';
    'Dynamics_365_for_Operations_Sandbox_Tier2_SKU'          = 'Dynamics 365 Operations - Sandbox Tier 2:Standard Acceptance Testing';
    'Dynamics_365_for_Operations_Sandbox_Tier4_SKU'          = 'Dynamics 365 Operations - Sandbox Tier 4:Standard Performance Testing';
    'DYN365_ENTERPRISE_P1_IW'                                = 'Dynamics 365 P1 Tria for Information Workers';
    'MICROSOFT_REMOTE_ASSIST'                                = 'Dynamics 365 Remote Assist';
    'MICROSOFT_REMOTE_ASSIST_HOLOLENS'                       = 'Dynamics 365 Remote Assist HoloLens';
    'D365_SALES_ENT_ATTACH'                                  = 'Dynamics 365 Sales Enterprise Attach to Qualifying Dynamics 365 Base Offer';
    'DYNAMICS_365_ONBOARDING_SKU'                            = 'Dynamics 365 Talent: Onboard';
    'DYN365_TEAM_MEMBERS'                                    = 'Dynamics 365 Team Members';
    'Dynamics_365_for_Operations'                            = 'Dynamics 365 UNF OPS Plan ENT Edition';
    'EMS_EDU_FACULTY'                                        = 'Enterprise Mobility + Security A3 for Faculty';
    'EMS'                                                    = 'Enterprise Mobility + Security E3';
    'EMSPREMIUM'                                             = 'Enterprise Mobility + Security E5';
    'EMS_GOV'                                                = 'Enterprise Mobility + Security G3 GCC';
    'EMSPREMIUM_GOV'                                         = 'Enterprise Mobility + Security G5 GCC';
    'EOP_ENTERPRISE_PREMIUM'                                 = 'Exchange Enterprise CAL Services (EOP DLP)';
    'EXCHANGESTANDARD'                                       = 'Exchange Online (Plan 1)';
    'EXCHANGESTANDARD_ALUMNI'                                = 'Exchange Online (Plan 1) for Alumni with Yammer';
    'EXCHANGESTANDARD_STUDENT'                               = 'Exchange Online (Plan 1) for Students';
    'EXCHANGESTANDARD_GOV'                                   = 'Exchange Online (Plan 1) for GCC';
    'EXCHANGEENTERPRISE'                                     = 'Exchange Online (Plan 2)';
    'EXCHANGEARCHIVE_ADDON'                                  = 'Exchange Online Archiving for Exchange Online';
    'EXCHANGEARCHIVE'                                        = 'Exchange Online Archiving for Exchange Server';
    'EXCHANGEESSENTIALS'                                     = 'Exchange Online Essentials (ExO P1 Based)';
    'EXCHANGE_S_ESSENTIALS'                                  = 'Exchange Online Essentials';
    'EXCHANGEDESKLESS'                                       = 'Exchange Online Kiosk';
    'EXCHANGETELCO'                                          = 'Exchange Online POP';
    'EOP_ENTERPRISE'                                         = 'Exchange Online Protection';
    'INTUNE_A'                                               = 'Intune';
    'INTUNE_EDU'                                             = 'Intune for Education';
    'AX7_USER_TRIAL'                                         = 'Microsoft Dynamics AX7 User Trial';
    'MFA_STANDALONE'                                         = 'Microsoft Azure Multi-Factor Authentication';
    'THREAT_INTELLIGENCE'                                    = 'Microsoft Defender for Office 365 (Plan 2)';
    'M365EDU_A1'                                             = 'Microsoft 365 A1';
    'M365EDU_A3_FACULTY'                                     = 'Microsoft 365 A3 for Faculty';
    'M365EDU_A3_STUDENT'                                     = 'Microsoft 365 A3 for Students';
    'M365EDU_A3_STUUSEBNFT'                                  = 'Microsoft 365 A3 for students use benefit';
    'M365EDU_A3_STUUSEBNFT_RPA1'                             = 'Microsoft 365 A3 - Unattended License for students use benefit';
    'M365EDU_A5_FACULTY'                                     = 'Microsoft 365 A5 for Faculty';
    'M365EDU_A5_STUDENT'                                     = 'Microsoft 365 A5 for Students';
    'M365EDU_A5_STUUSEBNFT'                                  = 'Microsoft 365 A5 for students use benefit';
    'M365EDU_A5_NOPSTNCONF_STUUSEBNFT'                       = 'Microsoft 365 A5 without Audio Conferencing for students use benefit';
    'O365_BUSINESS'                                          = 'Microsoft 365 Apps for Business';
    'SMB_BUSINESS'                                           = 'Microsoft 365 Apps for Business';
    'OFFICESUBSCRIPTION'                                     = 'Microsoft 365 Apps for Enterprise';
    'OFFICE_PROPLUS_DEVICE1'                                 = 'Microsoft 365 Apps for enterprise (device)';
    'OFFICESUBSCRIPTION_STUDENT'                             = 'Microsoft 365 Apps for Students';
    'OFFICESUBSCRIPTION_FACULTY'                             = 'Microsoft 365 Apps for Faculty';
    'MCOMEETADV_GOV'                                         = 'Microsoft 365 Audio Conferencing for GCC';
    'MCOMEETACPEA'                                           = 'Microsoft 365 Audio Conferencing Pay-Per-Minute - EA';
    'O365_BUSINESS_ESSENTIALS'                               = 'Microsoft 365 Business Basic';
    'SMB_BUSINESS_ESSENTIALS'                                = 'Microsoft 365 Business Basic';
    'O365_BUSINESS_PREMIUM'                                  = 'Microsoft 365 Business Standard';
    'SMB_BUSINESS_PREMIUM'                                   = 'Microsoft 365 Business Standard - Prepaid Legacy';
    'SPB'                                                    = 'Microsoft 365 Business Premium';
    'BUSINESS_VOICE_MED2'                                    = 'Microsoft 365 Business Voice';
    'BUSINESS_VOICE_MED2_TELCO'                              = 'Microsoft 365 Business Voice (US)';
    'BUSINESS_VOICE_DIRECTROUTING'                           = 'Microsoft 365 Business Voice (without calling plan)';
    'BUSINESS_VOICE_DIRECTROUTING_MED'                       = 'Microsoft 365 Business Voice (without Calling Plan) for US';
    'MCOPSTN_5'                                              = 'Microsoft 365 Domestic Calling Plan (120 Minutes)';
    'MCOPSTN_1_GOV'                                          = 'Microsoft 365 Domestic Calling Plan for GCC';
    'SPE_E3'                                                 = 'Microsoft 365 E3';
    'SPE_E3_RPA1'                                            = 'Microsoft 365 E3 - Unattended License';
    'Microsoft_365_E3'                                       = 'Microsoft 365 E3 (500 seats min)_HUB';
    'SPE_E3_USGOV_DOD'                                       = 'Microsoft 365 E3_USGOV_DOD';
    'SPE_E3_USGOV_GCCHIGH'                                   = 'Microsoft 365 E3_USGOV_GCCHIGH';
    'SPE_E5'                                                 = 'Microsoft 365 E5';
    'Microsoft_365_E5'                                       = 'Microsoft 365 E5 (500 seats min)_HUB';
    'DEVELOPERPACK_E5'                                       = 'Microsoft 365 E5 Developer (without Windows and Audio Conferencing)';
    'INFORMATION_PROTECTION_COMPLIANCE'                      = 'Microsoft 365 E5 Compliance';
    'IDENTITY_THREAT_PROTECTION'                             = 'Microsoft 365 E5 Security';
    'IDENTITY_THREAT_PROTECTION_FOR_EMS_E5'                  = 'Microsoft 365 E5 Security for EMS E5';
    'SPE_E5_CALLINGMINUTES'                                  = 'Microsoft 365 E5 with Calling Minutes';
    'SPE_E5_NOPSTNCONF'                                      = 'Microsoft 365 E5 without Audio Conferencing';
    'Microsoft_365_E5_without_Audio_Conferencing'            = 'Microsoft 365 E5 without Audio Conferencing (500 seats min)_HUB';
    'M365_F1'                                                = 'Microsoft 365 F1';
    'SPE_F1'                                                 = 'Microsoft 365 F3';
    'M365_F1_GOV'                                            = 'Microsoft 365 F3 GCC';
    'SPE_F5_COMP'                                            = 'Microsoft 365 F5 Compliance Add-on';
    'SPE_F5_COMP_AR_D_USGOV_DOD'                             = 'Microsoft 365 F5 Compliance Add-on AR (DOD)_USGOV_DOD';
    'SPE_F5_COMP_AR_USGOV_GCCHIGH'                           = 'Microsoft 365 F5 Compliance Add-on AR_USGOV_GCCHIGH';
    'SPE_F5_COMP_GCC'                                        = 'Microsoft 365 F5 Compliance Add-on GCC';
    'SPE_F5_SEC'                                             = 'Microsoft 365 F5 Security Add-on';
    'SPE_F5_SECCOMP'                                         = 'Microsoft 365 F5 Security + Compliance Add-on';
    'M365_G5_GCC'                                            = 'Microsoft 365 GCC G5';
    'FLOW_FREE'                                              = 'Microsoft Flow Free';
    'M365_E5_SUITE_COMPONENTS'                               = 'Microsoft 365 E5 Suite features';
    'M365_F1_COMM'                                           = 'Microsoft 365 F1';
    'M365_G3_GOV'                                            = 'Microsoft 365 G3 GCC';
    'M365_SECURITY_COMPLIANCE_FOR_FLW'                       = 'Microsoft 365 Security and Compliance for Firstline Workers';
    'MICROSOFT_BUSINESS_CENTER'                              = 'Microsoft Business Center';
    'ADALLOM_STANDALONE'                                     = 'Microsoft Cloud App Security';
    'WIN_DEF_ATP'                                            = 'Microsoft Defender for Endpoint';
    'DEFENDER_ENDPOINT_P1'                                   = 'Microsoft Defender for Endpoint P1';
    'MDATP_XPLAT'                                            = 'Microsoft Defender for Endpoint P2_XPLAT';
    'MDATP_Server'                                           = 'Microsoft Defender for Endpoint Server';
    'CRMPLAN2'                                               = 'Microsoft Dynamics CRM Online Basic';
    'ATA'                                                    = 'Microsoft Defender for Identity';
    'ATP_ENTERPRISE_FACULTY'                                 = 'Microsoft Defender for Office 365 (Plan 1) Faculty';
    'ATP_ENTERPRISE_GOV'                                     = 'Microsoft Defender for Office 365 (Plan 1) GCC';
    'THREAT_INTELLIGENCE_GOV'                                = 'Microsoft Defender for Office 365 (Plan 2) GCC';
    'CRMSTANDARD'                                            = 'Microsoft Dynamics CRM Online';
    'IT_ACADEMY_AD'                                          = 'Microsoft Imagine Academy';
    'INTUNE_A_D'                                             = 'Microsoft Intune Device';
    'INTUNE_A_D_GOV'                                         = 'Microsoft Intune Device for Government';
    'POWERAPPS_DEV'                                          = 'Microsoft Power Apps for Developer';
    'POWERAPPS_VIRAL'                                        = 'Microsoft Power Apps Plan 2 Trial';
    'FLOW_P2'                                                = 'Microsoft Power Automate Plan 2';
    'INTUNE_SMB'                                             = 'Microsoft Intune SMB';
    'POWERFLOW_P2'                                           = 'Microsoft Power Apps Plan 2 (Qualified Offer)';
    'STREAM'                                                 = 'Microsoft Stream';
    'STREAM_P2'                                              = 'Microsoft Stream Plan 2';
    'STREAM_STORAGE'                                         = 'Microsoft Stream Storage Add-On (500 GB)';
    'Microsoft_Teams_Audio_Conferencing_select_dial_out'     = 'Microsoft Teams Audio Conferencing select dial-out';
    'TEAMS_FREE'                                             = 'Microsoft Teams (Free)';
    'Teams_Ess'                                              = 'Microsoft Teams Essentials';
    'TEAMS_EXPLORATORY'                                      = 'Microsoft Teams Exploratory';
    'MCOEV'                                                  = 'Microsoft Teams Phone Standard';
    'MCOEV_DOD'                                              = 'Microsoft Teams Phone Standard for DOD';
    'MCOEV_FACULTY'                                          = 'Microsoft Teams Phone Standard for Faculty';
    'MCOEV_GOV'                                              = 'Microsoft Teams Phone Standard for GCC';
    'MCOEV_GCCHIGH'                                          = 'Microsoft Teams Phone Standard for GCCHIGH';
    'MCOEVSMB_1'                                             = 'Microsoft Teams Phone Standard for Small and Medium Business';
    'MCOEV_STUDENT'                                          = 'Microsoft Teams Phone Standard for Students';
    'MCOEV_TELSTRA'                                          = 'Microsoft Teams Phone Standard for TELSTRA';
    'MCOEV_USGOV_DOD'                                        = 'Microsoft Teams Phone Standard_USGOV_DOD';
    'MCOEV_USGOV_GCCHIGH'                                    = 'Microsoft Teams Phone Standard_USGOV_GCCHIGH';
    'PHONESYSTEM_VIRTUALUSER'                                = 'Microsoft Teams Phone Resource Account';
    'PHONESYSTEM_VIRTUALUSER_GOV'                            = 'Microsoft Teams Phone Resource Account for GCC';
    'Microsoft_Teams_Premium'                                = 'Microsoft Teams Premium';
    'Microsoft_Teams_Rooms_Basic'                            = 'Microsoft Teams Rooms Basic';
    'Microsoft_Teams_Rooms_Basic_without_Audio_Conferencing' = 'Microsoft Teams Rooms Basic without Audio Conferencing';
    'Microsoft_Teams_Rooms_Pro'                              = 'Microsoft Teams Rooms Pro';
    'Microsoft_Teams_Rooms_Pro_without_Audio_Conferencing'   = 'Microsoft Teams Rooms Pro without Audio Conferencing';
    'MCOCAP'                                                 = 'Microsoft Teams Shared Devices';
    'MCOCAP_GOV'                                             = 'Microsoft Teams Shared Devices for GCC';
    'MEETING_ROOM'                                           = 'Microsoft Teams Rooms Standard';
    'MEETING_ROOM_NOAUDIOCONF'                               = 'Microsoft Teams Rooms Standard without Audio Conferencing';
    'MS_TEAMS_IW'                                            = 'Microsoft Teams Trial';
    'EXPERTS_ON_DEMAND'                                      = 'Microsoft Threat Experts - Experts on Demand';
    'OFFICE365_MULTIGEO'                                     = 'Multi-Geo Capabilities in Office 365';
    'NONPROFIT_PORTAL'                                       = 'Nonprofit Portal';
    'STANDARDWOFFPACK_FACULTY'                               = 'Office 365 A1 for faculty';
    'STANDARDWOFFPACK_IW_FACULTY'                            = 'Office 365 A1 Plus for faculty';
    'STANDARDWOFFPACK_STUDENT'                               = 'Office 365 A1 for students';
    'STANDARDWOFFPACK_IW_STUDENT'                            = 'Office 365 A1 Plus for students';
    'ENTERPRISEPACKPLUS_FACULTY'                             = 'Office 365 A3 for faculty';
    'ENTERPRISEPACKPLUS_STUDENT'                             = 'Office 365 A3 for students';
    'ENTERPRISEPREMIUM_FACULTY'                              = 'Office 365 A5 for faculty';
    'ENTERPRISEPREMIUM_STUDENT'                              = 'Office 365 A5 for students';
    'EQUIVIO_ANALYTICS'                                      = 'Office 365 Advanced Compliance';
    'EQUIVIO_ANALYTICS_GOV'                                  = 'Office 365 Advanced Compliance for GCC';
    'ATP_ENTERPRISE'                                         = 'Microsoft Defender for Office 365 (Plan 1)';
    'SHAREPOINTSTORAGE_GOV'                                  = 'Office 365 Extra File Storage for GCC';
    'TEAMS_COMMERCIAL_TRIAL'                                 = 'Microsoft Teams Commercial Cloud';
    'ADALLOM_O365'                                           = 'Office 365 Cloud App Security';
    'SHAREPOINTSTORAGE'                                      = 'Office 365 Extra File Storage';
    'STANDARDPACK'                                           = 'Office 365 E1';
    'STANDARDWOFFPACK'                                       = 'Office 365 E2';
    'ENTERPRISEPACK'                                         = 'Office 365 E3';
    'DEVELOPERPACK'                                          = 'Office 365 E3 Developer';
    'ENTERPRISEPACK_USGOV_DOD'                               = 'Office 365 E3_USGOV_DOD';
    'ENTERPRISEPACK_USGOV_GCCHIGH'                           = 'Office 365 E3_USGOV_GCCHIGH';
    'ENTERPRISEWITHSCAL'                                     = 'Office 365 E4';
    'ENTERPRISEPREMIUM'                                      = 'Office 365 E5';
    'ENTERPRISEPREMIUM_NOPSTNCONF'                           = 'Office 365 E5 Without Audio Conferencing';
    'DESKLESSPACK'                                           = 'Office 365 F3';
    'STANDARDPACK_GOV'                                       = 'Office 365 G1 GCC';
    'ENTERPRISEPACK_GOV'                                     = 'Office 365 G3 GCC';
    'ENTERPRISEPREMIUM_GOV'                                  = 'Office 365 G5 GCC';
    'MIDSIZEPACK'                                            = 'Office 365 Midsize Business';
    'LITEPACK'                                               = 'Office 365 Small Business';
    'LITEPACK_P2'                                            = 'Office 365 Small Business Premium';
    'WACONEDRIVESTANDARD'                                    = 'OneDrive for Business (Plan 1)';
    'WACONEDRIVEENTERPRISE'                                  = 'OneDrive for Business (Plan 2)';
    'POWERAPPS_INDIVIDUAL_USER'                              = 'Power Apps and Logic Flows';
    'POWERAPPS_PER_APP_IW'                                   = 'PowerApps per app baseline access';
    'POWERAPPS_PER_APP'                                      = 'Power Apps per app plan';
    'POWERAPPS_PER_APP_NEW'                                  = 'Power Apps per app plan (1 app or portal)';
    'POWERAPPS_PER_USER'                                     = 'Power Apps per user plan';
    'POWERAPPS_PER_USER_GCC'                                 = 'Power Apps per user plan for Government';
    'POWERAPPS_P1_GOV'                                       = 'PowerApps Plan 1 for Government';
    'POWERAPPS_PORTALS_LOGIN_T2'                             = 'Power Apps Portals login capacity add-on Tier 2 (10 unit min)';
    'POWERAPPS_PORTALS_LOGIN_T2_GCC'                         = 'Power Apps Portals login capacity add-on Tier 2 (10 unit min) for Government';
    'POWERAPPS_PORTALS_PAGEVIEW_GCC'                         = 'Power Apps Portals page view capacity add-on for Government';
    'FLOW_BUSINESS_PROCESS'                                  = 'Power Automate per flow plan';
    'FLOW_PER_USER'                                          = 'Power Automate per user plan';
    'FLOW_PER_USER_DEPT'                                     = 'Power Automate per user plan dept';
    'FLOW_PER_USER_GCC'                                      = 'Power Automate per user plan for Government';
    'POWERAUTOMATE_ATTENDED_RPA'                             = 'Power Automate per user with attended RPA plan';
    'POWERAUTOMATE_UNATTENDED_RPA'                           = 'Power Automate unattended RPA add-on';
    'POWER_BI_INDIVIDUAL_USER'                               = 'Power BI';
    'POWER_BI_STANDARD'                                      = 'Power BI (free)';
    'POWER_BI_ADDON'                                         = 'Power BI for Office 365 Add-On';
    'PBI_PREMIUM_P1_ADDON'                                   = 'Power BI Premium P1';
    'PBI_PREMIUM_PER_USER'                                   = 'Power BI Premium Per User';
    'PBI_PREMIUM_PER_USER_ADDON'                             = 'Power BI Premium Per User Add-On';
    'PBI_PREMIUM_PER_USER_DEPT'                              = 'Power BI Premium Per User Dept';
    'POWER_BI_PRO'                                           = 'Power BI Pro';
    'POWER_BI_PRO_CE'                                        = 'Power BI Pro CE';
    'POWER_BI_PRO_DEPT'                                      = 'Power BI Pro Dept';
    'POWER_BI_PRO_FACULTY'                                   = 'Power BI Pro for Faculty';
    'POWERBI_PRO_GOV'                                        = 'Power BI Pro for GCC';
    'VIRTUAL_AGENT_BASE'                                     = 'Power Virtual Agent';
    'CCIBOTS_PRIVPREV_VIRAL'                                 = 'Power Virtual Agents Viral Trial';
    'PROJECTCLIENT'                                          = 'Project for Office 365';
    'PROJECTESSENTIALS'                                      = 'Project Online Essentials';
    'PROJECTESSENTIALS_FACULTY'                              = 'Project Online Essentials for Faculty';
    'PROJECTESSENTIALS_GOV'                                  = 'Project Online Essentials for GCC';
    'PROJECTPREMIUM'                                         = 'Project Online Premium';
    'PROJECTONLINE_PLAN_1'                                   = 'Project Online Premium Without Project Client';
    'PROJECTONLINE_PLAN_2'                                   = 'Project Online With Project for Office 365';
    'PROJECT_P1'                                             = 'Project Plan 1';
    'PROJECT_PLAN1_DEPT'                                     = 'Project Plan 1 (for Department)';
    'PROJECTPROFESSIONAL'                                    = 'Project Plan 3';
    'PROJECT_PLAN3_DEPT'                                     = 'Project Plan 3 (for Department)';
    'PROJECTPROFESSIONAL_FACULTY'                            = 'Project Plan 3 for Faculty';
    'PROJECTPROFESSIONAL_GOV'                                = 'Project Plan 3 for GCC';
    'PROJECTPREMIUM_GOV'                                     = 'Project Plan 5 for GCC';
    'RIGHTSMANAGEMENT_ADHOC'                                 = 'Rights Management Adhoc';
    'RMSBASIC'                                               = 'Rights Management Service Basic Content Protection';
    'DYN365_IOT_INTELLIGENCE_ADDL_MACHINES'                  = 'Sensor Data Intelligence Additional Machines Add-in for Dynamics 365 Supply Chain Management';
    'DYN365_IOT_INTELLIGENCE_SCENARIO'                       = 'Sensor Data Intelligence Scenario Add-in for Dynamics 365 Supply Chain Management';
    'SHAREPOINTSTANDARD'                                     = 'SharePoint Online (Plan 1)';
    'SHAREPOINTENTERPRISE'                                   = 'SharePoint Online (Plan 2)';
    'Intelligent_Content_Services'                           = 'SharePoint Syntex';
    'MCOIMP'                                                 = 'Skype for Business Online (Plan 1)';
    'MCOSTANDARD'                                            = 'Skype for Business Online (Plan 2)';
    'MCOPSTN2'                                               = 'Skype for Business PSTN Domestic and International Calling';
    'MCOPSTN1'                                               = 'Skype for Business PSTN Domestic Calling';
    'MCOPSTN5'                                               = 'Skype for Business PSTN Domestic Calling (120 Minutes)';
    'MCOPSTNPP'                                              = 'Skype for Business PSTN Usage Calling Plan';
    'MCOTEAMS_ESSENTIALS'                                    = 'Teams Phone with Calling Plan';
    'MTR_PREM'                                               = 'Teams Rooms Premium';
    'MCOPSTNEAU2'                                            = 'TELSTRA Calling for O365';
    'UNIVERSAL_PRINT'                                        = 'Universal Print';
    'VISIO_PLAN1_DEPT'                                       = 'Visio Plan 1';
    'VISIO_PLAN2_DEPT'                                       = 'Visio Plan 2';
    'VISIOONLINE_PLAN1'                                      = 'Visio Online Plan 1';
    'VISIOCLIENT'                                            = 'Visio Online Plan 2';
    'VISIOCLIENT_GOV'                                        = 'Visio Plan 2 for GCC';
    'TOPIC_EXPERIENCES'                                      = 'Viva Topics';
    'WIN_ENT_E5'                                             = 'Windows 10/11 Enterprise E5 (Original)';
    'WIN10_ENT_A3_FAC'                                       = 'Windows 10 Enterprise A3 for faculty';
    'WIN10_ENT_A3_STU'                                       = 'Windows 10 Enterprise A3 for students';
    'WIN10_PRO_ENT_SUB'                                      = 'Windows 10 Enterprise E3';
    'WIN10_VDA_E3'                                           = 'Windows 10 Enterprise E3';
    'WIN10_VDA_E5'                                           = 'Windows 10 Enterprise E5';
    'WINE5_GCC_COMPAT'                                       = 'Windows 10 Enterprise E5 Commercial (GCC Compatible)';
    'E3_VDA_only'                                            = 'Windows 10/11 Enterprise E3 VDA';
    'CPC_B_1C_2RAM_64GB'                                     = 'Windows 365 Business 1 vCPU 2 GB 64 GB';
    'CPC_B_2C_4RAM_128GB'                                    = 'Windows 365 Business 2 vCPU 4 GB 128 GB';
    'CPC_B_2C_4RAM_256GB'                                    = 'Windows 365 Business 2 vCPU 4 GB 256 GB';
    'CPC_B_2C_4RAM_64GB'                                     = 'Windows 365 Business 2 vCPU 4 GB 64 GB';
    'CPC_B_2C_8RAM_128GB'                                    = 'Windows 365 Business 2 vCPU 8 GB 128 GB';
    'CPC_B_2C_8RAM_256GB'                                    = 'Windows 365 Business 2 vCPU 8 GB 256 GB';
    'CPC_B_4C_16RAM_128GB'                                   = 'Windows 365 Business 4 vCPU 16 GB 128 GB';
    'CPC_B_4C_16RAM_128GB_WHB'                               = 'Windows 365 Business 4 vCPU 16 GB 128 GB (with Windows Hybrid Benefit)';
    'CPC_B_4C_16RAM_256GB'                                   = 'Windows 365 Business 4 vCPU 16 GB 256 GB';
    'CPC_B_4C_16RAM_512GB'                                   = 'Windows 365 Business 4 vCPU 16 GB 512 GB';
    'CPC_B_8C_32RAM_128GB'                                   = 'Windows 365 Business 8 vCPU 32 GB 128 GB';
    'CPC_B_8C_32RAM_256GB'                                   = 'Windows 365 Business 8 vCPU 32 GB 256 GB';
    'CPC_B_8C_32RAM_512GB'                                   = 'Windows 365 Business 8 vCPU 32 GB 512 GB';
    'CPC_E_1C_2GB_64GB'                                      = 'Windows 365 Enterprise 1 vCPU 2 GB 64 GB';
    'CPC_E_2C_4GB_64GB'                                      = 'Windows 365 Enterprise 2 vCPU 4 GB 64 GB';
    'CPC_E_2C_4GB_128GB'                                     = 'Windows 365 Enterprise 2 vCPU 4 GB 128 GB';
    'CPC_LVL_1'                                              = 'Windows 365 Enterprise 2 vCPU 4 GB 128 GB (Preview)';
    'CPC_E_2C_4GB_256GB'                                     = 'Windows 365 Enterprise 2 vCPU 4 GB 256 GB';
    'CPC_E_2C_8GB_128GB'                                     = 'Windows 365 Enterprise 2 vCPU 8 GB 128 GB';
    'CPC_LVL_2'                                              = 'Windows 365 Enterprise 2 vCPU 8 GB 128 GB (Preview)';
    'CPC_E_2C_8GB_256GB'                                     = 'Windows 365 Enterprise 2 vCPU 8 GB 256 GB';
    'CPC_E_4C_16GB_128GB'                                    = 'Windows 365 Enterprise 4 vCPU 16 GB 128 GB';
    'CPC_E_4C_16GB_256GB'                                    = 'Windows 365 Enterprise 4 vCPU 16 GB 256 GB';
    'CPC_LVL_3'                                              = 'Windows 365 Enterprise 4 vCPU 16 GB 256 GB (Preview)';
    'CPC_E_4C_16GB_512GB'                                    = 'Windows 365 Enterprise 4 vCPU 16 GB 512 GB';
    'CPC_E_8C_32GB_128GB'                                    = 'Windows 365 Enterprise 8 vCPU 32 GB 128 GB';
    'CPC_E_8C_32GB_256GB'                                    = 'Windows 365 Enterprise 8 vCPU 32 GB 256 GB';
    'CPC_E_8C_32GB_512GB'                                    = 'Windows 365 Enterprise 8 vCPU 32 GB 512 GB';
    'Windows_365_S_2vCPU_4GB_64GB'                           = 'Windows 365 Shared Use 2 vCPU 4 GB 64 GB';
    'Windows_365_S_2vCPU_4GB_128GB'                          = 'Windows 365 Shared Use 2 vCPU 4 GB 128 GB';
    'Windows_365_S_2vCPU_4GB_256GB'                          = 'Windows 365 Shared Use 2 vCPU 4 GB 256 GB';
    'Windows_365_S_2vCPU_8GB_128GB'                          = 'Windows 365 Shared Use 2 vCPU 8 GB 128 GB';
    'Windows_365_S_2vCPU_8GB_256GB'                          = 'Windows 365 Shared Use 2 vCPU 8 GB 256 GB';
    'Windows_365_S_4vCPU_16GB_128GB'                         = 'Windows 365 Shared Use 4 vCPU 16 GB 128 GB';
    'Windows_365_S_4vCPU_16GB_256GB'                         = 'Windows 365 Shared Use 4 vCPU 16 GB 256 GB';
    'Windows_365_S_4vCPU_16GB_512GB'                         = 'Windows 365 Shared Use 4 vCPU 16 GB 512 GB';
    'Windows_365_S_8vCPU_32GB_128GB'                         = 'Windows 365 Shared Use 8 vCPU 32 GB 128 GB';
    'Windows_365_S_8vCPU_32GB_256GB'                         = 'Windows 365 Shared Use 8 vCPU 32 GB 256 GB';
    'Windows_365_S_8vCPU_32GB_512GB'                         = 'Windows 365 Shared Use 8 vCPU 32 GB 512 GB';
    'WINDOWS_STORE'                                          = 'Windows Store for Business';
    'WSFB_EDU_FACULTY'                                       = 'Windows Store for Business EDU Faculty';
    'WORKPLACE_ANALYTICS'                                    = 'Microsoft Workplace Analytics';
}

Function Get-TenantLicenseLevel {
    Try {
        $licenses = (Invoke-GraphRequest -Method Get -Uri "https://graph.microsoft.com/beta/subscribedSkus").Value

        $org_licenses = @()

        $messages = @()

        foreach ($license in $Licenses) {
            $message = ''

            $used = $license.ConsumedUnits
            $total = $license.PrepaidUnits.Enabled
            $remaining = $total - $used

            if ($license.SkuPartNumber -match $skuids.Name) {
                $licenseName = $skuids.Get_Item($license.SkuPartNumber)
            }

            $serviceNames = @()
            $servicePlans = ($license.ServicePlans).ServicePlanName
            
            foreach ($serviceplan in $servicePlans) {
                if ($serviceplan -MATCH $skuids.Name) {
                    $serviceNames += $skuids.Get_Item($serviceplan)
                }
            }

            $org_license = [PSCustomObject]@{
                'Name'               = $licenseName
                'Sku'                = $license.SkuPartNumber
                'Consumed Licenses'  = $used
                'Remaining Licenses' = $remaining
                'Total Licenses'     = $total
                'Services'           = ($serviceNames -join ',')
            }

            $org_licenses += $org_license

            $message = "License: $($org_license.Name) SKU: $($org_license.Sku) Licenses Used: $($org_license.'Consumed Licenses') Licenses Remaining: $($org_license.'Remaining Licenses')"
            $messages += $message
        }

        $org_licenses | Export-Csv "$path\TenantLicenseInfo.csv" -NoTypeInformation

        Return $messages
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
        Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $strace
        Write-Verbose "Errors written to log"
    }
}

Return Get-TenantLicenseLevel
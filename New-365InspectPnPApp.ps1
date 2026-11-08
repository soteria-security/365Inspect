<#
.SYNOPSIS
  Creates the Entra ID app registration 365Inspect needs for its SharePoint (PnP.PowerShell) checks.

.DESCRIPTION
  Uses the Microsoft Graph PowerShell module (already a 365Inspect prerequisite), not the
  PnP registration cmdlets, so it does not depend on PnP.PowerShell version quirks.

  What it creates:
    - A single-tenant app registration named $AppName
    - Public client redirect URI http://localhost  (used by -Auth MFA / Connect-PnPOnline -Interactive)
    - "Allow public client flows" = Yes            (used by -Auth DEVICE / Connect-PnPOnline -DeviceLogin)
    - One delegated SharePoint permission: $SharePointScope
    - Admin consent for that scope, granted ONLY to the signed-in admin (not to all users)

  No secrets or certificates are created. Delegated permissions still require the user to hold
  the SharePoint Administrator (or Global Administrator) role for tenant-level reads.

.EXAMPLE
  .\New-365InspectPnPApp.ps1
  .\New-365InspectPnPApp.ps1 -AppName "365Inspect-PnP" -SharePointScope AllSites.FullControl

.NOTES
  Run in PowerShell 7 as a Global Administrator (or Privileged Role Administrator + Application Administrator).
  Copy the Client ID it prints and pass it to 365Inspect with -PnpPowerShellApplicationId.
#>
[CmdletBinding()]
param(
  [string] $AppName = '365Inspect-PnP',
  # 365Inspect's SharePoint inspectors only call Get-PnPTenant. Confirm the minimum scope with:
  #   Get-PnPCommandPermission -CommandName Get-PnPTenant
  [string] $SharePointScope = 'AllSites.FullControl'
)

$ErrorActionPreference = 'Stop'
$spoResourceAppId = '00000003-0000-0ff1-ce00-000000000000'   # Office 365 SharePoint Online

Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes 'Application.ReadWrite.All', 'DelegatedPermissionGrant.ReadWrite.All', 'User.Read' -ContextScope Process -NoWelcome

# Don't create duplicates
$existing = Get-MgApplication -Filter "displayName eq '$AppName'" -All
if ($existing) {
  Write-Warning "An app named '$AppName' already exists (Client ID $($existing[0].AppId)). Use that ID, or delete it and re-run."
  return
}

# Look up the SharePoint delegated scope ID in this tenant rather than hardcoding a GUID
$spoSp = Get-MgServicePrincipal -Filter "appId eq '$spoResourceAppId'"
$scope = $spoSp.Oauth2PermissionScopes | Where-Object { $_.Value -eq $SharePointScope }
if (-not $scope) { throw "SharePoint delegated scope '$SharePointScope' not found." }

$body = @{
  displayName            = $AppName
  signInAudience         = 'AzureADMyOrg'
  isFallbackPublicClient = $true
  publicClient           = @{ redirectUris = @('http://localhost') }
  requiredResourceAccess = @(
    @{
      resourceAppId  = $spoResourceAppId
      resourceAccess = @(@{ id = $scope.Id; type = 'Scope' })
    }
  )
}

Write-Host "Creating app registration '$AppName'..." -ForegroundColor Cyan
$app = New-MgApplication -BodyParameter $body
$sp = New-MgServicePrincipal -AppId $app.AppId

# Grant admin consent for the signed-in admin only (least privilege)
$me = Invoke-MgGraphRequest -Method GET -Uri 'v1.0/me?$select=id,userPrincipalName'
Start-Sleep -Seconds 10   # give the new service principal a moment to replicate
New-MgOauth2PermissionGrant -BodyParameter @{
  clientId    = $sp.Id
  consentType = 'Principal'
  principalId = $me.id
  resourceId  = $spoSp.Id
  scope       = $SharePointScope
} | Out-Null

Write-Host ""
Write-Host "Done. Pass this to 365Inspect:" -ForegroundColor Green
Write-Host "  -PnpPowerShellApplicationId $($app.AppId)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Consent was granted for $($me.userPrincipalName) only. Anyone else running 365Inspect with this app"
Write-Host "will be prompted to consent (or an admin can grant it in Entra > App registrations > API permissions)."
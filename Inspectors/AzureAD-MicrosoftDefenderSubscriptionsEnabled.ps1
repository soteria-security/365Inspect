$ErrorActionPreference = 'SilentlyContinue'

Function Audit-MicrosoftDefenderSubscriptionsEnabled{
$MicrosoftDefenderSubscriptionsEnabled = @()
$output1 = $( $i1 = Get-AzSecurityPricing | Where-Object {$_.Name -eq 'VirtualMachines'} | Select-Object Name, PricingTier ) 2>&1 #Microsoft Defender For Servers
if ($output1.PricingTier -ne "Standard" -and $output1 -notlike '* cannot be null.*'){$MicrosoftDefenderSubscriptionsEnabled += ($output1.Name +""+ $output1.PricingTier)}else{$MicrosoftDefenderSubscriptionsEnabled += "Microsoft Defender For Servers Not Available"}
$output2 = $( $i2 = Get-AzSecurityPricing | Where-Object {$_.Name -eq 'AppServices'} | Select-Object Name, PricingTier ) 2>&1 #Micrisoft Defender For App Service
if ($output2.PricingTier -ne "Standard" -and $output2 -notlike '* cannot be null.*'){$MicrosoftDefenderSubscriptionsEnabled += ($output2.Name +""+ $output2.PricingTier)}else{$MicrosoftDefenderSubscriptionsEnabled += "Microsoft Defender For App Service Not Available"}
$output3 = $( $i3 = Get-AzSecurityPricing | Where-Object {$_.Name -eq 'SqlServers'} | Select-Object Name, PricingTier ) 2>&1 #Microsoft Defender For Azure SQL Database
if ($output3.PricingTier -ne "Standard" -and $output3 -notlike '* cannot be null.*'){$MicrosoftDefenderSubscriptionsEnabled += ($output3.Name +""+ $output3.PricingTier)}else{$MicrosoftDefenderSubscriptionsEnabled += "Microsoft Defender For SQL Database Not Available"}
$output4 = $( $i4 = Get-AzSecurityPricing | Where-Object {$_.Name -eq 'SqlServerVirtualMachines'} | Select-Object Name, PricingTier ) 2>&1 #Microsoft Defender For SQL Servers
if ($output4.PricingTier -ne "Standard" -and $output4 -notlike '* cannot be null.*'){$MicrosoftDefenderSubscriptionsEnabled += ($output4.Name +""+ $output4.PricingTier)}else{$MicrosoftDefenderSubscriptionsEnabled += "Microsoft Defender For SQL Servers Not Available"}
$output5 = $( $i5 = Get-AzSecurityPricing | Where-Object {$_.Name -eq 'StorageAccounts'} | Select-Object Name, PricingTier ) 2>&1 #Microsoft Defender For Storage
if ($output5.PricingTier -ne "Standard" -and $output5 -notlike '* cannot be null.*'){$MicrosoftDefenderSubscriptionsEnabled += ($output5.Name +""+ $output5.PricingTier)}else{$MicrosoftDefenderSubscriptionsEnabled += "Microsoft Defender For Storage Not Available"}
$output6 = $( $i6 = Get-AzSecurityPricing | Where-Object {$_.Name -eq 'KubernetesService'} | Select-Object Name, PricingTier ) 2>&1 #Microsoft Defender For Kubernetes
if ($output6.PricingTier -ne "Standard" -and $output6 -notlike '* cannot be null.*'){$MicrosoftDefenderSubscriptionsEnabled += ($output6.Name +""+ $output6.PricingTier)}else{$MicrosoftDefenderSubscriptionsEnabled += "Microsoft Defender For Kubernetes Not Available"}
$output7 = $( $i7 = Get-AzSecurityPricing | Where-Object {$_.Name -eq 'ContainerRegistry'} | Select-Object Name, PricingTier ) 2>&1 #Microsoft Defender For Container Registries
if ($output7.PricingTier -ne "Standard" -and $output7 -notlike '* cannot be null.*'){$MicrosoftDefenderSubscriptionsEnabled += ($output7.Name +""+ $output7.PricingTier)}else{$MicrosoftDefenderSubscriptionsEnabled += "Microsoft Defender For Container Registries Not Available"}
$output8 = $( $i8 = Get-AzSecurityPricing | Where-Object {$_.Name -eq 'AppServices'} | Select-Object Name, PricingTier ) 2>&1 #Microsoft Defender For Key Vault
if ($output8.PricingTier -ne "Standard" -and $output8 -notlike '* cannot be null.*'){$MicrosoftDefenderSubscriptionsEnabled += ($output8.Name +""+ $output8.PricingTier)}else{$MicrosoftDefenderSubscriptionsEnabled += "Microsoft Defender For Key Vault Not Available"}

if ($MicrosoftDefenderSubscriptionsEnabled){
return $MicrosoftDefenderSubscriptionsEnabled
}
return $null
}
Return Audit-MicrosoftDefenderSubscriptionsEnabled
function Audit-SafeLinksCheckEnabled{
$auditsafelinkscheck = Get-SafeLinksPolicy | select IsEnabled,AllowClickThrough,DoNotAllowClickThrough,ScanUrls,EnableForInternalSenders,EnableSafeLinksForTeams
if ($auditsafelinkscheck.IsEnabled -match 'False' -and $auditsafelinkscheck.AllowClickThrough -match 'True' -and $auditsafelinkscheck.DoNotAllowClickThrough -match 'False' -and $auditsafelinkscheck.ScanUrls -match 'False' -and $auditsafelinkscheck.EnableSafeLinksForTeams -match 'False'){
return $auditsafelinkscheck
}
return $null
}
return Audit-SafeLinksCheckEnabled
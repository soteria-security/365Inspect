function Audit-SafeLinksCheckEnabled{
$auditsafelinkscheckdata = @()
$auditsafelinkscheck = Get-SafeLinksPolicy | select IsEnabled,AllowClickThrough,DoNotAllowClickThrough,ScanUrls,EnableForInternalSenders,EnableSafeLinksForTeams
if ($auditsafelinkscheck.IsEnabled -match 'False' -and $auditsafelinkscheck.AllowClickThrough -match 'True' -and $auditsafelinkscheck.DoNotAllowClickThrough -match 'False' -and $auditsafelinkscheck.ScanUrls -match 'False' -and $auditsafelinkscheck.EnableSafeLinksForTeams -match 'False'){
$auditsafelinkscheckdata += " IsEnabled: "+$auditsafelinkscheck.IsEnabled
$auditsafelinkscheckdata += "`n AllowClickThrough: "+$auditsafelinkscheck.AllowClickThrough
$auditsafelinkscheckdata += "`n DoNotAllowClickThrough: "+$auditsafelinkscheck.DoNotAllowClickThrough
$auditsafelinkscheckdata += "`n ScanUrls: "+$auditsafelinkscheck.ScanUrls
$auditsafelinkscheckdata += "`n EnableSafeLinksForTeams: "+$auditsafelinkscheck.EnableSafeLinksForTeams
return $auditsafelinkscheckdata
}
return $null
}
return Audit-SafeLinksCheckEnabled
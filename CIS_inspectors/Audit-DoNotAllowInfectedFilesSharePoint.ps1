function Audit-DoNotAllowInfectedFileSharePoint{
$DNAIFSP = Get-SPOTenant | Select-Object DisallowInfectedFileDownload
if ($DNAIFSP.DisallowInfectedFileDownload -match 'False'){
return 'DisallowInfectedFileDownload: '+$DNAIFSP.DisallowInfectedFileDownload
}
return $null
}
return Audit-DoNotAllowInfectedFileSharePoint
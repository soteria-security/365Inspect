function Audit-DoNotAllowInfectedFileSharePoint-{
$DNAIFSP = Get-SPOTenant | Select-Object DisallowInfectedFileDownload
if ($DNAIFSP.DisallowInfectedFileDownload -match 'False'){
return $DNAIFSP
}
return $null
}
return Audit-DoNotAllowInfectedFileSharePoint
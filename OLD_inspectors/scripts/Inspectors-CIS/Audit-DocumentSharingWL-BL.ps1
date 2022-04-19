function Audit-DocumentSharingWLBL{
$DocumentSharingWLBL = Get-SPOTenant | select SharingDomainRestrictionMode,SharingAllowedDomainList
if ($DocumentSharingWLBL.SharingDomainRestrictionMode -match 'None' -and $DocumentSharingWLBL.SharingAllowedDomainList -eq $null){
return $DocumentSharingWLBL
}
return $null
}
return Audit-DocumentSharingWLBL
function Audit-DocumentSharingWLBL{
$DocumentSharingWLBLData = @()
$DocumentSharingWLBL = Get-SPOTenant | select SharingDomainRestrictionMode,SharingAllowedDomainList
if ($DocumentSharingWLBL.SharingDomainRestrictionMode -match 'None' -and $DocumentSharingWLBL.SharingAllowedDomainList -eq $null){
foreach ($DocumentSharingWLBLObj in $DocumentSharingWLBL){
$DocumentSharingWLBLData += " SharingDomainRestrictionMode: "+$DocumentSharingWLBL.SharingDomainRestrictionMode
$DocumentSharingWLBLData += "`n SharingAllowedDomainList: "+$DocumentSharingWLBL.SharingAllowedDomainList
}
return $DocumentSharingWLBLData
}
return $null
}
return Audit-DocumentSharingWLBL
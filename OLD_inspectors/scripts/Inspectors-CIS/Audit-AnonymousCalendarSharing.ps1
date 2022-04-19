function Audit-AnonymousCalendarSharing{
$anonymouscalendarsharing = Get-SharingPolicy | Where-Object { $_.Domains -like '*CalendarSharing*'}
if ($anonymouscalendarsharing.Enabled -match "True"){
return $anonymouscalendarsharing
}
return $null
}
return Audit-AnonymousCalendarSharing
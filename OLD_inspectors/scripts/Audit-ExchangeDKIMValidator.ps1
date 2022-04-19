#MANUAL MODIFICATION required!
Connect-ExchangeOnline
$audit = Get-DkimSigningConfig | Where {$_.Enabled -match 'False'}
if ($audit.Enabled.count -igt 0){'Some Domain(s) do not have DKIM Signing Enabled'}else{'All Domains Have DKIM Signing Enabled'}
'Affected Domain(s): '+$audit.Domain
' '
Disconnect-ExchangeOnline
$Domain = Read-Host -Prompt 'Domain Name: '
$audit1 = nslookup -type=txt $Domain
$audit2 = nslookup -type=txt _dmarc.$Domain
if ($audit1 -like '*include:spf.protection.outlook.com*'){'SPF Record is included in DNS'}else{'SPF Record is not included in DNS!'}
if ($audit2 -like '*v=DMARC1;*'){'DMARC-Record Exists'}else{'NO DMARC-Record Existing'}
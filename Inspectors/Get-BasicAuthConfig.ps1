Function Get-BasicAuthConfig {
    $authMethods = @("AllowBasicAuthActiveSync","AllowBasicAuthAutodiscover","AllowBasicAuthImap","AllowBasicAuthMapi","AllowBasicAuthOfflineAddressBook","AllowBasicAuthOutlookService","AllowBasicAuthPop","AllowBasicAuthReportingWebServices","AllowBasicAuthRest","AllowBasicAuthRpc","AllowBasicAuthSmtp","AllowBasicAuthWebServices","AllowBasicAuthPowershell")

    $authPolicy =  Get-AuthenticationPolicy

    foreach ($method in $authMethods){
        If ($authPolicy.$method -eq $true){
            Return $method
        }
    }
    Return $null
}

Return Get-BasicAuthConfig
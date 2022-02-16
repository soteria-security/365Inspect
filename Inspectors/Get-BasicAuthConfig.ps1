Function Get-BasicAuthConfig {
    $authMethods = @("AllowBasicAuthActiveSync","AllowBasicAuthAutodiscover","AllowBasicAuthImap","AllowBasicAuthMapi","AllowBasicAuthOfflineAddressBook","AllowBasicAuthOutlookService","AllowBasicAuthPop","AllowBasicAuthReportingWebServices","AllowBasicAuthRest","AllowBasicAuthRpc","AllowBasicAuthSmtp","AllowBasicAuthWebServices","AllowBasicAuthPowershell")

    $authPolicy =  Get-AuthenticationPolicy

    $methods = @()
    foreach ($method in $authMethods){
        If ($authPolicy.$method -eq $true){
            $methods += $method
        }
    }
    If (!$methods){
    Return $null
    }

    Return $methods
}

Return Get-BasicAuthConfig
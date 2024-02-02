$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

$path = @($out_path)

Function APPolicies {
    $Licenses = ((Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/subscribedSkus").Value).ServicePlans

    $licensed = $Licenses.servicePlanName | Where-Object { $_ -match 'Intune' }

    If ((($licensed | Measure-Object).Count -gt 1) -and (($licensed -match "intune") -and ($licensed -ne "INTUNE_O365"))) {
        #$policies = Get-IntuneAppProtectionPolicy
        
        $iosPolicies = (Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/deviceAppManagement/iosManagedAppProtections").Value
        
        $androidPolicies = (Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/deviceAppManagement/androidManagedAppProtections").Value
        
        $policies = @($iosPolicies, $androidPolicies)

        If ($policies.count -ne 0) {
            Return $true
        }
        Else {
            Return $false
        }
    }
    Else {
        Return 'Unlicensed'
    }
}

Function CompPolicies {
    $Licenses = ((Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/subscribedSkus").Value).ServicePlans

    $licensed = $Licenses.servicePlanName | Where-Object { $_ -match 'Intune' }

    If ((($licensed | Measure-Object).Count -gt 1) -and (($licensed -match "intune") -and ($licensed -ne "INTUNE_O365"))) {
        $compliancePolicies = (Invoke-GraphRequest -method get -uri "https://microsoftgraph.chinacloudapi.cn/beta/deviceManagement/deviceCompliancePolicies").Value
        
        $iosPolicies = $compliancePolicies | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.iosCompliancePolicy' }
        
        $androidPolicies = $compliancePolicies | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.aospDeviceOwnerCompliancePolicy' }

        $policies = @($iosPolicies, $androidPolicies)

        If ($policies.count -ne 0) {
            Return $true
        }
        Else {
            Return $false
        }
    }
    Else {
        Return 'Unlicensed'
    }
}

Function Inspect-ExchangeMobilePolicy {
    $compStatus = CompPolicies
    $appStatus = APPolicies

    If ($compStatus -eq $true -or $appStatus -eq $true) {
        Return $null
    }
    If (($compStatus -eq 'Unlicensed' -and $appStatus -eq 'Unlicensed') -or ($compStatus -eq $false -and $appStatus -eq $false)) {
        Try {
            $mobilePolicy = Get-MobileDeviceMailboxPolicy

            If (($mobilePolicy | Measure-Object).Count -eq 1 -and $mobilePolicy.Name -eq 'Default' -and $mobilePolicy.isDefault -eq $true -and $mobilePolicy.isValid -eq $true) {
                Return $null
            }
            Else {
                $results = @("Review and validate the returned policies:")

                Foreach ($policy in $mobilePolicy) {
                    $results += $policy.Name
                    $policy | ConvertTo-Json -Depth 10 | Out-File "$path\Exchange\$($policy.name)_MobileDeviceMailboxPolicy.json"
                }

                Return $results
            }
        }
        Catch {
            Write-Warning "Error message: $_"
            $message = $_.ToString()
            $exception = $_.Exception
            $strace = $_.ScriptStackTrace
            $failingline = $_.InvocationInfo.Line
            $positionmsg = $_.InvocationInfo.PositionMessage
            $pscommandpath = $_.InvocationInfo.PSCommandPath
            $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
            $scriptname = $_.InvocationInfo.ScriptName
            Write-Verbose "Write to log"
            Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $strace
            Write-Verbose "Errors written to log"
        }
    }
}

Return Inspect-ExchangeMobilePolicy
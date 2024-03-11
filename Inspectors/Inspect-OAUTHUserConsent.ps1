$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspector-OAUTHUserConsent {
    Try {
        $policy = (Get-MgPolicyAuthorizationPolicy)[0]

        $results = $null

        foreach ($permission in $policy.DefaultUserRolePermissions.PermissionGrantPoliciesAssigned) {
            switch ($permission) {
                "ManagePermissionGrantsForSelf.microsoft-user-default-low" {
                        $results = @("User Consent is set to Verified and Registered Apps")
                    }
                "ManagePermissionGrantsForSelf.microsoft-user-default-legacy" {
                        $results = @("User Consent is set to allow users to consent to apps accessing all data.")
                    }
                default {}
            }
        }

        return $results

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
        Write-ErrorLog -message $message -exception $exception -scriptname $scriptname
        Write-Verbose "Errors written to log"
    }
}

return Inspector-OAUTHUserConsent
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-ExternalForwarding {
    Try {
        $mailboxes = Get-Mailbox -ResultSize Unlimited
    
        $knownDomains = (Invoke-GraphRequest -method get -uri "https://$(@($global:graphURI))/beta/organization?$select=verifiedDomains").Value.verifiedDomains.name

        $rulesEnabled = @()

        if ((Test-path "$path\Exchange") -eq $true) {
            $path = "$path\Exchange"
        }
        Else {
            $path = New-Item -ItemType Directory -Force -Path "$($path)\Exchange"
        }

        $externalFWD = @()

        foreach ($mailbox in $mailboxes) {
            $rulesEnabled += Get-InboxRule -Mailbox $mailbox.UserPrincipalName | Where-Object { ($null -ne $_.ForwardTo) -or ($null -ne $_.ForwardAsAttachmentTo) -or ($null -ne $_.RedirectTo) } | Select-Object MailboxOwnerId, RuleIdentity, Name, ForwardTo, RedirectTo, ForwardAsAttachmentTo
        }
        if ($rulesEnabled.Count -gt 0) {

            $fwdTo = @()
            $redirectTo = @()
            $fwdAttachment = @()

            Foreach ($rule in $rulesEnabled) {
                foreach ($x in $rule.ForwardTo) {
                    If ((![string]::IsNullOrWhiteSpace($x)) -and ($x -notmatch "\[EX:/o") -and ($knownDomains -notcontains ((($x -split '@')[1] -split '"')[0]))) {
                        $fwdTo += $rule
                    }
                }
                foreach ($x in $rule.RedirectTo) {
                    If ((![string]::IsNullOrWhiteSpace($x)) -and ($x -notmatch "\[EX:/o") -and ($knownDomains -notcontains ((($x -split '@')[1] -split '"')[0]))) {
                        $redirectTo += $rule
                    }
                }
                foreach ($x in $rule.ForwardAsAttachmentTo) {
                    If ((![string]::IsNullOrWhiteSpace($x)) -and ($x -notmatch "\[EX:/o") -and ($knownDomains -notcontains ((($x -split '@')[1] -split '"')[0]))) {
                        $fwdAttachment += $rule
                    }
                }
            }

            $externalFWD += $fwdTo
            $externalFWD += $fwdAttachment
            $externalFWD += $redirectTo

            $externalFWD  | Export-CSV "$($path)\ExchangeMailboxeswithExternalForwardingRules.csv" -Delimiter ';' -NoTypeInformation -Append
            Return $externalFWD.MailboxOwnerID | Select-Object -Unique
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

Inspect-ExternalForwarding
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Get-InternalMailboxForwarding {
    Try {
        $mailboxes = Get-Mailbox -ResultSize Unlimited

        $knownDomains = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/organization?$select=verifiedDomains").Value.verifiedDomains.name

        $rulesEnabled = @()

        $internalRulesEnabled = @()

        if ((Test-path "$path\Exchange") -eq $true) {
            $path = "$path\Exchange"
        }
        Else {
            $path = New-Item -ItemType Directory -Force -Path "$($path)\Exchange"
        }

        foreach ($mailbox in $mailboxes) {
            $rulesEnabled += Get-InboxRule -Mailbox $mailbox.UserPrincipalName | Where-Object { ($null -ne $_.ForwardTo) -or ($null -ne $_.ForwardAsAttachmentTo) -or ($null -ne $_.RedirectTo) } | Select-Object MailboxOwnerId, RuleIdentity, Name, ForwardTo, RedirectTo, ForwardAsAttachmentTo
        }
        
        if ($rulesEnabled.Count -gt 0) {
            foreach ($domain in $knownDomains) {
                $internalRulesEnabled += $rulesEnabled | Where-Object { ($_.ForwardTo -match "EX:/o=") -or ($_.ForwardAsAttachmentTo -match "EX:/o=") -or ($_.RedirectTo -match "EX:/o=") -or ($_.ForwardTo -like "*$domain") -or ($_.ForwardAsAttachmentTo -like "*$domain") -or ($_.RedirectTo -like "*$domain") }
            }
        }

        if ($internalRulesEnabled.count -gt 0) {
            $internalRulesEnabled | Export-Csv "$($path)\ExchangeMailboxeswithInternalForwardingRules.csv" -Delimiter ';' -NoTypeInformation -Append
            Return $internalRulesenabled.MailboxOwnerID | Select-Object -Unique
        }
        Else {
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

Get-InternalMailboxForwarding
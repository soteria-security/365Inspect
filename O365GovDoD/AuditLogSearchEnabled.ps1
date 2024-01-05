$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling

function Inspect-AuditLogSearchEnabled {
    Try {
        If (-NOT (Get-AdminAuditLogConfig).UnifiedAuditLogIngestionEnabled) {
            return (Get-AdminAuditLogConfig).UnifiedAuditLogIngestionEnabled
        }
        
        return $null
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

return Inspect-AuditLogSearchEnabled
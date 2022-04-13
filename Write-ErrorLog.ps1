$path = @($out_path)

Function Write-ErrorLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,
                    HelpMessage="Error message.")] 
        [string]$message,
        [Parameter( Mandatory=$false,
                    HelpMessage="Exception.")]
        [string]$exception,
        [Parameter(Mandatory=$false, 
                    HelpMessage="Name of the script that is failing.")]
        [string]$scriptname,
        [Parameter(Mandatory=$false,
                    HelpMessage="Script fails at line number.")]
        [string]$failinglinenumber,
        [Parameter(Mandatory=$false,
                    HelpMessage="Failing line.")]
        [string]$failingline,
        [Parameter(Mandatory=$false,
                    HelpMessage="Powershell command path.")]
        [string]$pscommandpath,    
        [Parameter(Mandatory=$false,
                    HelpMessage="Position message.")]
        [string]$positionmsg, 
        [Parameter(Mandatory=$false,
                    HelpMessage="Stack trace.")]
        [string]$stacktrace
    )
    BEGIN {
        $logfolder = "$path\log"
        $errorlog = "$logfolder\ErrorLog.log"
        
        if  ( !( Test-Path -Path $logfolder -PathType "Container" ) ) {
            Write-Verbose "Creating log folder in: $path"
            New-Item -Path $logfolder -ItemType "Container" -ErrorAction Stop
            
            if ( !( Test-Path -Path $errorlog -PathType "Leaf" ) ) {
                Write-Verbose "Creating log file in $logfolder"
                New-Item -Path $errorlog -ItemType "File" -ErrorAction Stop
            }
        }
    }
    PROCESS {
        Write-Verbose "Write errors to log: $errorlog"
        $timestamp = Get-Date
        "   " | Out-File $errorlog -Append
        "************************************************************************************************************" | Out-File $errorlog -Append
        "Error time: $timestamp" | Out-File $errorlog -Append
        "Error message: $message" | Out-File $errorlog -Append
        "Error exception: $exception" | Out-File $errorlog -Append
        "Failed script: $scriptname" | Out-File $errorlog -Append
        "Failed at line number: $failinglinenumber" | Out-File $errorlog -Append
        "Failed at line: $failingline" | Out-File $errorlog -Append
        "Powershell command path: $pscommandpath" | Out-File $errorlog -Append
        "Position message: $positionmsg" | Out-File $errorlog -Append
        "Stack trace: $stacktrace" | Out-File $errorlog -Append
        "------------------------------------------------------------------------------------------------------------" | Out-File $errorlog -Append
        Write-Verbose "Finish writing to Error log file. $errorlog"
    }        
    END {}
}
$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-AADRoles {
    Try {
        $path = New-Item -ItemType Directory -Force -Path "$($path)\AzureAD-Roles"
        $roleAssignments = @()
            
        $definitions = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/roleManagement/directory/roleDefinitions").Value
            
        Foreach ($definition in $definitions) {
            $assignments = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments").Value | Where-Object { $_.roleDefinitionId -eq $definition.id }
            
            foreach ($assignment in $assignments) {
                $objects = (Invoke-GraphRequest -method get -uri "https://graph.microsoft.com/beta/directoryObjects/$($assignment.principalId)")
            
                $results = @()
                Foreach ($object in $objects) {
                    $result = [PSCustomObject]@{
                        'Directory Role' = $definition.displayName
                        'Member Type'    = (($object.'@odata.type') -split ('graph.'))[1]
                        'Member Names'   = $object.displayName
                        'Member ID'      = $object.userPrincipalName
                    }
                    $results += $result
                }
            
                $roleAssignments += $results
            }
        }
            
        $messages = @()

        $roleAssignments = $roleAssignments | Group-Object 'Member Names' | Select-Object Name, @{n = 'Member ID'; e = { If ($null -ne ($_.Group.'Member ID')) { $_.Group.'Member ID' | Select-Object -Unique } } }, @{n = 'Member Type'; e = { If ($null -ne ($_.Group.'Member Type')) { $_.Group.'Member Type' | Select-Object -Unique } } }, @{n = 'Roles'; e = { ($_.Group.'Directory Role') -join ',' } }

        $roleAssignments | Export-Csv "$path\AADRoleAssignments.csv" -NoTypeInformation -Delimiter ";"

        foreach ($term in $roleAssignments) {
            $message = Write-Output "User: $($term.Name); UserPrincipalName: $($term.'Member ID'); Member Type: $($term.'Member Type'); Roles: $($term.Roles)"
            $messages += $message
        }

        Return $messages

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

Return Inspect-AADRoles
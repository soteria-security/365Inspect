function Show-Menu
{
    param (
        [string]$Title = 'GLOBAL ADMIN TOOL V1.0'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' for Create Global Admin."
    Write-Host "2: Press '2' for Delete Global Admin."
    Write-Host "3: Press '3' to display the number of Global Admin Accounts."
    Write-Host "Q: Press 'Q' to quit."
}


Show-Menu –Title 'GLOBAL ADMIN TOOL V1.0'
 $selection = Read-Host "Please make a selection"
 switch ($selection)
 {
       '1' {
     Write-Host
         Create-GlobalAdmin
     } '2' {
         Delete-GlobalAdmin
     } '3' {
         View-GlobalAdmin
     } 'q' {
         return
     }
 }
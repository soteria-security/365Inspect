Add-Type -AssemblyName System.Windows.Forms
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$null = $browser.ShowDialog()
$path = $browser.SelectedPath
$path
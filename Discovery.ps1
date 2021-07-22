$files = @(
    [IO.FileInfo] "${env:windir}\System32\config\SAM",
    [IO.FileInfo] "${env:windir}\System32\config\SECURITY",
    [IO.FileInfo] "${env:windir}\System32\config\SYSTEM"
)
$vulnFound = $false

foreach ($file in $files) {
    $icaclsUsers = & icacls $file.FullName | Select-String 'BUILTIN\\Users'
    if ($icaclsUsers) {
        $vulnFound = $true
        break
    }
}

Write-Output $vulnFound

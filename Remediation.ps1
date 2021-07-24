$files = @(
    [IO.FileInfo] "${env:windir}\System32\config\SAM"
    [IO.FileInfo] "${env:windir}\System32\config\SECURITY"
    [IO.FileInfo] "${env:windir}\System32\config\SYSTEM"
)

foreach ($file in $files) {
    & icacls $file.FullName /remove "Users"
}

& vssadmin List Shadows
if ($LASTEXITCODE -eq 0) {
    # EXIT 0: There are Shadow Copies
    & vssadmin Delete Shadows /For=$env:SystemDrive /Quiet
    
    & vssadmin List Shadows
    if ($LASTEXITCODE -eq 0) {
        # EXIT 0: There are *still* Shadow Copies
    
        # 320MB is min. Will force all oversized, non-deletable copies to get purged by Windows.
        & vssadmin Resize ShadowStorage /For=$env:SystemDrive /On=$env:SystemDrive /MaxSize=320MB
        # Then, reset to unlimited.
        & vssadmin Resize ShadowStorage /For=$env:SystemDrive /On=$env:SystemDrive /MaxSize=UNBOUNDED
    }
}

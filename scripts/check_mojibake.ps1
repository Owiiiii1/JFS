$ErrorActionPreference = 'Stop'

# ASCII-safe checker: detect UTF-8->CP125x style mojibake.
$files = Get-ChildItem -Path "lib/l10n" -Filter "*.arb" -File
$issues = @()

# Build suspicious markers without non-ASCII literals.
$patterns = @(
    ([string][char]0x0420 + [char]0x040E + [char]0x0420), # "РЎР"
    ([string][char]0x0420 + [char]0x0406 + [char]0x0420 + [char]0x201A), # "РІР‚"
    ([string][char]0x0432 + [char]0x0402 + [char]0x20AC), # "вЂ"
    ([string][char]0x0413 + [char]0x0456), # "Гі"
    ([string][char]0x0413 + [char]0x00B1), # "Г±"
    ([string][char]0x0413 + [char]0x040E), # "ГЎ"
    ([string][char]0x0412 + [char]0x00AB), # "В«"
    ([string][char]0x0412 + [char]0x00BB) # "В»"
)

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    foreach ($pattern in $patterns) {
        if ($content.Contains($pattern)) {
            $issues += "$($file.FullName): suspicious mojibake markers found"
            break
        }
    }
}

if ($issues.Count -gt 0) {
    Write-Error ("Mojibake check failed:`n" + ($issues -join "`n"))
    exit 1
}

Write-Output "Mojibake check passed."

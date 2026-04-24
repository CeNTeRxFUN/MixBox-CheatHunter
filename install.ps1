$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repo = 'CeNTeRxFUN/MixBox-CheatHunter'
$asset = 'MixBox-CheatHunter.zip'
$url = "https://github.com/$repo/releases/latest/download/$asset"

$dir = Join-Path $env:TEMP 'MCH'
$zip = "$dir.zip"

Write-Host '[MixBox] Скачивание MixBox CheatHunter...' -ForegroundColor Magenta

Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $zip -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $dir -Force | Out-Null

Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
Expand-Archive -Path $zip -DestinationPath $dir -Force

$script = Get-ChildItem -Path $dir -Filter 'MixBox-CheatHunter.ps1' -Recurse | Select-Object -First 1

if (-not $script) {
    throw 'MixBox-CheatHunter.ps1 не найден после распаковки. Проверь Release ZIP.'
}

$text = [System.IO.File]::ReadAllText($script.FullName, [System.Text.Encoding]::UTF8)
$utf8bom = New-Object System.Text.UTF8Encoding($true)
[System.IO.File]::WriteAllText($script.FullName, $text, $utf8bom)

Write-Host '[MixBox] Запуск проверки...' -ForegroundColor Magenta

powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script.FullName -OpenReport

[CmdletBinding()]
param(
    [string]$MinerDir = '',
    [string]$SetupFile = '',
    [switch]$StartMiner
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($SetupFile)) {
    $SetupFile = Join-Path -Path $PSScriptRoot -ChildPath 'Setup_Settings.txt'
}
if ([string]::IsNullOrWhiteSpace($MinerDir)) {
    $MinerDir = Join-Path -Path $PSScriptRoot -ChildPath 'Duino-Coin AVR Miner 4.3'
}

function Fail([string]$Message, [int]$Code) {
    Write-Host "HIBA: $Message" -ForegroundColor Red
    exit $Code
}

function Read-Setup([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Fail "A setup fajl nem talalhato: $Path" 20
    }
    $values = @{}
    foreach ($line in Get-Content -LiteralPath $Path -Encoding UTF8) {
        $trimmed = $line.Trim()
        if (-not $trimmed -or $trimmed.StartsWith('#')) { continue }
        if ($trimmed -notmatch '^([^=]+)=(.*)$') {
            Fail "Hibas setup sor: $line" 21
        }
        $values[$Matches[1].Trim().ToLowerInvariant()] = $Matches[2].Trim()
    }
    $required = @('username','donate','language','debug','soc_timeout','avr_timeout','discord_presence','periodic_report','mining_key')
    foreach ($key in $required) {
        if (-not $values.ContainsKey($key)) { Fail "Hianyzo setup ertek: $key" 22 }
    }
    if (-not $values.ContainsKey('miner_exe') -or [string]::IsNullOrWhiteSpace($values.miner_exe) -or $values.miner_exe -eq 'ask') {
        $values['miner_exe'] = 'Duino_AVR_Miner_restarter_v1_1.exe'
    }
    if ([string]::IsNullOrWhiteSpace($values.username)) { Fail 'A username nem lehet ures.' 23 }
    if ($values.donate -notmatch '^[0-5]$') { Fail 'A donate erteke 0 es 5 kozotti egesz szam legyen.' 24 }
    foreach ($key in @('debug','discord_presence')) {
        if ($values[$key] -notin @('y','n')) { Fail "A $key erteke y vagy n legyen." 25 }
    }
    foreach ($key in @('soc_timeout','avr_timeout','periodic_report')) {
        $number = 0
        if (-not [int]::TryParse($values[$key], [ref]$number) -or $number -lt 1) {
            Fail "A $key pozitiv egesz szam legyen." 26
        }
    }
    return $values
}

function Select-MinerExecutable([string]$RootDir, [string]$Preference) {
    $executables = @(Get-ChildItem -LiteralPath $RootDir -File -Filter '*.exe' -ErrorAction Stop |
        Where-Object { $_.Name -match '(?i)AVR.*Miner|Miner.*AVR' } |
        Sort-Object Name)

    if ($executables.Count -eq 0) {
        Fail "Nem talalhato AVR Miner EXE a root mappaban: $RootDir" 40
    }

    if (-not [string]::IsNullOrWhiteSpace($Preference) -and $Preference -ne 'ask') {
        $selected = $executables | Where-Object { $_.Name -ieq $Preference } | Select-Object -First 1
        if ($null -eq $selected) {
            Fail "A Setup_Settings.txt fajlban megadott miner_exe nem talalhato: $Preference" 41
        }
        return $selected
    }

    Write-Host ''
    Write-Host 'Valaszd ki, melyik AVR Miner EXE induljon:' -ForegroundColor Cyan
    for ($i = 0; $i -lt $executables.Count; $i++) {
        Write-Host ("  [{0}] {1}" -f ($i + 1), $executables[$i].Name)
    }
    do {
        $answer = Read-Host "Adj meg egy sorszamot (1-$($executables.Count))"
        $choice = 0
        $valid = [int]::TryParse($answer, [ref]$choice) -and $choice -ge 1 -and $choice -le $executables.Count
        if (-not $valid) { Write-Host 'Ervenytelen valasztas.' -ForegroundColor Yellow }
    } until ($valid)
    return $executables[$choice - 1]
}

function Get-CandidatePorts {
    # Ugyanaz az alapelv, mint a Python pyserial list_ports.comports():
    # minden jelenleg letezo Windows soros portot felsorolunk, VID/PID szures nelkul.
    $portMap = @{}

    # Elsodleges forras: Win32_SerialPort
    try {
        foreach ($device in @(Get-CimInstance Win32_SerialPort -ErrorAction Stop)) {
            $port = [string]$device.DeviceID
            if ($port -match '^COM\d+$') {
                $portMap[$port.ToUpperInvariant()] = [PSCustomObject]@{
                    Port = $port.ToUpperInvariant()
                    Number = [int]($port -replace '\D', '')
                    Name = [string]$device.Name
                    PnpId = [string]$device.PNPDeviceID
                }
            }
        }
    } catch { }

    # Masodlagos forras: PnP entitasok. Ez olyan USB-soros portokat is megtalalhat,
    # amelyek Win32_SerialPort alatt nem jelentek meg.
    try {
        foreach ($device in @(Get-CimInstance Win32_PnPEntity -ErrorAction Stop | Where-Object { $_.Name -match '\(COM\d+\)' })) {
            if ([string]$device.Name -match '\((COM\d+)\)') {
                $port = $Matches[1].ToUpperInvariant()
                if (-not $portMap.ContainsKey($port)) {
                    $portMap[$port] = [PSCustomObject]@{
                        Port = $port
                        Number = [int]($port -replace '\D', '')
                        Name = [string]$device.Name
                        PnpId = [string]$device.PNPDeviceID
                    }
                }
            }
        }
    } catch { }

    # Vegso tartalek: a Windows SERIALCOMM registry, a Python list_ports logikajahoz hasonloan.
    try {
        $serialComm = Get-ItemProperty -LiteralPath 'Registry::HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM' -ErrorAction Stop
        foreach ($property in $serialComm.PSObject.Properties) {
            if ($property.Name -notmatch '^PS' -and [string]$property.Value -match '^COM\d+$') {
                $port = ([string]$property.Value).ToUpperInvariant()
                if (-not $portMap.ContainsKey($port)) {
                    $portMap[$port] = [PSCustomObject]@{
                        Port = $port
                        Number = [int]($port -replace '\D', '')
                        Name = 'Windows soros port'
                        PnpId = [string]$property.Name
                    }
                }
            }
        }
    } catch { }

    return @($portMap.Values | Where-Object { $_.Name -notmatch '(?i)Bluetooth' -and $_.PnpId -notmatch '(?i)BTHENUM|Bluetooth' } | Sort-Object Number)
}

if (-not (Test-Path -LiteralPath $MinerDir -PathType Container)) {
    Fail "A miner mappa nem talalhato: $MinerDir" 10
}
$settings = Read-Setup $SetupFile
if ([string]::IsNullOrWhiteSpace($settings.mining_key)) { $settings.mining_key = 'None' }
$ports = @(Get-CandidatePorts)
if ($ports.Count -eq 0) {
    Fail 'A Windows nem listazott egyetlen aktiv soros portot sem. Ellenorizd az Eszkozkezelot es az USB-illesztoprogramokat.' 12
}

$portList = $ports.Port -join ','
$identifiers = 1..$ports.Count -join ','
$configPath = Join-Path $MinerDir 'Settings.cfg'
$newLine = "`r`n"
$config = @(
    '[AVR Miner]'
    "username = $($settings.username)"
    "avrport = $portList"
    "donate = $($settings.donate)"
    "language = $($settings.language)"
    "identifier = $identifiers"
    "debug = $($settings.debug)"
    "soc_timeout = $($settings.soc_timeout)"
    "avr_timeout = $($settings.avr_timeout)"
    "discord_presence = $($settings.discord_presence)"
    "periodic_report = $($settings.periodic_report)"
    "mining_key = $($settings.mining_key)"
) -join $newLine
$config += $newLine

Write-Host 'A Windows altal listazott soros portok es dinamikus indexek:' -ForegroundColor Cyan
for ($i = 0; $i -lt $ports.Count; $i++) {
    Write-Host ("  {0} = {1}  {2}" -f ($i + 1), $ports[$i].Port, $ports[$i].Name)
}

$backupPath = $null
if (Test-Path -LiteralPath $configPath -PathType Leaf) {
    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $backupPath = "$configPath.$stamp.bak"
    Copy-Item -LiteralPath $configPath -Destination $backupPath -Force
}
$tempPath = "$configPath.tmp"
try {
    [System.IO.File]::WriteAllText($tempPath, $config, (New-Object System.Text.UTF8Encoding($false)))
    Move-Item -LiteralPath $tempPath -Destination $configPath -Force
} catch {
    if (Test-Path -LiteralPath $tempPath) { Remove-Item -LiteralPath $tempPath -Force }
    if ($backupPath) { Copy-Item -LiteralPath $backupPath -Destination $configPath -Force }
    Fail "Az iras sikertelen. $($_.Exception.Message)" 15
}

Write-Host "Portok:      $portList" -ForegroundColor Green
Write-Host "Identifier:  $identifiers" -ForegroundColor Green
Write-Host "Felhasznalo: $($settings.username)" -ForegroundColor Green
if ($backupPath) { Write-Host "Mentes: $backupPath" -ForegroundColor DarkGray }

$rootDir = Split-Path -Path $MinerDir -Parent
$selectedExe = Select-MinerExecutable -RootDir $rootDir -Preference $settings.miner_exe
Write-Host "Inditas: $($selectedExe.Name)" -ForegroundColor Green
Start-Process -FilePath $selectedExe.FullName -WorkingDirectory $rootDir
exit 0

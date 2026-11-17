<a id="top"></a>

# Duino-Coin AVR AutoConfig for Windows

> Beginner-friendly automatic COM-port configuration and stable launcher for Duino-Coin AVR Miner 4.3.

## Language navigation

[🇬🇧 English](#english) · [🇩🇪 Deutsch](#deutsch) · [🇭🇺 Magyar](#magyar)

---

<a id="english"></a>

# 🇬🇧 English

[⬆ Back to language navigation](#top) · [🇩🇪 Go to German](#deutsch) · [🇭🇺 Go to Hungarian](#magyar)

## Overview

Duino-Coin AVR AutoConfig is a portable Windows helper designed to make initial setup easier for beginners and improve miner availability.

The tool:

1. lists active Windows serial ports;
2. excludes Bluetooth serial links;
3. sorts the remaining ports by COM number;
4. generates `Duino-Coin AVR Miner 4.3/Settings.cfg` dynamically;
5. creates sequential identifiers from `1` to `N`;
6. creates a timestamped backup of an existing configuration;
7. starts `Duino_AVR_Miner_restarter_v1_1.exe` by default.

## Security and distribution notice

This repository does **not** include Duino-Coin EXE or DLL files. Download the official Duino-Coin Windows package separately.

Never publish your personal:

- `Setup_Settings.txt`;
- `Settings.cfg`;
- Duino-Coin username;
- mining key;
- EXE or DLL files;
- configuration backup files.

## Requirements

- Windows 10 or Windows 11
- Windows PowerShell 5.1 or newer
- Installed USB serial drivers
- Official Duino-Coin AVR Miner 4.3 Windows package
- `Duino_AVR_Miner_restarter_v1_1.exe` in the package root when using the default launcher

## Installation

1. Download or clone this repository.
2. Copy the repository files into the `Duino-Coin_4.3_windows` root folder.
3. Create your local settings file:

```bat
copy Setup_Settings.example.txt Setup_Settings.txt
```

4. Open `Setup_Settings.txt`.
5. Replace `YOUR_DUINO_USERNAME` with your Duino-Coin username.
6. Connect the AVR boards.
7. Close all currently running AVR Miner instances.
8. Run `Frissit_LGT8F328P_portok.bat`.

## Expected folder structure

```text
Duino-Coin_4.3_windows\
├── Frissit_LGT8F328P_portok.bat
├── Update-DuinoPorts.ps1
├── Setup_Settings.txt
├── Duino_AVR_Miner_restarter_v1_1.exe
└── Duino-Coin AVR Miner 4.3\
    ├── Settings.cfg
    └── Translations.json
```

The folder can be moved to another location or drive. The BAT file uses its own location as the root folder and does not depend on a fixed Windows path.

## Configuration example

```ini
username=YOUR_DUINO_USERNAME
donate=1
language=english
debug=n
soc_timeout=10
avr_timeout=10
discord_presence=y
periodic_report=300
mining_key=None
miner_exe=Duino_AVR_Miner_restarter_v1_1.exe
```

### Configuration values

- `username`: your Duino-Coin username;
- `donate`: developer donation level from `0` to `5`;
- `language`: AVR Miner interface language;
- `debug`: debug mode, `y` or `n`;
- `soc_timeout`: network timeout in seconds;
- `avr_timeout`: serial communication timeout in seconds;
- `discord_presence`: Discord Rich Presence, `y` or `n`;
- `periodic_report`: report interval in seconds;
- `mining_key`: use `None` when the account has no mining key;
- `miner_exe`: exact filename of the launcher to start.

If `mining_key` is empty, the updater writes:

```ini
mining_key = None
```

## Dynamic configuration

The following values are generated automatically and should not be entered manually:

```ini
avrport = COM7,COM8,COM9,COM10
identifier = 1,2,3,4
```

The number of identifiers always matches the number of detected serial ports.

For example, if nine suitable serial ports are detected:

```ini
identifier = 1,2,3,4,5,6,7,8,9
```

## Serial-port detection

The updater collects active Windows serial ports from:

1. `Win32_SerialPort`;
2. `Win32_PnPEntity`;
3. `HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM`.

Bluetooth serial links are excluded automatically.

The remaining ports are sorted numerically:

```text
COM7
COM8
COM9
COM10
COM16
```

The serial-port list alone cannot always prove that a connected device is an LGT8F328P board. Disconnect unrelated USB serial devices before running the updater.

## Default stability launcher

The default launcher is:

```ini
miner_exe=Duino_AVR_Miner_restarter_v1_1.exe
```

The restarter can improve availability when the miner closes, freezes, or loses its connection.

If `miner_exe` is missing, empty, or set to `ask`, the updater uses the restarter as the default launcher.

To use another executable, enter its exact filename:

```ini
miner_exe=AVR_Miner.exe
```

The selected EXE must be located directly in the `Duino-Coin_4.3_windows` root folder.

## Backup and recovery

Before replacing an existing `Settings.cfg`, the updater creates a timestamped backup:

```text
Settings.cfg.20261117_164743.bak
```

If writing the new configuration fails, the updater attempts to restore the previous configuration.

## Troubleshooting

### No serial ports found

Check:

- Windows Device Manager;
- the USB cable;
- the USB hub;
- the USB serial driver;
- whether the board appears under **Ports (COM & LPT)**.

### Wrong ports included

Disconnect unrelated USB serial devices before running the BAT file.

Bluetooth serial ports should be excluded automatically.

### Launcher not found

Verify the exact `miner_exe` filename:

```ini
miner_exe=Duino_AVR_Miner_restarter_v1_1.exe
```

The EXE must be in the root folder.

### PowerShell policy error

The BAT file uses:

```powershell
-ExecutionPolicy Bypass
```

This applies only to the launched PowerShell process and does not permanently modify the Windows execution policy.

### Settings file not found

Confirm that this file exists:

```text
Duino-Coin AVR Miner 4.3\Settings.cfg
```

If it does not exist, start the official AVR Miner once and complete its initial configuration.

## Project files

- [Configuration template](Setup_Settings.example.txt)
- [PowerShell updater](Update-DuinoPorts.ps1)
- [Windows launcher](Frissit_LGT8F328P_portok.bat)
- [Security policy](SECURITY.md)
- [Contributing guide](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
- [MIT License](LICENSE)

## Disclaimer

This is an independent community helper and not an official Duino-Coin release.

Duino-Coin and related components belong to their respective owners. The repository distributes only the community-created automation scripts and documentation.

## License

The scripts in this repository are provided under the MIT License. See [LICENSE](LICENSE).

[⬆ Back to language navigation](#top)

---

<a id="deutsch"></a>

# 🇩🇪 Deutsch

[⬆ Zurück zur Sprachauswahl](#top) · [🇬🇧 Zu Englisch](#english) · [🇭🇺 Zu Ungarisch](#magyar)

## Übersicht

Duino-Coin AVR AutoConfig ist ein portables Windows-Hilfsprogramm, das Einsteigern die Einrichtung erleichtert und die Verfügbarkeit des Miners verbessern kann.

Das Programm:

1. listet aktive serielle Windows-Ports auf;
2. schließt serielle Bluetooth-Verbindungen aus;
3. sortiert die übrigen Ports nach COM-Nummer;
4. erzeugt `Duino-Coin AVR Miner 4.3/Settings.cfg` dynamisch;
5. erstellt fortlaufende Kennungen von `1` bis `N`;
6. erstellt eine Sicherung der vorhandenen Konfiguration mit Zeitstempel;
7. startet standardmäßig `Duino_AVR_Miner_restarter_v1_1.exe`.

## Sicherheits- und Verteilungshinweis

Dieses Repository enthält **keine** Duino-Coin-EXE- oder DLL-Dateien. Lade das offizielle Duino-Coin-Windows-Paket separat herunter.

Veröffentliche niemals:

- deine persönliche `Setup_Settings.txt`;
- deine `Settings.cfg`;
- deinen Duino-Coin-Benutzernamen;
- deinen Mining Key;
- EXE- oder DLL-Dateien;
- Sicherungskopien der Konfiguration.

## Voraussetzungen

- Windows 10 oder Windows 11
- Windows PowerShell 5.1 oder neuer
- Installierte USB-Seriell-Treiber
- Offizielles Duino-Coin AVR Miner 4.3 Windows-Paket
- `Duino_AVR_Miner_restarter_v1_1.exe` im Stammordner bei Verwendung des Standard-Starters

## Installation

1. Lade dieses Repository herunter oder klone es.
2. Kopiere die Repository-Dateien in den Stammordner `Duino-Coin_4.3_windows`.
3. Erstelle die lokale Einstellungsdatei:

```bat
copy Setup_Settings.example.txt Setup_Settings.txt
```

4. Öffne `Setup_Settings.txt`.
5. Ersetze `YOUR_DUINO_USERNAME` durch deinen Duino-Coin-Benutzernamen.
6. Schließe die AVR-Boards an.
7. Beende alle laufenden AVR-Miner-Instanzen.
8. Starte `Frissit_LGT8F328P_portok.bat`.

## Erwartete Ordnerstruktur

```text
Duino-Coin_4.3_windows\
├── Frissit_LGT8F328P_portok.bat
├── Update-DuinoPorts.ps1
├── Setup_Settings.txt
├── Duino_AVR_Miner_restarter_v1_1.exe
└── Duino-Coin AVR Miner 4.3\
    ├── Settings.cfg
    └── Translations.json
```

Der Ordner kann an einen anderen Speicherort oder auf ein anderes Laufwerk verschoben werden. Die BAT-Datei verwendet ihren eigenen Speicherort als Stammordner und benötigt keinen fest eingetragenen Windows-Pfad.

## Konfigurationsbeispiel

```ini
username=YOUR_DUINO_USERNAME
donate=1
language=english
debug=n
soc_timeout=10
avr_timeout=10
discord_presence=y
periodic_report=300
mining_key=None
miner_exe=Duino_AVR_Miner_restarter_v1_1.exe
```

### Konfigurationswerte

- `username`: dein Duino-Coin-Benutzername;
- `donate`: Spendenstufe von `0` bis `5`;
- `language`: Sprache der AVR-Miner-Oberfläche;
- `debug`: Debug-Modus, `y` oder `n`;
- `soc_timeout`: Netzwerk-Zeitüberschreitung in Sekunden;
- `avr_timeout`: Zeitüberschreitung der seriellen Kommunikation in Sekunden;
- `discord_presence`: Discord Rich Presence, `y` oder `n`;
- `periodic_report`: Berichtsintervall in Sekunden;
- `mining_key`: verwende `None`, wenn das Konto keinen Mining Key besitzt;
- `miner_exe`: exakter Dateiname des zu startenden Programms.

Wenn `mining_key` leer ist, schreibt das Programm:

```ini
mining_key = None
```

## Dynamische Konfiguration

Die folgenden Werte werden automatisch erzeugt und müssen nicht manuell eingegeben werden:

```ini
avrport = COM7,COM8,COM9,COM10
identifier = 1,2,3,4
```

Die Anzahl der Kennungen entspricht immer der Anzahl der erkannten seriellen Ports.

Wenn beispielsweise neun geeignete Ports erkannt werden:

```ini
identifier = 1,2,3,4,5,6,7,8,9
```

## Erkennung serieller Ports

Das Programm sammelt aktive serielle Windows-Ports aus:

1. `Win32_SerialPort`;
2. `Win32_PnPEntity`;
3. `HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM`.

Serielle Bluetooth-Verbindungen werden automatisch ausgeschlossen.

Die verbleibenden Ports werden numerisch sortiert:

```text
COM7
COM8
COM9
COM10
COM16
```

Anhand der Portliste allein kann nicht immer sicher festgestellt werden, ob hinter einem Port ein LGT8F328P-Board angeschlossen ist. Trenne andere USB-Seriell-Geräte, bevor das Programm ausgeführt wird.

## Standard-Stabilitätsstarter

Der Standard-Starter ist:

```ini
miner_exe=Duino_AVR_Miner_restarter_v1_1.exe
```

Der Restarter kann die Verfügbarkeit verbessern, wenn der Miner beendet wird, nicht mehr reagiert oder die Verbindung verliert.

Wenn `miner_exe` fehlt, leer ist oder auf `ask` gesetzt wurde, verwendet das Programm automatisch den Restarter.

Für einen anderen Starter muss der exakte Dateiname angegeben werden:

```ini
miner_exe=AVR_Miner.exe
```

Die ausgewählte EXE muss sich direkt im Stammordner `Duino-Coin_4.3_windows` befinden.

## Sicherung und Wiederherstellung

Vor dem Ersetzen einer vorhandenen `Settings.cfg` wird eine Sicherung mit Zeitstempel erstellt:

```text
Settings.cfg.20261117_164743.bak
```

Wenn das Schreiben der neuen Konfiguration fehlschlägt, versucht das Programm, die bisherige Konfiguration wiederherzustellen.

## Fehlerbehebung

### Keine seriellen Ports gefunden

Prüfe:

- den Windows-Geräte-Manager;
- das USB-Kabel;
- den USB-Hub;
- den USB-Seriell-Treiber;
- ob das Board unter **Anschlüsse (COM & LPT)** angezeigt wird.

### Falsche Ports enthalten

Trenne andere USB-Seriell-Geräte, bevor die BAT-Datei gestartet wird.

Serielle Bluetooth-Ports sollten automatisch ausgeschlossen werden.

### Starter nicht gefunden

Prüfe den exakten Wert von `miner_exe`:

```ini
miner_exe=Duino_AVR_Miner_restarter_v1_1.exe
```

Die EXE-Datei muss sich im Stammordner befinden.

### PowerShell-Richtlinienfehler

Die BAT-Datei verwendet:

```powershell
-ExecutionPolicy Bypass
```

Diese Einstellung gilt nur für den gestarteten PowerShell-Prozess und ändert die Windows-Ausführungsrichtlinie nicht dauerhaft.

### Einstellungsdatei nicht gefunden

Prüfe, ob diese Datei vorhanden ist:

```text
Duino-Coin AVR Miner 4.3\Settings.cfg
```

Wenn die Datei fehlt, starte den offiziellen AVR Miner einmal und führe die Ersteinrichtung durch.

## Projektdateien

- [Konfigurationsvorlage](Setup_Settings.example.txt)
- [PowerShell-Aktualisierung](Update-DuinoPorts.ps1)
- [Windows-Starter](Frissit_LGT8F328P_portok.bat)
- [Sicherheitsrichtlinie](SECURITY.md)
- [Leitfaden zur Mitarbeit](CONTRIBUTING.md)
- [Änderungsprotokoll](CHANGELOG.md)
- [MIT-Lizenz](LICENSE)

## Haftungsausschluss

Dies ist ein unabhängiges Community-Hilfsprogramm und keine offizielle Duino-Coin-Version.

Duino-Coin und zugehörige Komponenten gehören den jeweiligen Rechteinhabern. Das Repository verteilt ausschließlich die von der Community erstellten Automatisierungsskripte und die Dokumentation.

## Lizenz

Die Skripte in diesem Repository stehen unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).

[⬆ Zurück zur Sprachauswahl](#top)

---

<a id="magyar"></a>

# 🇭🇺 Magyar

[⬆ Vissza a nyelvválasztóhoz](#top) · [🇬🇧 Ugrás az angol részhez](#english) · [🇩🇪 Ugrás a német részhez](#deutsch)

## Áttekintés

A Duino-Coin AVR AutoConfig egy hordozható Windows-segédprogram, amely egyszerűbbé teszi a kezdők első beállítását, és javíthatja a miner rendelkezésre állását.

A program:

1. felsorolja az aktív Windows soros portokat;
2. kizárja a Bluetooth soros kapcsolatokat;
3. COM-szám szerint rendezi a megmaradt portokat;
4. dinamikusan létrehozza a `Duino-Coin AVR Miner 4.3/Settings.cfg` fájlt;
5. `1` és `N` közötti folyamatos azonosítókat készít;
6. időbélyeges biztonsági másolatot készít a meglévő konfigurációról;
7. alapértelmezetten elindítja a `Duino_AVR_Miner_restarter_v1_1.exe` fájlt.

## Biztonsági és terjesztési tudnivalók

Ez a repository **nem tartalmazza** a Duino-Coin EXE- vagy DLL-fájljait. A hivatalos Duino-Coin Windows-csomagot külön kell letölteni.

Soha ne töltsd fel nyilvánosan:

- a személyes `Setup_Settings.txt` fájlt;
- a létrehozott `Settings.cfg` fájlt;
- a Duino-Coin felhasználónevedet;
- a mining key értékét;
- az EXE- vagy DLL-fájlokat;
- a konfiguráció biztonsági mentéseit.

## Követelmények

- Windows 10 vagy Windows 11
- Windows PowerShell 5.1 vagy újabb
- Telepített USB-soros illesztőprogram
- Hivatalos Duino-Coin AVR Miner 4.3 Windows-csomag
- `Duino_AVR_Miner_restarter_v1_1.exe` a root mappában az alapértelmezett indító használatához

## Telepítés

1. Töltsd le vagy klónozd ezt a repositoryt.
2. Másold a repository fájljait a `Duino-Coin_4.3_windows` root mappába.
3. Készítsd el a helyi beállítási fájlt:

```bat
copy Setup_Settings.example.txt Setup_Settings.txt
```

4. Nyisd meg a `Setup_Settings.txt` fájlt.
5. Cseréld le a `YOUR_DUINO_USERNAME` értéket a Duino-Coin felhasználónevedre.
6. Csatlakoztasd az AVR paneleket.
7. Zárd be az AVR Miner minden futó példányát.
8. Indítsd el a `Frissit_LGT8F328P_portok.bat` fájlt.

## Elvárt mappaszerkezet

```text
Duino-Coin_4.3_windows\
├── Frissit_LGT8F328P_portok.bat
├── Update-DuinoPorts.ps1
├── Setup_Settings.txt
├── Duino_AVR_Miner_restarter_v1_1.exe
└── Duino-Coin AVR Miner 4.3\
    ├── Settings.cfg
    └── Translations.json
```

A teljes mappa szabadon áthelyezhető másik könyvtárba vagy meghajtóra. A BAT fájl mindig a saját helyét használja root mappaként, ezért nincs benne rögzített helyi Windows-elérési út.

## Konfigurációs példa

```ini
username=YOUR_DUINO_USERNAME
donate=1
language=english
debug=n
soc_timeout=10
avr_timeout=10
discord_presence=y
periodic_report=300
mining_key=None
miner_exe=Duino_AVR_Miner_restarter_v1_1.exe
```

### Konfigurációs értékek

- `username`: a Duino-Coin felhasználónév;
- `donate`: fejlesztői támogatási szint `0` és `5` között;
- `language`: az AVR Miner felületének nyelve;
- `debug`: hibakeresési mód, értéke `y` vagy `n`;
- `soc_timeout`: hálózati időtúllépés másodpercben;
- `avr_timeout`: soros kommunikációs időtúllépés másodpercben;
- `discord_presence`: Discord Rich Presence, értéke `y` vagy `n`;
- `periodic_report`: időszakos jelentés gyakorisága másodpercben;
- `mining_key`: ha nincs mining key, az értéke `None`;
- `miner_exe`: az elindítandó program pontos fájlneve.

Ha a `mining_key` értéke üres, a program ezt írja a konfigurációba:

```ini
mining_key = None
```

## Dinamikusan létrehozott értékek

Az alábbi értékeket a program automatikusan állítja elő, ezért ezeket nem kell kézzel megadni:

```ini
avrport = COM7,COM8,COM9,COM10
identifier = 1,2,3,4
```

Az `identifier` elemeinek száma mindig megegyezik a felismert soros portok számával.

Ha például kilenc megfelelő soros portot talál:

```ini
identifier = 1,2,3,4,5,6,7,8,9
```

## Soros portok felismerése

A program az akt_Miner_restarter_v1_1.exe
```

A restarter javíthatja a rendelkezésre állást, ha a miner leáll, lefagy vagy elveszíti a kapcsolatot.

Ha a `miner_exe`:

- hiányzik;
- üres;
- vagy az értéke `ask`;

akkor a program automatikusan a restartert használja.

Más indító használatához add meg annak pontos fájlnevét:

```ini
miner_exe=AVR_Miner.exe
```

A kiválasztott EXE-fájlnak közvetlenül a `Duino-Coin_4.3_windows` root mappában kell lennie.

## Biztonsági mentés és visszaállítás

A meglévő `Settings.cfg` cseréje előtt a program időbélyeges biztonsági mentést készít:

```text
Settings.cfg.20261117_164743.bak
```

Ha az új konfiguráció írása sikertelen, a program megpróbálja visszaállítani a korábbi konfigurációt.

## Hibaelhárítás

### Nem található soros port

Ellenőrizd:

- a Windows Eszközkezelőt;
- az USB-kábelt;
- az USB-hubot;
- az USB-soros illesztőprogramot;
- hogy a panel megjelenik-e a **Portok (COM és LPT)** részben.

### Nem megfelelő portok kerültek a listába

A BAT futtatása előtt válaszd le azokat az USB-soros eszközöket, amelyek nem tartoznak a minerhez.

A Bluetooth soros portokat a program automatikusan kizárja.

### Nem található az indító

Ellenőrizd a `miner_exe` pontos értékét:

```ini
miner_exe=Duino_AVR_Miner_restarter_v1_1.exe
```

Az EXE-fájlnak a root mappában kell lennie.

### PowerShell-házirend hiba

A BAT ezt a paramétert használja:

```powershell
-ExecutionPolicy Bypass
```

Ez csak az elindított PowerShell-folyamatra vonatkozik, és nem módosítja tartósan a Windows végrehajtási házirendjét.

### Nem található a Settings.cfg

Ellenőrizd, hogy létezik-e ez a fájl:

```text
Duino-Coin AVR Miner 4.3\Settings.cfg
```

Ha nem létezik, indítsd el egyszer a hivatalos AVR Minert, és végezd el az első beállítást.

## Projektfájlok

- Setup_Settings.example.txt
- Update-DuinoPorts.ps1
- Frissit_LGT8F328P_portok.bat
- SECURITY.md
- CONTRIBUTING.md
- [Változásnapló](CHANGELOG.md)
- LICENSE

## Jogi nyilatkozat

Ez egy független közösségi segédprogram, nem a Duino-Coin hivatalos kiadása.

A Duino-Coin név és a kapcsolódó összetevők a saját jogosultjaikhoz tartoznak. A repository kizárólag a közösségi automatizáló szkripteket és dokumentációt terjeszti.

## Licenc

A repository saját szkriptjei MIT licenc alatt használhatók. Lásd: LICENSE.

#top

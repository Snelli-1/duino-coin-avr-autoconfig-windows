# Duino-Coin AVR AutoConfig for Windows

Kezdőbarát, hordozható segédprogram a Duino-Coin AVR Miner 4.3 Windows-változatához.

## Mit csinál?

1. Felsorolja az aktív Windows soros portokat.
2. Kihagyja a Bluetooth soros portokat.
3. COM-szám szerint rendezi az USB-soros portokat.
4. Dinamikusan létrehozza a `Duino-Coin AVR Miner 4.3/Settings.cfg` fájlt.
5. Automatikusan `1,2,3...N` azonosítókat rendel a portokhoz.
6. Alapértelmezetten elindítja a `Duino_AVR_Miner_restarter_v1_1.exe` fájlt.

## Fontos

Ez a repository **nem tartalmazza** a Duino-Coin programot vagy annak EXE-fájljait. A hivatalos Duino-Coin kiadást külön kell letölteni a projekt hivatalos forrásából. Ne tölts fel felhasználónevet, mining key-t vagy személyes `Settings.cfg` fájlt.

## Követelmények

- Windows 10 vagy Windows 11
- Windows PowerShell 5.1 vagy újabb
- Telepített USB-soros illesztőprogram
- A hivatalos Duino-Coin AVR Miner 4.3 Windows-csomag

## Telepítés

1. Töltsd le vagy klónozd ezt a repositoryt.
2. Másold a fájlokat a `Duino-Coin_4.3_windows` root mappába.
3. Másold át a sablont:

```bat
copy Setup_Settings.example.txt Setup_Settings.txt
```

4. Nyisd meg a `Setup_Settings.txt` fájlt, és állítsd be a felhasználónevet.
5. Futtasd a `Frissit_LGT8F328P_portok.bat` fájlt.

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

## Beállítási sablon

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

Másik indító használatához add meg a pontos EXE-fájlnevet a `miner_exe` értékeként.

## Biztonsági mentés

A meglévő `Settings.cfg` minden módosítás előtt időbélyeges `.bak` mentést kap.

## Hibaelhárítás

- **Nem található soros port:** ellenőrizd az Eszközkezelőt, az USB-kábelt és az illesztőprogramot.
- **Nem található EXE:** ellenőrizd a `miner_exe` pontos fájlnevét és azt, hogy az EXE a root mappában van-e.
- **ExecutionPolicy hiba:** a BAT a helyi PowerShell-folyamathoz `Bypass` módot használ, a rendszerházirendet nem módosítja.

## Jogi megjegyzés

Ez egy független közösségi segédprogram, nem a Duino-Coin hivatalos kiadása. A Duino-Coin név és a kapcsolódó komponensek a saját jogosultjaikhoz tartoznak.

## Licenc

A repository saját szkriptjei MIT licenc alatt használhatók. Lásd: `LICENSE`.

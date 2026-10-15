# Well Dweller Ultrawide

A drop-in [SUWSF](https://github.com/PhantomGamers/SUWSF) configuration for Well Dweller. Adds **3440×1440** and **5120×2160** with wider gameplay, centered menus and HUD, correct proportions, and lighting coverage across the screen. The selected resolution is remembered between launches.

Keeps title artwork proportional, extends loading/fade overlays across the display, and preserves the gameplay image behind the pause menu.

## Install

1. Close the game. If you used the old executable patch, restore your original executable first using Steam's **Verify integrity of game files**.
2. Download the ZIP from [Releases](https://github.com/ollieatkinson/well-dweller-ultrawide/releases/latest).
3. Extract its contents beside `WellDweller.exe` (Steam → Manage → Browse local files).
4. Launch the game and select **3440×1440** or **5120×2160**. These replace the 2560×1440 and 4096×2160 entries; 2560×1600 remains available.

Restart after changing resolution to refresh cached lighting effects.

**Linux/Proton:** add `WINEDLLOVERRIDES="version=n,b" %command%` to Steam launch options. Windows may require the [x64 Visual C++ redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe).

## Remove

Close the game and delete `version.dll`, `SUWSF.asi`, `SUWSF.ini`, and the `WellDwellerUltrawide` documentation folder. Remove the launch option on Proton. Original game files and saves are unchanged.

## Compatibility

Targets the Windows x64 executable from Steam build **25633433**. Tested in gameplay, title/loading screens, and pause menus at **5120×2160 on Proton**. The 3440×1440 calculations are verified; visual testing at that resolution and on Windows is pending. Other builds are unsupported. Scripted camera framing and small rooms may retain their original boundaries.

## Build

Requires CMake 3.24+ and GNU binutils for x86-64 ELF, available on Linux. No game files or Python are needed.

```sh
cmake -S . -B build
cmake --build build --target package
```

`src/hooks.s` contains the runtime hooks; `src/patches.s` and `src/layout.ld` place their relative branches. CMake assembles these into `build/SUWSF.ini` using `src/SUWSF.ini.in`. SUWSF writes the code into unused executable padding and keeps its state in unused writable padding, entirely in memory. No custom DLL is built.

`CMakeLists.txt` pins SUWSF and Ultimate ASI Loader downloads with SHA-256 hashes. Actions builds on `trunk`; `v*` tags publish the ZIP and checksum. Players only need the release ZIP.

Thanks to **PhantomGamers** for SUWSF and **ThirteenAG** for Ultimate ASI Loader. Configuration, assembly, and packaging: MIT. [Third-party licenses](THIRD_PARTY_NOTICES.md). Unofficial community fix.

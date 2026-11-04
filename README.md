# Dhalmel Shaft — client-side FFXI DAT mod

Every Dhalmel's neck and head is replaced with one procedural purple shaft. It rises from
the shoulder seam along the neck's own centerline, blended across the neck bones so it
bends like the neck, and ends past the head on the head joint so it nods with every head
animation. Client-side only, delivered through a Pivot overlay — the game's own files are
never modified, and only this machine sees it.

![purple](https://img.shields.io/badge/scope-client--only-9A2BD8) ![pivot](https://img.shields.io/badge/load%20via-XIPivot-blue)

---

## Contents

```
overlay/DhalmelShaft/ROM/5/15.DAT    the modded model (501,024 bytes)
tools/verify-pivot.ps1               resolves Pivot's config and checks precedence
SHA256SUMS.txt                       integrity hash
README.md                            this file
```

## Requirements

- **XIPivot** installed and loading. Check with `/pivot` in game.
  On this machine that is `C:\PhoenixXI\polplugins\pivot.dll`.
- Pivot's overlay root, read from Pivot's config (`root_path`), not guessed.
  On this machine: `C:\PhoenixXI\polplugins\DATs`.

## Install

Copy the `DhalmelShaft` folder into Pivot's overlay root so the file lands at:

```
<overlay root>\DhalmelShaft\ROM\5\15.DAT
```

Then in game: **restart the client.** Pivot resolves DATs at load, so a reload is not enough.

### Already done on this machine

Both steps below are complete; nothing is required but a client restart.

**1. File placed** at `C:\PhoenixXI\polplugins\DATs\DhalmelShaft\ROM\5\15.DAT`
(501,024 bytes, SHA-256 `86f9a5b7…561ad3`), sitting directly alongside `NextHD`.

**2. Registered in Pivot's config** — `C:\PhoenixXI\config\pivot\pivot.ini`:

```ini
[settings]
root_path=C:\PhoenixXI\polplugins\DATs
debug_log=false
redirect_fopens=true
[overlays]
0=DhalmelShaft
1=XICombinedMaps-2048
2=NextHD
3=XiView-Standard
4=EraDATs
```

`DhalmelShaft` was inserted at **index 0** and the others renumbered, preserving their
relative order. Index 0 is required, not cosmetic — see the NextHD conflict below. The
`[settings]` block was copied verbatim and the file kept its original UTF-8-without-BOM
encoding and CRLF line endings.

`pivot.ini` had been backed up first to `pivot.ini.bak-20261104-143519` (166 bytes,
SHA-256 `4396254b…0c354`, verified against the original before editing). To undo the
config change, restore that file and restart:

```powershell
Copy-Item "C:\PhoenixXI\config\pivot\pivot.ini.bak-20261104-143519" `
          "C:\PhoenixXI\config\pivot\pivot.ini" -Force
```

Note that if you enable/disable overlays via the `/pivot` UI, it rewrites this file and may
reorder the list — re-check that `DhalmelShaft` is still below NextHD afterwards.

To confirm what will actually load, resolve the config the way Pivot does:

```powershell
powershell -File tools\verify-pivot.ps1
```

It reads `root_path` and the numbered overlays, reports which overlays contain
`ROM\5\15.DAT`, and fails loudly if NextHD would shadow the mod.

### Verify the copy

```powershell
Get-FileHash -Algorithm SHA256 "<overlay root>\DhalmelShaft\ROM\5\15.DAT"
# expect 86f9a5b7c83614b49c3e7a71dd93e0143e157a2fd4b53c5c12ec46d6ff561ad3
```

## Conflict: NextHD ships this same file

Pivot's rule is *the lowest-numbered overlay that has the file wins*. On this install
`NextHD\ROM\5\15.DAT` already exists (776,896 bytes — a high-res Dhalmel), and NextHD was
already loaded at index 1.

**If `DhalmelShaft` is not above NextHD, nothing changes and you will think the mod is
broken.** It is currently at index 0 with NextHD at index 2, which is correct — just don't
let the `/pivot` UI quietly reorder them later.

Trade-off, so it is a deliberate choice: the mod is built from the **retail** 481,984-byte
model, so when `DhalmelShaft` wins you get the shaft on the standard-resolution Dhalmel,
not NextHD's high-poly one. To get the shaft on the HD model, the swap has to be re-run
against NextHD's file — the writer takes any DAT, so that is just:

```powershell
cargo run --release -- "<overlay root>\NextHD\ROM\5\15.DAT" "<overlay root>\DhalmelShaft\ROM\5\15.DAT"
```

## Uninstall

Delete the `DhalmelShaft` folder from the overlay root, remove its `0=` line from
`pivot.ini` (or restore the `.bak-20261104-143519` backup shown above), then restart the
client. Nothing else to undo — the game files were never touched.

## Identifying the model

Resolved from code and data, not guessed:

| step | value | source |
|---|---|---|
| model id | **332** | LSB `data/zones/*/mobs.yaml`, all 35 `dhalmel` entries (skill list 80) |
| DAT file id | **1632** | `npc_dat_id()`: `model < 1500 -> model + 1300` |
| ROM path | **`ROM\5\15.DAT`** | this install's VTABLE/FTABLE: VTABLE byte == ROM index, then `dir = entry >> 7`, `file = entry & 0x7F` |

The ROM path is **install-specific** — it depends on your VTABLE/FTABLE. On another client
the same file id can resolve to a different folder, so re-resolve rather than reusing
`ROM\5\15.DAT` blindly.

## Provenance and reproducibility

Built by [`ffxi_modder`](https://github.com/cowrevenge/ffxi_modder), a GPL-3.0 lossless
skinned-mesh DAT writer.
What was checked before shipping:

- The original `ROM\5\15.DAT` parses and re-encodes **byte-identical** (481,984 bytes) —
  the writer is lossless, including the 4 padding bytes retail leaves dirty after the
  vertex data.
- Head = joint **36** (the skeleton's look-at reference) plus its **9** children; neck =
  joints **30–35**; shoulders = joint **29**. **273** triangles removed, and 10 neck-base
  triangles retextured in place to close the seam.
- **265** vertices / **494** triangles added in 4 draws, every vertex weighted 100% onto
  the neck/head joints so it follows the original animation exactly, mirrored on the Z
  axis the way the head was.
- Colour is a new 16×16 DXT3 solid-purple (`#9A2BD8`) texture chunk whose header is copied
  from a retail texture so unknown fields keep retail values. First texel reads back
  `[156, 40, 222, 136]`.
- The shipped file re-reads byte-identical through the writer, so it is structurally clean.

Shape is tunable via the `const`s at the top of `ffxi_modder/src/main.rs`
(`SHAFT_RADIUS_SCALE`, `TIP_PER_HEAD_LENGTH`, `GLANS`, `PURPLE`, …).

### Known caveat: rebuilds are not bit-identical

Re-running the tool on this machine reproduces the model but **not** the same bytes:
1,708 bytes differ, all inside one span (offsets 158188–186272) on a 4-byte stride —
1,337 float lanes with a maximum absolute delta of **3.97e-05** on a model about 3.7 units
tall. Compiler floating-point differences in the normalised vertex data. No visible
difference; both variants round-trip byte-identical. **The file in this repo is the
rendered and verified one — prefer it over a rebuild unless you changed a `const`.**

## Legal

`overlay/DhalmelShaft/ROM/5/15.DAT` is **derived from Square Enix retail game data**.
That is why this repository is **private**: keeping it on your own machine and using it
yourself is one thing, but the DAT is redistributable game content, so it must not be
flipped public or mirrored.

The [`ffxi_modder`](https://github.com/cowrevenge/ffxi_modder) code repo **is** public —
that is the shareable part, and it contains no game data (its `.gitignore` excludes
`*.DAT` on purpose).

If you need to share a built mod, share the command that regenerates it against files the
recipient already owns:

```powershell
cargo run --release -- "<your FFXI>\ROM\5\15.DAT" out.DAT
```

Keeping this repo private is a deliberate choice, not an oversight. To flip it:
`gh repo edit cowrevenge/ffxi_mod_files --visibility public`.

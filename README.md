# Modded Dhalmels for FFXI

Pick a mod. Take its folder. Put it in Pivot. Turn it on. Done.

The game's own files are never touched. Only you see the mod.

---

## Mod #1: Cow

![Dhalmel Cow](docs/images/dhalmel-cow-preview.png)

| you use | take this folder |
|---|---|
| no HD mods | [`retail/DhalmelCow`](retail/DhalmelCow) |
| NextHD (or any HD mod) | [`nexthd/DhalmelCow-HD`](nexthd/DhalmelCow-HD) |

## Mod #2: Neck

![Dhalmel Neck](docs/images/dhalmel-neck-ingame.png)

| you use | take this folder |
|---|---|
| no HD mods | [`retail/DhalmelShaft`](retail/DhalmelShaft) |
| NextHD (or any HD mod) | [`nexthd/DhalmelShaft-HD`](nexthd/DhalmelShaft-HD) |

---

## Install

1. Copy the folder into your Pivot `DATs` folder. It sits next to `NextHD`, `XiView` and
   the rest. You end up with, for example:

   ```
   <your DATs folder>\DhalmelCow-HD\ROM\5\15.DAT
   ```

2. In game type `/pivot`, click **+** on the mod, and **drag it to the top of the list**.

3. Restart the game.

That's it.

**Why the top?** Pivot uses the first folder in the list that has the file. If NextHD is
above your mod, you see NextHD's Dhalmel. Mod on top, you see the mod.

**Want the other mod instead?** Put both in. Whichever is higher wins. Drag to swap.

**Turn it off:** uncheck it in `/pivot`, or delete the folder. Nothing else to undo.

---

## Which file do I take?

The HD mods give you NextHD's sharper textures. The retail mods give you the plain game
textures. Same cow, same neck, same animations. Only the texture resolution differs.

Take the HD one if you run any HD DAT pack. Take the retail one if you don't.
Wrong pick costs you nothing but sharpness.

---

## Build your own

[`ffxi_modder`](https://github.com/cowrevenge/ffxi_modder) makes these from any Dhalmel DAT.
The output always goes in its own folder, never into NextHD's.

```powershell
git clone https://github.com/cowrevenge/ffxi_modder
cd ffxi_modder
cargo run --release -- "<your>\ROM\5\15.DAT" --check                          # must say byte-identical
cargo run --release -- "<your>\ROM\5\15.DAT" out.DAT                          # neck
cargo run --release --bin dhalmel_cow -- "<your>\ROM\5\15.DAT" out.DAT        # cow
```

Feed it your retail `ROM\5\15.DAT` for a retail build, or NextHD's copy for an HD build.
Run `--check` first: if the writer can't reproduce your file byte for byte, don't trust a
mod built from it.

A rebuild won't be bit-identical to the files here (compiler float noise, invisible in game).
The files in this repo are the ones that were rendered and checked. Prefer them.

`ROM\5\15.DAT` is where the Dhalmel lives on this install (model 332, DAT id 1632). Your
install can map it elsewhere: see `ffxi_modder`'s README to resolve it.

---

## Files

All six DATs and their hashes are in [`SHA256SUMS.txt`](SHA256SUMS.txt).

| | |
|---|---|
| retail mods | [`retail/`](retail) |
| HD mods | [`nexthd/`](nexthd) |
| untouched originals, both bases | [`original/`](original) |
| what's winning in your Pivot | `tools\verify-pivot.ps1 -DatPath ROM\5\15.DAT` |

```powershell
Get-FileHash -Algorithm SHA256 .\retail\DhalmelCow\ROM\5\15.DAT
```

---

## Legal

Everything here derives from Square Enix retail game data: the mods are that model with
sections swapped, the originals are unaltered. Shared in the same spirit as the HD DAT
overlays that already circulate in the FFXI community. The tooling is GPL-3.0 and lives in
[`ffxi_modder`](https://github.com/cowrevenge/ffxi_modder), which contains no game data.

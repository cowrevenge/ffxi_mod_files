# Modded Dhalmels for FFXI

Here are some modded Dhalmels for FFXI! Drop-in DAT files for
[XIPivot](https://github.com/HealsCodes/XIPivot). Nothing in your game folder gets touched,
and only people who install them see anything.

Made with [`ffxi_modder`](https://github.com/cowrevenge/ffxi_modder), which reads and writes
these DATs losslessly -- an unedited parse and write comes back byte-for-byte identical, so
whatever a mod does not touch cannot drift.

---

## How to install

1. Copy the mod's folder into your **Pivot overlay folder** -- the one that already holds
   `NextHD`, `XiView-Standard` and friends. Pivot calls it `root_path` in its config.
2. Type `/pivot` in game.
3. Click **+** next to the mod to enable it.
4. **Move it up the list.** The overlay closest to the top that has the file wins, so a mod
   has to sit above anything else shipping `ROM\5\15.DAT` -- that includes NextHD *and* the
   other Dhalmel mod here.
5. Close the window and **restart the client**. Pivot only picks files up at load, so a
   reload is not enough.

Want the cow today and the neck tomorrow? Leave both installed and just **reorder them**.
Whichever is higher wins. No reinstalling, no copying files around.

Not sure what is actually winning? This tells you, in the order Pivot would load them:

```powershell
tools\verify-pivot.ps1 -DatPath ROM\5\15.DAT
```

### Skip the ordering fight entirely with the Next HD versions

The **Next HD Dat** of each mod is built from NextHD's own Dhalmel (same mesh, skeleton and
animations as retail, double-resolution textures) and drops straight into your `NextHD`
folder, replacing its `ROM\5\15.DAT`. Each mod's HD file lives at
`nexthd/<mod>/NextHD/ROM/5/15.DAT`, so you can copy that `NextHD` folder over yours. Once you do that, NextHD
can sit anywhere in the list -- there is nothing left to outrank, because NextHD is now
serving the modded file itself.

Back up the file before you replace it. The pristine copy is in
[`original/nexthd/`](https://github.com/cowrevenge/ffxi_mod_files/tree/main/original/nexthd)
if you ever want it back.

---

## Mod #1 -- Cow

The Dhalmel, rebuilt as a cow.

![Dhalmel Cow](docs/images/dhalmel-cow-preview.png)

![Dhalmel Cow reference](docs/images/dhalmel-cow-reference.png)

**Install as a new overlay:** copy `DhalmelCow` into your Pivot folder.

| variant | | |
|---|---|---|
| **Retail Dat** | [download](https://github.com/cowrevenge/ffxi_mod_files/raw/main/retail/DhalmelCow/ROM/5/15.DAT) | 522,944 B |
| **Next HD Dat** | [download](https://github.com/cowrevenge/ffxi_mod_files/raw/main/nexthd/DhalmelCow/NextHD/ROM/5/15.DAT) | 817,856 B |

```
retail   SHA-256 5009110241d3eedb7390c645571ba80cdf4b521f7d0b9b6fbac3c72f2fc18244
nexthd   SHA-256 47b16adc0d59a724929b2607d3ab544f7a58ed5ac605e0fcdb2fb5ce4ee20164
```

The Next HD build is the same cow made from NextHD's own Dhalmel, so it keeps NextHD's
double-resolution textures (512x512 and 256x512) under the Holstein paint. Same check as
the retail one: the NextHD Dhalmel round-trips byte-identical through the writer first.

---

## Mod #2 -- Neck mod

The head and neck replaced with one procedural purple shaft, weighted onto the neck and head
bones so it bends with the neck and nods with the head.

![Dhalmel Neck in game](docs/images/dhalmel-neck-ingame.png)

![Dhalmel Neck geometry, unlit](docs/images/dhalmel-neck-mesh-preview.png)

The second image is an offline render with no lighting -- the one to judge shape and the raw
`#9A2BD8` colour from.

**Install as a new overlay:** copy `DhalmelShaft` into your Pivot folder.

| variant | | |
|---|---|---|
| **Retail Dat** | [download](https://github.com/cowrevenge/ffxi_mod_files/raw/main/retail/DhalmelShaft/ROM/5/15.DAT) | 501,024 B |
| **Next HD Dat** | [download](https://github.com/cowrevenge/ffxi_mod_files/raw/main/nexthd/DhalmelShaft/NextHD/ROM/5/15.DAT) | 795,936 B |

```
retail   SHA-256 86f9a5b7c83614b49c3e7a71dd93e0143e157a2fd4b53c5c12ec46d6ff561ad3
nexthd   SHA-256 224b70d410b6cd8288757f6a71f015f84f7eeb8eb032eedf15b5c41bdf639bff
```

The Next HD build was checked the same way as the retail one: the NextHD Dhalmel round-trips
byte-identical through the writer before and after the swap.

---

## Download everything

| | |
|---|---|
| **All retail versions** | [`retail/`](https://github.com/cowrevenge/ffxi_mod_files/tree/main/retail) |
| **All Next HD versions** | [`nexthd/`](https://github.com/cowrevenge/ffxi_mod_files/tree/main/nexthd) |
| Originals, both bases | [`original/`](https://github.com/cowrevenge/ffxi_mod_files/tree/main/original) |

Every file and its hash is listed in [`SHA256SUMS.txt`](SHA256SUMS.txt). Check one before
trusting it:

```powershell
Get-FileHash -Algorithm SHA256 .\retail\DhalmelCow\ROM\5\15.DAT
```

---

## Next project

TBD.

---

## How to mod your own file

You do not need anything from this repo. Build a mod from a DAT you already own:

```powershell
git clone https://github.com/cowrevenge/ffxi_modder
cd ffxi_modder
cargo run --release -- "C:\path\to\15.DAT" out.DAT                    # neck mod
cargo run --release --bin dhalmel_cow -- "C:\path\to\15.DAT" out.DAT  # cow mod
```

**Always check the writer against your file first.** If it cannot reproduce your input
byte-for-byte, do not trust any mod it produces:

```powershell
cargo run --release -- "C:\path\to\15.DAT" --check
# round trip: byte-identical (776896 bytes)
```

This is the step that matters, because it is the only proof nothing outside the bits you
changed has drifted.

### Which file is your model?

Three steps, all from data:

1. **Model id** -- LandSandBoat `data/zones/*/mobs.yaml`, from entries sharing a species and
   skill list. The Dhalmel is **332**.
2. **DAT file id** -- `npc_dat_id()`: `model < 1500` gives `model + 1300`; `< 3000` gives
   `+ 50295`; `< 3500` gives `+ 96907`; otherwise `+ 98239`. So 332 -> **1632**.
3. **ROM path** -- the highest ROM whose VTABLE byte equals its own index owns the file, then
   `dir = entry >> 7` and `file = entry & 0x7F`. That gives `ROM\5\15.DAT` on this install.

Step 3 is **install-specific**. Same model id, different client, possibly a different folder,
so resolve it against your own DATs instead of copying `ROM\5\15.DAT` from here.

### Point the mod at the bones you want

The neck mod finds its target from the skeleton rather than guessing which mesh section is the
head: head = joint 36 (the look-at reference, the bone retail bends to aim the face) plus its
9 descendants; neck = the parent chain down to the first branching joint; shoulders = joint
29, that branch. It removes their triangles and adds procedural geometry weighted 100% onto
those same bones, which is why it animates correctly for free.

Shape lives in the `const`s at the top of `src/main.rs` -- `PURPLE`, `SHAFT_RADIUS_SCALE`,
`TIP_PER_HEAD_LENGTH`, `SEAM_OVERLAP`, `GLANS`, and the rest.

### Two things to expect

- **A rebuild will not be bit-identical to a file in this repo.** Same model, a few thousand
  bytes different from floating-point noise in the compiler. Invisible in game. Want the
  exact file that was checked in, download it; changed a `const`, rebuild.
- **Colour via texture, not tint.** The purple is a small solid DXT3 chunk appended to the
  DAT, not a `t_factor` value.

---

## Legal

Everything here derives from Square Enix retail game data. Modded files are the retail model
with mesh sections swapped; the originals are those files unaltered, kept so you can diff what
changed and rebuild from a known-good base. Shared in the same spirit as the HD DAT overlays
that already circulate freely in the FFXI community.

Tooling only? Use [`ffxi_modder`](https://github.com/cowrevenge/ffxi_modder) -- separate repo,
GPL-3.0, contains no game data.

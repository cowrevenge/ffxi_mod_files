# Modded Dhalmels for FFXI

Here are some modded Dhalmels for FFXI! Drop-in DAT files for
[XIPivot](https://github.com/HealsCodes/XIPivot). Nothing in your game folder gets touched,
and only people who install them see anything.

Made with [`ffxi_modder`](https://github.com/cowrevenge/ffxi_modder), which reads and writes
these DATs losslessly -- an unedited parse and write comes back byte-for-byte identical, so
whatever a mod does not touch cannot drift.

---

## Which version do I download?

| Your setup | Use | Put it here |
|---|---|---|
| You run **NextHD** or another HD pack | **Next HD Dat** | inside that pack's own folder |
| You run **no** HD packs | **Retail Dat** | its own folder, at the top of the list |

Every mod here ships both. They are the same mod, just built on a different base file -- the
HD one keeps the doubled-resolution textures, the retail one does not.

## The one rule that matters, explained simply

Pivot reads your overlay list **top to bottom and stops at the first copy of a file it
finds**. Only one copy of `ROM\5\15.DAT` is ever used: the highest one in the list.

So if something else already has a `ROM\5\15.DAT` -- like NextHD does -- and that thing is
above your mod, you will see NextHD's Dhalmel and think your mod is broken. It is not broken,
it is just sitting below somebody else's copy.

There are two ways to make sure yours is the copy that gets used:

1. **Put your file where the other file already is.** Drop the modded DAT into NextHD's own
   folder, replacing its `ROM\5\15.DAT`. Now there is only one copy and nothing to argue
   about. **If you use HD packs, this is the proper install -- do this one.**
2. **Give it its own folder and drag that folder to the very top.** Use this when you have no
   HD pack carrying the same file, or when you want the mod kept separate from your packs.

Either way works. Option 1 is the right answer for HD users, not a shortcut.

---

## Install

### If you use NextHD or another HD pack -- the proper way

1. **Back up the file you are about to replace.** Do this first.
2. Take the mod's HD file from `nexthd/<Mod>/NextHD/ROM/5/15.DAT` and copy it over
   `<your DATs folder>\NextHD\ROM\5\15.DAT`.
3. Restart the client.

That is all it takes -- no reordering, and NextHD can sit anywhere in the list.

The pristine, unmodded version of that file is in
[`original/nexthd/`](https://github.com/cowrevenge/ffxi_mod_files/tree/main/original/nexthd),
so you can always put things back exactly as they were.

To swap to the other mod later, copy that mod's HD file into the same spot. Only one mod can
live in that folder at a time -- it is the same file being replaced.

### If you use no HD packs

1. Copy the mod's folder -- `retail/DhalmelCow` or `retail/DhalmelShaft` -- into your
   **Pivot overlay folder**, the one holding `NextHD`, `XiView-Standard` and friends. Pivot
   calls it `root_path` in its config.
2. Type `/pivot` in game.
3. Click **+** next to the mod to enable it.
4. **Drag it to the top of the list.**
5. Close the window and **restart the client**. Pivot only picks files up at load, so a
   reload is not enough.

### Switching between the two mods

Leave both installed and just **move the one you want higher**. Whichever is on top wins. No
reinstalling and no copying files around -- unless both are installed into an HD pack folder,
where only one file can occupy that slot at a time.

### Not sure what is actually loading?

This prints every overlay that carries the file, in the order Pivot reads them, and names the
one that wins:

```powershell
tools\verify-pivot.ps1 -DatPath ROM\5\15.DAT
```

---

## Mod #1 -- Cow

The Dhalmel, rebuilt as a cow -- Holstein markings and all.

![Dhalmel Cow](docs/images/dhalmel-cow-preview.png)

![Dhalmel Cow reference](docs/images/dhalmel-cow-reference.png)

| variant | for | download | size |
|---|---|---|---|
| **Retail Dat** | no HD packs | [get it](https://github.com/cowrevenge/ffxi_mod_files/raw/main/retail/DhalmelCow/ROM/5/15.DAT) | 522,944 B |
| **Next HD Dat** | NextHD users | [get it](https://github.com/cowrevenge/ffxi_mod_files/raw/main/nexthd/DhalmelCow/NextHD/ROM/5/15.DAT) | 817,856 B |

```
retail   SHA-256 5009110241d3eedb7390c645571ba80cdf4b521f7d0b9b6fbac3c72f2fc18244
nexthd   SHA-256 47b16adc0d59a724929b2607d3ab544f7a58ed5ac605e0fcdb2fb5ce4ee20164
```

The HD build is the same cow made on NextHD's own Dhalmel, so it keeps NextHD's
double-resolution textures (512x512 and 256x512) under the paint.

---

## Mod #2 -- Neck mod

Head and neck replaced with one procedural purple shaft, weighted onto the neck and head bones
so it bends with the neck and nods with the head.

![Dhalmel Neck in game](docs/images/dhalmel-neck-ingame.png)

![Dhalmel Neck geometry, unlit](docs/images/dhalmel-neck-mesh-preview.png)

The second image is an offline render with no lighting -- the one to judge shape and the raw
`#9A2BD8` colour from.

| variant | for | download | size |
|---|---|---|---|
| **Retail Dat** | no HD packs | [get it](https://github.com/cowrevenge/ffxi_mod_files/raw/main/retail/DhalmelShaft/ROM/5/15.DAT) | 501,024 B |
| **Next HD Dat** | NextHD users | [get it](https://github.com/cowrevenge/ffxi_mod_files/raw/main/nexthd/DhalmelShaft/NextHD/ROM/5/15.DAT) | 795,936 B |

```
retail   SHA-256 86f9a5b7c83614b49c3e7a71dd93e0143e157a2fd4b53c5c12ec46d6ff561ad3
nexthd   SHA-256 224b70d410b6cd8288757f6a71f015f84f7eeb8eb032eedf15b5c41bdf639bff
```

---

## Both builds, both bases, checked the same way

NextHD's Dhalmel has the **same mesh, skeleton and animations as retail** -- only the textures
are double resolution. That is why the HD variants need their own builds: the writer has to be
lossless on a different file, and it is. Every mod here was preceded by a byte-identical round
trip of its own base file, and every one of these DATs is listed with its hash in
[`SHA256SUMS.txt`](SHA256SUMS.txt).

Check anything before trusting it:

```powershell
Get-FileHash -Algorithm SHA256 .\retail\DhalmelCow\ROM\5\15.DAT
```

## Download everything

| | |
|---|---|
| **All retail versions** | [`retail/`](https://github.com/cowrevenge/ffxi_mod_files/tree/main/retail) |
| **All Next HD versions** | [`nexthd/`](https://github.com/cowrevenge/ffxi_mod_files/tree/main/nexthd) |
| **Originals, both bases** | [`original/`](https://github.com/cowrevenge/ffxi_mod_files/tree/main/original) |

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

That step is the whole point of the tool. It is the only proof that nothing outside the bits
you changed has drifted -- including the 4 padding bytes retail leaves dirty after the vertex
data, which a naive writer would quietly zero.

Use the file that matches how you play: your retail `ROM\5\15.DAT` for the retail build, or
NextHD's copy for the HD build.

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
- **Colour comes from a texture, not a tint.** The purple is a small solid DXT3 chunk appended
  to the DAT, not a `t_factor` value.

---

## Legal

Everything here derives from Square Enix retail game data. Modded files are the retail model
with mesh sections swapped; the originals are those files unaltered, kept so you can diff what
changed and rebuild from a known-good base. Shared in the same spirit as the HD DAT overlays
that already circulate freely in the FFXI community.

Tooling only? Use [`ffxi_modder`](https://github.com/cowrevenge/ffxi_modder) -- separate repo,
GPL-3.0, contains no game data.

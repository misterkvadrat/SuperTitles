# SuperTitles

Small Crusader Kings III 1.19 mod for dynamic high kingdoms and AGOT-specific
realm restoration.

## Requirements

- CK3 1.19.x

With CK3AGOT, the mod also:

- Unites the Iron Islands and Riverlands as the Kingdom of the Isles and Rivers.
- Unites the Narrow Sea and Daoryrdembos as Western Essos.
- Styles the ruler of Western Essos as High Prince or High Princess.
- Gives every new ruler of Western Essos an accession event and the Prince of
  Princes trait.
- Adds inheritable pressed regional claims to the heads of the restored Reyne,
  Gardener, Durrandon, and Hoare houses on the next quarterly pulse.
- Repairs missing Hoare claims and the old Augustus trait in existing saves on
  the next quarterly pulse.
- Restores the lordships of Gulltown, Flint's Finger, Bear Island, Runestone,
  the Sisters, and Fair Isle with custom gold, prestige, and dynasty renown
  rewards.
- Adds the Empire of the Bite decision for rulers who unite the White Knife,
  the Neck, and the Bite, with the Sisters joining when created.
- Adds a two-step Dornish path: bring the Stepstones into Dorne's de jure realm,
  then unite Dorne and the Narrow Sea as the Kingdom of the Hand.

## Installation

1. Copy this folder to:
   `Documents/Paradox Interactive/Crusader Kings III/mod/SuperTitles`
2. Copy `descriptor.mod` beside the folder as `SuperTitles.mod`.
3. Add this line only to the copied `SuperTitles.mod`:
   `path="mod/SuperTitles"`
4. Enable **SuperTitles** in the launcher.

Load after AGOT. With CK3AGOT, load after **A Game of Thrones** and its
submods. No AGOT compatch is required because this mod adds one namespaced
decision and does not use `replace_path`.

## Validation

Run from PowerShell:

```powershell
.\tools\validate.ps1
```

## License

MIT. See `LICENSE`.

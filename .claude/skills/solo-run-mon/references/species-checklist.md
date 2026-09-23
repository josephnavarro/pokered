# Species replacement checklist

## Which species to replace

**Mew is the recommended target** (used for both Shedinja and Regigigas). Its pic and base stats live in their own bank-1 file (`data/pokemon/mew.asm`) with ~10 references, and bank 1 has proven room for a 7x7 front pic plus a 6x6 back pic (~960 bytes). Anything else is a normal indexed species and additionally touches the dex-ordered tables and a shared Pics bank.

Adding a *new* index (#191) instead also requires `NUM_POKEMON`, `dex_order.asm`, the dex-ordered include list, the evos/moves pointer table, `gfx/pics.asm`, and the pic-bank rule in `home/pics.asm:12-46`.

## Files to touch (replacing Mew)

```
git mv data/pokemon/mew.asm             data/pokemon/<mon>.asm
git mv data/pokemon/base_stats/mew.asm  data/pokemon/base_stats/<mon>.asm
git rm gfx/pokemon/front/mew.png gfx/pokemon/back/mewb.png
```

| File | Change |
|---|---|
| `data/pokemon/<mon>.asm` | `<Mon>PicFront`, `<Mon>PicBack`, `<Mon>BaseStats` labels + INCBINs |
| `data/pokemon/base_stats/<mon>.asm` | the stat block (format below) |
| `main.asm` | the `INCLUDE` line |
| `constants/pokemon_constants.asm` | `const MEW ; $15` -> `const <MON>` |
| `constants/pokedex_constants.asm` | `const DEX_MEW ; 151` -> `const DEX_<MON>` |
| `data/pokemon/dex_order.asm` | `db DEX_<MON>` |
| `home/pokemon.asm` | `cp MEW`, `ld hl, MewBaseStats`, `ld a, BANK(MewBaseStats)` |
| `home/pics.asm` | `cp MEW`, `ld a, BANK(MewPicFront)`, and the bank-mapping comment |
| `data/pokemon/evos_moves.asm` | the `dw MewEvosMoves` pointer **and** the block |
| `data/pokemon/names.asm` | exactly 10 chars, `@`-padded: `db "REGIGIGAS@"` |
| `data/pokemon/palettes.asm` | a `PAL_*MON` value |
| `data/pokemon/cries.asm` | `mon_cry SFX_CRY_xx, <pitch>, <tempo>` |
| `data/pokemon/menu_icons.asm` | `ICON_MON` is what every large mon uses |
| `data/pokemon/dex_entries.asm` | the `dw` pointer **and** the entry |
| `data/pokemon/dex_text.asm` | the flavour text |
| `engine/debug/debug_party.asm` | two `db MEW, <lvl>` lines |
| `gfx/pokemon/front/<mon>.png`, `gfx/pokemon/back/<mon>b.png` | 4-shade greyscale, 40/48/56 px square |

Leave the Pokemon Mansion diary text (`text/PokemonMansion2F.asm`, `3F.asm`) alone — it is flavour, not data.

Afterwards: `grep -rn "\bMEW\b\|Mew[A-Z]" --include='*.asm' . | grep -v MEWTWO`

## Base stats format

```asm
	db DEX_<MON> ; pokedex id

	db 110, 160, 110, 100, 110
	;   hp  atk  def  spd  spc      <-- SPD BEFORE SPC, not the modern order

	db NORMAL, NORMAL ; type        <-- single-type mons repeat the type
	db 3 ; catch rate
	db 220 ; base exp

	INCBIN "gfx/pokemon/front/<mon>.pic", 0, 1 ; sprite dimensions
	dw <Mon>PicFront, <Mon>PicBack

	db MOVE1, MOVE2, NO_MOVE, NO_MOVE ; level 1 learnset (always 4 slots)
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH, BODY_SLAM, ...
	; end

	db 0 ; padding
```

Catch rate and base exp are never shown in the videos — use the real values (e.g. Regigigas 3 / 220, Shedinja 45 / 83) and say so in the notes.

Dex entry: species name max 10 chars, then `db feet,inches`, then `dw <weight in tenths of a pound>`.

## Adding a move

1. `constants/move_constants.asm` — insert **before `STRUGGLE`**
2. `data/moves/names.asm` — up to 12 chars displays fine (`THUNDERPUNCH`)
3. `data/moves/moves.asm` — `move NAME, EFFECT, power, TYPE, accuracy, pp`
4. `data/moves/animations.asm` — reuse an existing `*Anim` label
5. `data/moves/sfx.asm` — copy a similar move's row
6. `data/battle/critical_hit_moves.asm` — only if it is a high-crit move
7. Priority moves are **hardcoded**, not an effect: see `IsPriorityMove` in `engine/battle/core.asm`

Effects that do **not** exist in gen 1, with the usual fallback:

| Modern effect | Fallback |
|---|---|
| power scales with target HP (Crush Grip) | flat power |
| 2x when user is statused (Facade) | `NO_ADDITIONAL_EFFECT` |
| lowers user's Speed (Hammer Arm) | `NO_ADDITIONAL_EFFECT` |
| raise own stat as a *side* effect (Metal Claw) | new effect modelled on the `*_DOWN_SIDE_EFFECT` branch, or drop it |
| 20% flinch | gen 1 has only 10% (`FLINCH_SIDE_EFFECT1`) and 30% (`FLINCH_SIDE_EFFECT2`) |
| attacks off Defense (Body Press) | not expressible — drop |
| Protect / Wide Guard | not expressible — drop |

## Flavour extras (ask before doing these)

**All three Poke Balls give the mon** — `scripts/OaksLab.asm`: set `ld a, <MON>` in each of the three `*PokeBallText` blocks; collapse the three "You want X?" prompts into one; and re-key `OaksLabChoseStarterScript` off `wRivalStarterTemp` (the rival's pick) instead of `wPlayerStarter`, or he walks to the wrong ball. Then `text/OaksLab.asm` and `engine/events/starter_dex.asm`. Leave `STARTER1..3` vanilla so the rival's teams still work.

**Title screen** — `data/pokemon/title_mons.asm` (all 16 slots) and `engine/movie/title.asm`. **Remove the "must differ from the current mon" retry loop** or it spins forever on a single-species list.

**Oak's intro** — `engine/movie/oak_speech/oak_speech.asm` for the sprite. The cry is a *text command*: rename `sound_cry_nidorina` in `macros/scripts/text.asm`, its `TextCommandSounds` row in `home/text.asm`, and the call site. Nothing else uses it. (Vanilla plays Nidorina's cry under a Nidorino sprite.)

**ROM title** — `gfx/title/red_version.png` is a 1bpp strip that secretly reads "RedGreenVersion"; only some tiles are displayed. Keep its tile count even (the VRAM offset is `(10 tiles - size)/2`), update the tile-id string and `hlcoord` in `engine/movie/title.asm`, and the `-t "POKEMON X"` in the `Makefile` for the cartridge header.

The intro *movie* (Gengar vs Nidorino) uses dedicated graphics, not species sprites — changing it is a separate, much larger job.

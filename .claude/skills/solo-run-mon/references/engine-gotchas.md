# pokered engine gotchas

Everything here cost real debugging time. Line numbers drift; grep for the symbol.

## Sprites

**Back sprites are 2x-scaled in vanilla.** The stored pic is 4x4 tiles; `LoadMonBackPic` calls `ScaleSpriteByTwo`, which doubles each pixel and discards the last 4 rows/columns, producing the 56x56 you see. That is an art/storage decision, not a limit — the destination (`vBackPic`) is the same 7x7 box a front pic uses, and the decompressor accepts 4x4 through 7x7.

Both reference videos draw the back pic at **native 6x6**. To match, branch in `LoadMonBackPic`: skip `ScaleSpriteByTwo` and call `LoadUncompressedSpriteData` instead.

**`LoadUncompressedSpriteData` wants the packed dimension byte**, not plain numbers: width in `a`'s low nybble, height in `c`'s **high** nybble. From the decompressor's pixel counts:

```asm
	ld a, [wSpriteHeight] ; pixels
	add a                 ; pixels * 2 == tiles << 4
	ld c, a
	ld a, [wSpriteWidth]
	srl a
	srl a
	srl a                 ; pixels / 8 == tiles
	ld de, vBackPic
	call LoadUncompressedSpriteData
```

Passing an unpacked height renders garbage.

**Centering** (`home/pics.asm`): horizontal offset `(8-w)/2` tiles, vertical `7-h` tiles — so a 6x6 pic sits at GB x16..63, y48..95 inside the player's box, and a front pic sits bottom-centred. Useful for locating a sprite in captured frames.

**Sizes**: 40/48/56 px square (5x5, 6x6, 7x7 tiles). 56 is common — 56 of the 151 originals use it. PNGs must be 4-shade (255/170/85/0); greyscale and paletted both give byte-identical `rgbgfx` output.

## Moves

- New moves go **before `STRUGGLE`** — `engine/battle/core.asm` asserts `NUM_ATTACKS == STRUGGLE` (random numbers above STRUGGLE are not moves).
- `data/moves/{moves,animations,sfx}.asm` and `names.asm` are all length-asserted against `NUM_ATTACKS`. Update all four.
- **Priority is hardcoded**, not an effect. Vanilla special-cases `QUICK_ATTACK` and `COUNTER` in `MainInBattleLoop`. Add new priority moves via a helper (`IsPriorityMove`) at each `cp QUICK_ATTACK`.
- **High crit ratio** is a table: `data/battle/critical_hit_moves.asm`.
- **Crit rate comes from base Speed**, not current Speed — halving Speed in battle does not change crit chance.
- Gen 1 stat-down *side* effects fire at **33%**, not the modern 20%.

## Types

- **Physical vs special is decided by TYPE**: `cp SPECIAL` where `SPECIAL EQU $14`. Types below are physical, at/above are special. So Ice Punch, Thunder Punch and Zen Headbutt are **special** moves in gen 1 and run off Special.
- New types must go in the **`UNUSED_TYPES` gap ($09-$13)**, below `SPECIAL`, or their moves silently become special. There are 11 free slots.
- `data/types/names.asm` has a `REPT UNUSED_TYPES_END - UNUSED_TYPES` filler that shrinks automatically as you add types.
- **Type chart row order matters.** `AdjustDamageForMoveType` multiplies damage by *every* matching row but only remembers the **last** row's multiplier for the on-screen message. With `POISON->GUARD x2` listed after `POISON->WONDER x0`, Poison Sting printed "attack missed" instead of "doesn't affect". Put immunity rows last.
- **STAB compares the move type against the attacker's two types for equality.** A custom type that is meant to behave like a vanilla one needs canonicalizing in `AdjustDamageForMoveType`, or vanilla moves of the "real" type lose STAB.
- Gen 1's `GHOST -> PSYCHIC = no effect` bug is a real chart row. If you retype custom Ghost moves to real `GHOST`, they inherit it — which can silently make a signature move useless against a whole gym.

## Stats and battle state

- `CalcStat` in `home/move_mon.asm` is the single choke point for every stat on every path (creation, level-up, Rare Candy, Day-Care, box, enemy load). The HP branch is identified by `cp $1`. Patch here for things like a fixed 1 HP.
- In WRAM the first byte of `wMonHeader` is the **internal index** (`wMonHIndex`), not the dex number — the comment in `ram/wram.asm` says so explicitly.
- **Critical hits bypass the in-battle stat** and read the unmodified value straight out of party data (`wPartyMon1Attack`). Any "halve the attacker's stat" effect must be applied at `GetDamageVarsForPlayerAttack.scaleStats`, after both branches converge, or crits ignore it.
- `ApplyBadgeStatBoosts` re-runs whenever a stat-up/down move is used, so anything that mutates `wBattleMonAttack` in place can be recomputed out from under you. Prefer applying at the point of use.
- **Free WRAM**: there are unnamed `ds` padding bytes in the battle region (`$D06E` between `wPlayerDisabledMove` and `wEnemyNumAttacksLeft`, `$D073`, `$D076-77`). Naming one shifts no other address. Do **not** reuse the `wUnused*` labels — most are still written to by real code. Verify with `grep` and by diffing `.sym` addresses before/after.
- `wPlayerStatsToDouble` / `wPlayerStatsToHalve` are documented "always 0" and only read by `engine/battle/unused_stats_functions.asm`, but they are cleared in several places — usable, but confusing.

## Text

- `<USER>` (charmap `$5A`) resolves through `hWhoseTurn`: 0 prints the player's `wBattleMonNick`, nonzero prints "Enemy " + the enemy's. Zero it before printing a player-side message.
- Battle messages are a label in `engine/battle/core.asm` (`text_far _XText` / `text_end`) plus the string in `data/text/text_2.asm`.
- Text box is **18 characters per line**, two lines visible. `#` expands to "POKé" (4 chars).
- `SendOutMon` ends with `PrintEmptyString` then `SaveScreenTilesToBuffer1` — print send-out messages *before* the `PrintEmptyString` so the box is cleared before the screen is snapshotted.

## Build

- The tree targets RGBDS 0.7.0 but builds clean on 1.0.3 with only `STRIN`/`CHARVAL` deprecation warnings.
- `make` alone may report "nothing to be done" against a stale ROM — `make clean` first when you need a real check.
- `roms.sha1` holds the vanilla checksums; useful to confirm an unmodified tree.

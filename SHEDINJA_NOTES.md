# Shedinja in Pokémon Red — Implementation Notes

Source: GymLeaderMatt, *"1 HP and a Dream | Shedinja Pokemon Red Solo Challenge"* (YouTube `xHp1BBs4njY`), first ~10:30.
Derived from the narration (YouTube auto-captions) plus the on-screen overlays and in-game screens. Timestamps are video time.

Part A records what the video actually says/shows. Part B maps each of those decisions onto this pokered tree (my analysis, not from the video).

---

## Part A — What the video establishes

### A1. Species spec as implemented (overlay, 0:40 / 2:30)

| Field | Value | Evidence |
|---|---|---|
| Base HP | **1** (displayed; see A4 — not really 1 in the ROM) | STATS panel, 0:40 |
| Base Attack | 90 | STATS panel |
| Base Defense | 45 | STATS panel |
| Base Special | 30 | STATS panel |
| Base Speed | 40 | STATS panel; crit rate 7.81 % = 40/512 and Shadow Claw 62.5 % = 40×4/256 independently confirm Spd = 40 |
| BST | 206 | STATS panel |
| Types | **GHOSTT** (custom variant) / **BUG** | Overlay badges "GHT / BUG"; in-game move screen shows `TYPE/ GHOSTT` for Shadow Claw (2:34) |
| Exp group | **Medium Fast** (deliberate deviation; real Shedinja is Erratic) | Overlay `EXP-GRP: MED FAST`, narration 6:22–7:00 |
| Level-5 stats seen | Atk 15 / Def 11 / Spc 9 / Spd 10 | Consistent with the base stats above under the Gen 1 formula with high DVs |

The run starts with Shedinja (nickname "SHELLZ") at L5 as the starter; the rival's first mon is Charmander (0:20), which in R/B means Shedinja occupies the **Bulbasaur** starter slot. (Inferred from footage, not stated.)

### A2. Wonder Guard (1:17–1:57, 4:51–5:32)

Narration, paraphrased:

- "Normally we don't use abilities in Gen 1, but Shedinja without Wonder Guard is a chicken sandwich without the chicken."
- Only super-effective damage can hurt it. For Bug/Ghost that is **Flying, Rock, Ghost, Fire** (and Dark, which doesn't exist in Gen 1, so drop it).
- Practical Gen 1 reality: Ghost's only damaging move is Lick; Rock damage is "extremely rare"; so the real threats are Flying and Fire.
- **Implementation:** "It wasn't too hard. You simply make two variations of, like, Bug and Ghost, keep Wonder Guard in mind, and make the type chart according to that. For instance I'd make something like Ghost type with two T's and make that immune to most of the types, and then simulate Wonder Guard — things like Rock, Flying, or super-effective."
- Described as "fairly simple, straightforward and effective."
- Seen working at 6:08: an enemy Rattata's move → `It doesn't affect SHELLZ!`

Damage sources the type chart cannot stop (all surfaced in the first 10 minutes and explicitly called out as the real risks):

| Source | Where | Note |
|---|---|---|
| **Bide** (typeless) | Brock's Onix, 3:49–4:27 | Onix outspeeds; if you can't KO it in the 2–3 Bide turns it's a reset. Author suggests using Dig's semi-invulnerable turn to dodge the release. |
| **Confusion self-hit** (typeless) | Supersonic from Jr. Trainer♀'s Goldeen, 7:39–8:12 | Took 5 attempts. |
| **Super-effective moves** | Ember from a Gentleman's Ponyta on the S.S. Anne, 10:05–10:25 | Ponyta outspeeds → reset. |
| Poison/burn chip, Leech Seed, etc. | not shown in first 10 min but implied by "other ways we can be damaged" | (A 1 HP mon is KO'd by any residual damage.) |

Coverage gap flagged at 8:52–9:18: **Normal/Flying** targets (Pidgey line etc.). Shadow Claw (Ghost) does nothing to Normal, Dig does nothing to Flying, leaving only Metal Claw. Gust is Normal-type in Gen 1, so it isn't itself a threat.

### A3. Moves (1:57–2:44; tables at 2:01–2:22; in-game screens 2:33–2:36)

Base: the **Gen VIII learnset**, trimmed to what fits Gen 1. Reference table shown at 2:01:

| Lv | Move | Type | Pwr | Acc | PP |
|---|---|---|---|---|---|
| 1 | Shadow Claw | Ghost | 70 | 100 | 15 |
| 1 | Grudge | Ghost | — | — | 5 |
| 1 | Mud-Slap | Ground | 20 | 100 | 10 |
| 1 | Metal Claw | Steel | 50 | 95 | 35 |
| 1 | Dig | Ground | 80 | 100 | 10 |
| 1 | Scratch | Normal | 40 | 100 | 35 |
| 1 | Sand Attack | Ground | — | 100 | 15 |
| 1 | Harden | Normal | — | — | 30 |
| 1 | False Swipe | Normal | 40 | 100 | 40 |
| 15 | Confuse Ray | Ghost | — | 100 | 10 |
| 23 | Absorb | Grass | 20 | 100 | 25 |
| 29 | Shadow Sneak | Ghost | 40 | 100 | 30 |
| 36 | Fury Swipes | Normal | 18 | 80 | 15 |
| 43 | Mind Reader | Normal | — | — | 5 |
| 50 | Shadow Ball | Ghost | 80 | 100 | 15 |
| 57 | Spite | Ghost | — | 100 | 10 |
| 64 | Phantom Force | Ghost | 90 | 100 | 10 |

**Implemented learnset** (overlay table at 2:10; `*` = move added to the ROM):

| How | Move | Pwr | Acc | PP (table) | Notes |
|---|---|---|---|---|---|
| Lv 1 | Shadow Claw* | 70 | 100 | 35 (**in-game shows 15**) | Type GHOSTT in-game. High crit ratio "like Slash". |
| Lv 1 | Metal Claw* | 50 | 95 | 35 | Type **STEEL** in-game (new type). "10 % attack boost chance, but just not a great move." |
| Lv 1 | Dig | 100 | 100 | 10 | Gen 1 Dig (100 pwr) kept, not Gen VIII's 80. Type GROUND. |
| Lv 1 | Harden | — | — | 30 | "Harden's a little bit funny, we'll talk about that later" (after 10:00). |
| Lv 15 | Confuse Ray | — | 100 | 10 | |
| Lv 23 | Absorb | 20 | 100 | 20 | |
| Lv 29 | Shadow Sneak* | 40 | 100 | 30 | "High priority like Quick Attack." |
| Lv 36 | Fury Swipes | 18 | 80 | 15 | |
| Lv 50 | Shadow Ball* | 80 | 100 | 15 | "Does have a defense-lowering chance." |
| TM15 | Hyper Beam | 150 | 90 | 5 | |
| TM19 | Seismic Toss | — | 100 | 20 | |
| TM21 | Mega Drain | 40 | 100 | 10 | |
| TM28 | Dig | 100 | 100 | 10 | |
| TM31 | Mimic | — | 100 | 10 | |
| TM50 | Substitute | — | — | 10 | |

Dropped from Gen VIII: Grudge, Mud-Slap, Scratch, Sand Attack, False Swipe, Mind Reader, Spite, Phantom Force. (Scratch, Sand Attack exist in Gen 1 but were cut anyway so the L1 set is exactly four moves.)

Explicit rulings:
- **Swords Dance excluded.** Shedinja can only get it via transfer; in Gen VIII it's a TR and Shedinja doesn't learn it, so it was left off "to be more true to my interpretation."
- TM list is "really shallow / pretty weak" — by design, faithful to the real compat list.
- Starting moveset = Shadow Claw, Metal Claw, Dig, Harden (2:33 battle menu).

### A4. The 1 HP problem (0:53–1:17, 5:32–6:22)

- Real Shedinja ignores the HP formula: it has exactly **1 HP at every level**.
- **Not implemented in the ROM.** "Digging into the code and modifying it to make only Shedinja maintain a constant 1 HP while the rest of the game functions normally was honestly a little over my head."
- Instead: **GameHook** (the third-party memory-hook tool he already uses to drive the stats overlay) running a custom Shedinja profile/script that **writes 1 to HP and Max HP every time it levels up**, overriding what the game computed.
- Consequences he states:
  - The patch file distributed to channel members / Patreon **does not have 1 HP**.
  - The hook is "not a perfect solution … a little bit janky and messes up from time to time."
  - House rule: if the hook lagged and he survived a hit with, say, 60 HP, he **still resets** — "1 HP rules."
- The in-game HP box does read `1/ 1` in battle, so the hook is writing the actual party/battle RAM, not just the overlay.

### A5. Experience group (6:22–7:00)

- Real Shedinja is **Erratic**. Gen 1 doesn't have it, and "modifying and adding new experience groups just wasn't worth the hassle."
- Erratic is the *lowest total* to L100 but the *slowest* group from L1–10 (the chart at 6:40 shows it as the black line, above Slow at low levels).
- He didn't want to over-punish it with Slow, so **Medium Fast** was chosen.

### A6. Distribution / provenance (4:51–5:06)

- "This is a custom ROM that I made." Disassembly repositories are on GitHub, linked in the video description.
- Patch files released to channel members and Patreon supporters only.

---

## Part B — Mapping onto this pokered tree

Everything below is my translation of Part A into concrete edits. File paths are verified against the current checkout. *Parts A–C use the video's type name `GHOSTT`; the final implementation calls that type `WONDER` and pairs it with a Bug clone named `GUARD` — see Part D for what was actually built.*

### B1. New types: GHOSTT and STEEL

**Where:** `constants/type_constants.asm`, `data/types/names.asm`, `data/types/type_matchups.asm`.

1. **Type IDs must be < `SPECIAL` ($14).** `engine/battle/core.asm:4167` and `:4280` decide physical vs special by `cp SPECIAL`. Shadow Claw / Shadow Sneak / Metal Claw must use Attack/Defense, so put the new types in the `UNUSED_TYPES` gap ($09–$13) — there are 11 free slots:
   ```asm
   	const GHOST        ; $08
   	const GHOSTT       ; $09  (Wonder Guard ghost)
   	const STEEL        ; $0A
   DEF UNUSED_TYPES EQU const_value
   	const_next 20
   ```
2. `data/types/names.asm`: add `dw .Ghostt` / `dw .Steel` in the same positions and the strings `.Ghostt: db "GHOSTT@"`, `.Steel: db "STEEL@"`. The `REPT UNUSED_TYPES_END - UNUSED_TYPES` filler shrinks automatically. Type names print in the move-info box (`TYPE/ GHOSTT` is exactly what the video shows), so the 8-char limit isn't an issue here.
3. `data/types/type_matchups.asm` — the table lists only non-neutral pairs, so Wonder Guard is a block of `NO_EFFECT` rows with GHOSTT as **defender**:
   ```asm
   	; Wonder Guard: GHOSTT takes nothing except SE-vs-Bug/Ghost types
   	db NORMAL,       GHOSTT, NO_EFFECT
   	db FIGHTING,     GHOSTT, NO_EFFECT
   	db POISON,       GHOSTT, NO_EFFECT
   	db GROUND,       GHOSTT, NO_EFFECT
   	db BUG,          GHOSTT, NO_EFFECT
   	db STEEL,        GHOSTT, NO_EFFECT
   	db WATER,        GHOSTT, NO_EFFECT
   	db GRASS,        GHOSTT, NO_EFFECT
   	db ELECTRIC,     GHOSTT, NO_EFFECT
   	db PSYCHIC_TYPE, GHOSTT, NO_EFFECT
   	db ICE,          GHOSTT, NO_EFFECT
   	db DRAGON,       GHOSTT, NO_EFFECT
   	db GHOST,        GHOSTT, SUPER_EFFECTIVE
   	db GHOSTT,       GHOSTT, SUPER_EFFECTIVE
   	; FLYING, ROCK, FIRE vs GHOSTT: leave neutral; BUG (2nd type) supplies the 2x
   ```
   With plain **BUG** as the second type the existing chart already gives Fire/Flying/Rock ×2 and, importantly, Gen 1's Poison→Bug ×2 and Ground/Grass/Fighting ×½ vs Bug are all zeroed by the GHOSTT `NO_EFFECT` (0 × anything = 0). So one variant type is sufficient; the video's "two variations of Bug and Ghost" can be read as *also* cloning Bug (e.g. `BUGG`) — only needed if you want Shedinja's second type to differ from other Bugs. Not required for the behaviour shown.
4. GHOSTT as **attacker** (for Shadow Claw/Sneak STAB and matchups) should mirror GHOST: `db GHOSTT, GHOST, SUPER_EFFECTIVE`, `db GHOSTT, NORMAL, NO_EFFECT`, and — if you want Gen 1 fidelity — `db GHOSTT, PSYCHIC_TYPE, NO_EFFECT` (the Gen 1 Ghost-vs-Psychic bug). Omit that last row if you'd rather Shadow Claw hit Psychics.
5. STEEL as attacker (Gen 2 chart): SE vs ROCK, ICE; NVE vs FIRE, WATER, ELECTRIC, STEEL. Defensive Steel rows are irrelevant unless another mon gets the type.
6. STAB: `engine/battle/core.asm` compares the move type against both of the attacker's types, so GHOSTT moves on a GHOSTT mon get STAB with no extra work.
7. Trainer AI: the Gen 1 AI's type-effectiveness pass consults the same table, so smarter trainers will start avoiding NO_EFFECT moves — same as in the video (the Goldeen trainer "did not have good AI").

### B2. New moves: Shadow Claw, Shadow Sneak, Shadow Ball, Metal Claw

**Where:** `constants/move_constants.asm` (append after `STRUGGLE`; `NUM_ATTACKS` is derived), `data/moves/names.asm`, `data/moves/moves.asm`, `data/moves/animations.asm`, `data/battle/critical_hit_moves.asm`, `engine/battle/core.asm`.

| Move | `moves.asm` entry | Extra wiring |
|---|---|---|
| Shadow Claw | `move SHADOW_CLAW, NO_ADDITIONAL_EFFECT, 70, GHOSTT, 100, 15` (video's in-game PP is 15; its overlay table says 35 — pick one) | Add `db SHADOW_CLAW` to `HighCriticalMoves` in `data/battle/critical_hit_moves.asm` (that's how Slash works; core.asm:4642). |
| Shadow Sneak | `move SHADOW_SNEAK, NO_ADDITIONAL_EFFECT, 40, GHOSTT, 100, 30` | Priority is hard-coded, not an effect: `engine/battle/core.asm:371–390` special-cases `QUICK_ATTACK` (and `COUNTER`). Add matching `cp SHADOW_SNEAK` branches next to each `cp QUICK_ATTACK`. |
| Shadow Ball | `move SHADOW_BALL, DEFENSE_DOWN_SIDE_EFFECT, 80, GHOSTT, 100, 15` | Reuses Acid's effect. Note Gen 1's stat-down side effects fire at **33 %**, not Gen VIII's 20 % (`engine/battle/effects.asm:560`). Type could be GHOST instead of GHOSTT if you prefer it to obey the vanilla Ghost row (no STAB difference since both are Shedinja's types only if GHOSTT is used). |
| Metal Claw | `move METAL_CLAW, <effect>, 50, STEEL, 95, 35` | There is **no "raise user's stat as a side effect"** effect in Gen 1 (`ATTACK_UP1_EFFECT` is a whole-move effect like Meditate). The video says it has a 10 % Attack-up chance, so the author added one. Cheapest route: a new `ATTACK_UP_SIDE_EFFECT` handled like `StatModifierUpEffect` but gated on a random roll, modelled on the `…_DOWN_SIDE_EFFECT` branch in `engine/battle/effects.asm:557–563`; register it in `data/moves/effects_pointers.asm`. Or just ship it as `NO_ADDITIONAL_EFFECT` — "it's just not a great move" anyway. |

Animations: every move needs a row in `data/moves/animations.asm`; reuse existing IDs (Slash/Scratch for the claws, Quick Attack for Sneak, Night Shade or Confuse Ray for Ball). `moves.asm` asserts PP ≤ 40, which all of these satisfy.

### B3. Species data

**Where:** `constants/pokemon_constants.asm` (+ `DEX_*`), `data/pokemon/base_stats/shedinja.asm` (new, include it from `data/pokemon/base_stats.asm`… wherever the `INCLUDE` list lives), `data/pokemon/evos_moves.asm`, `data/pokemon/names.asm`, dex entries, `gfx/pokemon/front|back/shedinja.pic`, palettes, cries.

Either overwrite an existing species (fewest touch points) or add a new index; the video doesn't say which. Base stats file, following `data/pokemon/base_stats/ninetales.asm`:

```asm
	db DEX_SHEDINJA ; pokedex id

	db   1,  90,  45,  40,  30
	;   hp  atk  def  spd  spc

	db GHOSTT, BUG ; type
	db 45 ; catch rate  (real value; not shown in video)
	db 83 ; base exp    (real Gen V+ value; not shown in video)

	INCBIN "gfx/pokemon/front/shedinja.pic", 0, 1
	dw ShedinjaPicFront, ShedinjaPicBack

	db SHADOW_CLAW, METAL_CLAW, DIG, HARDEN ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate (video's choice; see A5)

	; tm/hm learnset
	tmhm HYPER_BEAM, SEISMIC_TOSS, MEGA_DRAIN, DIG, MIMIC, SUBSTITUTE
	; end

	db 0 ; padding
```
(Confirmed TM numbers in `constants/item_constants.asm`: TM15 Hyper Beam, TM19 Seismic Toss, TM21 Mega Drain, TM28 Dig, TM31 Mimic, TM50 Substitute; TM03 Swords Dance intentionally absent.)

`data/pokemon/evos_moves.asm`:
```asm
ShedinjaEvosMoves:
; Evolutions
	db 0
; Learnset
	db 15, CONFUSE_RAY
	db 23, ABSORB
	db 29, SHADOW_SNEAK
	db 36, FURY_SWIPES
	db 50, SHADOW_BALL
	db 0
```

Starter: `constants/pokemon_constants.asm:204–206` — set `STARTER3 EQU SHEDINJA` to reproduce the video (rival gets Charmander). The Oak's-lab ball sprites/text still say Bulbasaur unless you also touch those scripts.

### B4. 1 HP — doing in the ROM what the video did with GameHook

The video *didn't* solve this in the ROM (A4). The single choke point in pokered is `CalcStat::` in `home/move_mon.asm:54`; every path that produces HP (`AddPartyMon`, level-up at `engine/battle/core.asm:6152`, Rare Candy, Day-Care, box withdraw, enemy/wild load) goes through it. The HP branch is at `home/move_mon.asm:190–203` (`cp $1` → adds Level, then +10).

Minimal patch sketch — at the top of the HP branch, if the species being calculated is Shedinja, force the result to 1:

```asm
	ld a, c
	cp $1
	ld a, 5 ; + 5 for non-HP stat
	jr nz, .notHPStat
	; --- Shedinja: HP is always 1 ---
	ld a, [wMonHIndex]         ; first byte of wMonHeader = internal species index once copied to WRAM (ram/wram.asm:1514)
	cp SHEDINJA
	jr nz, .normalHP
	xor a
	ldh [hMultiplicand], a
	ldh [hMultiplicand+1], a
	inc a
	ldh [hMultiplicand+2], a   ; result = 1
	jr .noOverflow             ; existing label just before the pops/ret (home/move_mon.asm:228)
.normalHP
	ld a, [wCurEnemyLVL]
	...
```
Things to verify while doing it: `wMonHeader` is populated (via `GetMonHeader`) for the mon being calculated on every call path; the on-level-up code in `core.asm` adds `(newMax − oldMax)` to current HP, which stays 0 with a constant max; and HP-restoring items clamp to max, so they're safe. Rest sets HP = max, also fine.

If you'd rather stay faithful to the video's external approach, the RAM addresses GameHook would poke are `wPartyMon1HP` / `wPartyMon1MaxHP` and, during battle, `wBattleMonHP` / `wBattleMonMaxHP` — both copies must be written, which is exactly why the video's hook is "janky".

### B5. Experience group

`GrowthRateTable` in `data/growth_rates.asm` only expresses polynomial formulas (`growth_rate a, b, c, d, e`). Erratic is piecewise (four formulas by level band), so it cannot be added as a table row — this matches the author's "not worth the hassle." Keep `GROWTH_MEDIUM_FAST` per the video, or use `GROWTH_SLOW` if you want the harsher early game he rejected.

### B6. Things the video says are coming *after* 10:00 (not covered here)

- Why Harden is "a little bit funny" (2:22).
- Further damage sources ("other ways we can be damaged", 1:53).
- The Normal/Flying wall ("keep this in the back of your mind for later", 9:16).
- More GameHook glitches ("you'll get to see it be a little bit janky", 6:05).

---

## Part C — Inputs still needed before implementing

Verified 2026-09-21: `make clean && make -j8` succeeds with the installed RGBDS 1.0.3 (only `STRIN` deprecation warnings) and `pokered.gbc` matches `roms.sha1`. mGBA.app is installed for testing. The "disassembly repo" linked in the video description is upstream `pret/pokered` — this tree — so there is no author fork to copy from; the video plus these notes are the whole spec.

### C1. Blocking — I cannot proceed without these

| # | Need | Why | Options |
|---|---|---|---|
| 1 | **Front sprite PNG** — 40×40, 48×48 or 56×56, 2-bit grayscale (4 shades), same format as `gfx/pokemon/front/bulbasaur.png` | Every species needs one; the build's `pkmncompress` makes the `.pic`. The first 10 min of video never shows the front sprite in-game (only the player-side back sprite). | (a) You supply one (e.g. downscale/requantize a Gen 3 Shedinja sprite); (b) I scan the rest of the 44-min video for a party/status screen and reconstruct it; (c) I draw a placeholder. |
| 2 | **Back sprite PNG** — 32×32, 2-bit grayscale, like `gfx/pokemon/back/bulbasaurb.png` | Same. This one *is* visible in the video (player side, every battle) and could be reconstructed pixel-for-pixel from a clean frame at ~4.5× scale. | (a) You supply; (b) I reconstruct from the video. |
| 3 | **Replace an existing species, or add a new index?** | Determines scope. *Replace Bulbasaur* (recommended): touches only its base-stats file, `evos_moves`, `names`, `dex_*`, `palettes`, `cries`, `menu_icons`, and two PNGs; the starter slot, Oak's-lab ball, and rival logic then match the video for free (rival gets Charmander). *Add index #191*: additionally `pokemon_constants` / `pokedex_constants` (`NUM_POKEMON` → 152, so re-check the Pokédex seen/owned bit arrays), `dex_order.asm`, the dex-ordered `INCLUDE` list in `data/pokemon/base_stats.asm`, the evos/moves pointer table, `gfx/pics.asm`, and the pic-bank rule in `home/pics.asm:12-46` (index ≥ $99 → "Pics 5", so appending works if bank $D has room). | Your call. |

### C2. Decisions where the video is ambiguous or silent — I'll default as shown unless told otherwise

| # | Question | Default |
|---|---|---|
| 4 | Shadow Claw PP: 15 (in-game HUD, Gen VIII) or 35 (his overlay table)? | **15** |
| 5 | Metal Claw's "10 % Attack-up chance": add a new side-effect handler, or ship as `NO_ADDITIONAL_EFFECT`? | **Implement it** (new `ATTACK_UP_SIDE_EFFECT`, 10 %); small and matches the video. |
| 6 | Shadow Ball / Shadow Sneak type: `GHOSTT` (STAB, Wonder-Guard chart) or vanilla `GHOST`? | **GHOSTT** for all three Shadow moves, matching Shadow Claw's on-screen `TYPE/ GHOSTT`. |
| 7 | Keep Gen 1's Ghost→Psychic "no effect" bug for GHOSTT attacks? | **No** — GHOSTT hits Psychic normally (Gen 2+ behaviour, and the run is otherwise modern-learnset-based). Say so if you want strict Gen 1 parity. |
| 8 | 1 HP: do it in the ROM (`CalcStat` patch, Part B4) or leave HP normal like the distributed patch and rely on external tooling? | **In the ROM.** This is the one place we'd deliberately improve on the video. |
| 9 | Clone BUG as well ("two variations")? | **No** — one GHOSTT variant plus vanilla BUG reproduces the shown behaviour (Part B1). |
| 10 | Starter slot | `STARTER3` (Bulbasaur's slot) — matches the footage. |
| 11 | Move animations for the four new moves | Reuse: Slash → Shadow Claw, Quick Attack → Shadow Sneak, Night Shade → Shadow Ball, Scratch → Metal Claw. |
| 12 | SGB palette / menu icon / cry | `PAL_BROWNMON`, bug icon, a tuned copy of an existing cry. Cosmetic; easy to change later. |
| 13 | Pokédex data (category "SHED", 2'07", 2.6 lb, flavor text) | Take from Gen 3 canon, trimmed to the Gen 1 text box. |

### C3. Not needed

- The author's ROM/patch or GameHook profile — nothing in it is required once 1 HP is done in-ROM.
- The Shedinja artwork shown in his overlay — it's a stream graphic, not game data.
- Anything from beyond 10:30 *except* possibly a front-sprite sighting (item 1b) and whatever "Harden is a little bit funny" turns out to mean (likely a cosmetic/AI quirk, not a spec change).

### C4. For verification

- mGBA is installed; testing is manual unless you want me to script it (mGBA has Lua scripting from 0.10). A save state parked at Oak's lab, or a willingness to use the debug build target, would make iteration much faster than replaying the intro each time.

---

## Part D — Implementation log (2026-09-21, branch `shedinja`, uncommitted)

Decisions taken: **species replaces Mew** (index $15, dex #151), sprites supplied/reconstructed as below, and every Part C default kept (Shadow Claw PP 15, Metal Claw 10 % Attack-up implemented, all three Shadow moves typed GHOSTT, no Gen 1 Ghost→Psychic bug, 1 HP done in-ROM, single GHOSTT variant, `STARTER3 = SHEDINJA`).

| Area | Files | What |
|---|---|---|
| Types | `constants/type_constants.asm`, `data/types/names.asm`, `data/types/type_matchups.asm`, `engine/battle/core.asm` | `WONDER` ($09, the Ghost variant — renamed from the video's GHOSTT), `GUARD` ($0A, an exact copy of Bug's matchups) and `STEEL` ($0B), all in the physical range; Shedinja is WONDER/GUARD so the status screen reads `TYPE1/ WONDER`, `TYPE2/ GUARD`. Wonder Guard is the block of `x, WONDER, NO_EFFECT` rows. **Those rows must stay last in the chart**: the engine multiplies damage by every matching row but only remembers the *last* row's multiplier for the message, so with `POISON→GUARD ×2` after `POISON→WONDER ×0` Poison Sting printed "attack missed" instead of "doesn't affect". STAB (`AdjustDamageForMoveType`) treats WONDER≡GHOST and GUARD≡BUG, so vanilla Ghost and Bug moves keep the bonus. |
| Moves | `constants/move_constants.asm`, `data/moves/{names,moves,animations,sfx}.asm`, `data/battle/critical_hit_moves.asm` | Shadow Claw / Shadow Sneak / Shadow Ball (typed WONDER) / Metal Claw (STEEL) inserted **before** STRUGGLE (Metronome asserts `NUM_ATTACKS == STRUGGLE`). Animations reuse Slash / Quick Attack / Night Shade / Scratch. |
| Priority | `engine/battle/core.asm` (`IsPriorityMove`) | Shadow Sneak handled wherever Quick Attack was. |
| Metal Claw effect | `constants/move_effect_constants.asm`, `data/moves/effects_pointers.asm`, `engine/battle/effects.asm` | New `ATTACK_UP_SIDE_EFFECT`: 10 % roll, then runs as a normal +1 Attack effect. |
| Species | `data/pokemon/shedinja.asm` (was `mew.asm`, bank 1), `data/pokemon/base_stats/shedinja.asm`, `evos_moves`, `names`, `palettes` (BROWNMON), `cries`, `menu_icons` (bug), `dex_entries` ("SHED", 2'07", 2.6 lb), `dex_text`, `dex_order`, `constants/pokemon_constants.asm`, `constants/pokedex_constants.asm`, `home/pokemon.asm`, `home/pics.asm`, `engine/debug/debug_party.asm`, `main.asm` | All Mew references renamed; base stats 1/90/45/40/30, GHOSTT/BUG, catch 45, base exp 83, Medium Fast, L1 moves Shadow Claw/Metal Claw/Dig/Harden, TMs 15/19/21/28/31/50. |
| Starter | `scripts/OaksLab.asm`, `text/OaksLab.asm`, `engine/events/starter_dex.asm` | **All three balls** hand the player a Shedinja (one shared "You want the shed #MON, SHEDINJA?" prompt, Pokédex preview shows #151). `STARTER1..3` stay vanilla: the rival still takes the counterpart of the ball you chose (left→Squirtle, middle→Bulbasaur, right→Charmander), and his walk to the remaining ball is now keyed off his own pick. |
| Title / intro | `data/pokemon/title_mons.asm`, `engine/movie/title.asm`, `engine/movie/oak_speech/oak_speech.asm` | Title screen shows only Shedinja (all 16 slots; the vanilla "must pick a different mon" retry loop was removed since it would never terminate). Oak's speech shows Shedinja instead of Nidorino and plays Shedinja's cry (`sound_cry_shedinja`, formerly the `sound_cry_nidorina` text command, which nothing else used). The intro *movie* (Gengar vs Nidorino) is unchanged — it uses dedicated intro graphics, not species sprites. |
| 1 HP | `home/move_mon.asm` (`CalcStat`) | HP result forced to 1 when `wMonHIndex == SHEDINJA` — covers creation, level-up, Rare Candy, Day-Care, box, enemy load. |
| Sprites | `gfx/pokemon/front/shedinja.png` (48×48, your PNG mirrored to face left like every Gen 1 front sprite), `gfx/pokemon/back/shedinjab.png` (48×48) | The video's back sprite is drawn at **native 6×6 tiles**, not 2×-scaled 4×4 (the 2×2-block test failed on 247/784 blocks), so it was reconstructed pixel-for-pixel at 48×48 (identical across 7 frames from 4 battles). |
| Title text | `gfx/title/red_version.png`, `gfx/version.asm`, `engine/movie/title.asm`, `Makefile` | Title screen says **"Shed Version"**: the 1bpp graphic (which secretly held "RedGreenVersion") now has "Shed" in its first three tiles — `S` and `h` drawn in the same 2-px bold font, `e`/`d`/"Version" reused verbatim — with the old "Green" tiles blanked; the tile string gained one tile and moved from column 7 to 6 to stay centered. Tile count must stay even (VRAM offset is `(10 tiles − size)/2`). Cartridge header title is `POKEMON SHED` (Red and Red-VC targets); the Blue targets are untouched. |
| Back-sprite path | `engine/battle/core.asm` (`LoadMonBackPic`) | For Shedinja, skip `ScaleSpriteByTwo` and center the 6×6 pic in the 7×7 box via `LoadUncompressedSpriteData` (dimension byte: width in `a` low nybble, height in `c` high nybble). Every other species is untouched. The 32×32 lossy fallbacks were generated (`scratchpad/back/cand_*.png`) but look poor; not used. |

Build: `make` clean from scratch with RGBDS 1.0.3, no errors (only pre-existing deprecation warnings).

Verified headlessly (PyBoy, `pokeblue_debug.gbc` → title-screen SELECT → `FIGHT` test battle, with `wTestBattlePlayerSelectedMove` poked to choose moves):
- Battle RAM: species $15, **HP 1/1 at L5, L6 and L20**, types (WONDER, GUARD), L5 moveset Shadow Claw / Metal Claw / Dig / Harden.
- Status screen: №151, `TYPE1/ WONDER`, `TYPE2/ GUARD`, front sprite; party menu shows the bug icon.
- Back sprite in battle: **100 % pixel match** against the reconstruction.
- Rattata Tackle/Quick Attack, Charmander Scratch and Weedle Poison Sting → `It doesn't affect SHEDINJA!`; Spearow Peck and Charmander Ember → `It's super effective!` → `SHEDINJA fainted!`; Growl/Tail Whip/String Shot still land (real Wonder Guard doesn't stop status moves either).
- STAB probe (`wDamageMultipliers` bit 7): Lick (Ghost), Leech Life (Bug) and Shadow Claw (WONDER) all get STAB; Scratch (Normal) doesn't.
- Oak's speech: the cry command loads Shedinja's cry data ($60/$C0), not Nidorina's ($2C/$E0).
- Title screen renders "Shed Version" (tiles $60–$62, space, $65–$69 at column 6); ROM header bytes read `POKEMON SHED`.
- Shadow Claw vs Charmander: `Critical hit!` (62.5 % rate), KO, `SHEDINJA grew to level 6!` with party and battle HP still 1/1. Shadow Claw vs Rattata is `It doesn't affect` — correct, Ghost can't hit Normal (the video uses Metal Claw on Rattata for the same reason).
- Shadow Sneak: Shedinja moves before a faster Rattata; with Shadow Claw selected the same Rattata moves first.
- Metal Claw: `SHEDINJA's ATTACK rose!` in 2/30 trials.

Full intro playthrough (PyBoy, `pokered.gbc`, title → speech → bedroom → Route 1 → lab): title mon is Shedinja before and after a cycle; Oak's speech sprite is Shedinja; each of the three balls → Pokédex preview (sprite, 2'07", 2.6 lb, entry text) → "SHEDINJA?" → `RED received a SHEDINJA!`, party = Shedinja, `wRivalStarter` = Squirtle / Bulbasaur / Charmander for left / middle / right, and the rival walks to the correct remaining ball each time.

Not exercised at runtime: SGB palette (PyBoy has no SGB).

Known quirk worth a thought: with max HP 1, Gen 1 Substitute (TM50) costs ¼ × 1 = 0 HP and creates a 1-HP decoy — a free hit absorber the real games never allowed. Drop TM50 from the compat list if you want to close that.

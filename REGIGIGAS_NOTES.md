# Regigigas in Pokémon Red — Implementation Notes

Source: GymLeaderMatt, *"How OVERPOWERED Would Regigigas Be in Generation 1?"* (YouTube `RUQ5VdAcD-w`), implementation details through 3:35.
Derived from the narration (YouTube auto-captions) plus the on-screen overlays and in-game screens. Timestamps are video time.

Branch `regigigas`, cut from `master` (fabe2b3f). Regigigas replaces **Mew** (internal index $15, dex #151).

---

## Part A — What the video specifies

### A1. The premise (0:00–0:24)

Regigigas is "infamously known for an awful ability that makes it all but useless" — Slow Start. **Gen 1 has no abilities, so there is nothing to implement.** That absence is the whole point of the video, and it costs zero code.

### A2. Stats (0:24–0:36)

| | Value |
|---|---|
| HP | 110 |
| Attack | 160 |
| Defense | 110 |
| Special | 110 |
| Speed | 100 |
| Total | 590 |
| Exp group | **Slow** (overlay `EXP GROUP SLOW`, and 3:17 "a slow leveling group Pokemon") |
| Type | **Normal** (overlay `NRM` badge; in Gen 1 a single-type mon stores NORMAL in both type slots) |
| Starter | yes, level 5 |

Cross-checked two independent ways: the displayed crit rate of 19.53% is exactly 100/512 (confirming base Speed 100), and the level-5 overlay stats (HP 27 / Atk 22 / Def 17 / Spc 17 / Spd 16) reproduce exactly from these bases with max DVs under the Gen 1 formula.

*Deviations from the video: Slow Start **is** implemented here (Part D), and the learnset has been modernized to generation 9 (Part E).*

### A3. Moves (0:36–1:08, 1:56–3:02)

He uses the **Gen 6** learnset as the base, then picks and chooses: "the level one moves that you're seeing here… they just use the bottom four and the rest require a move relearner." No other level-up moves were recreated because "they just aren't useful or they will be learned at the level that we would have already beat the game at."

Implemented set, read from the persistent overlay table:

| How | Move | Pwr | Acc | PP |
|---|---|---|---|---|
| Lv 1 | **Crush Grip** | 100 | 100 | 5 |
| Lv 1 | Ice Punch | 75 | 100 | 15 |
| Lv 1 | Thunder Punch | 75 | 100 | 15 |
| Lv 1 | Dizzy Punch | 70 | 100 | 10 |
| TM01 | Mega Punch | 80 | 85 | |
| TM08 | Body Slam | 85 | 100 | |
| TM14 | Blizzard | 120 | 90 | |
| TM24 | Thunderbolt | 95 | 100 | |
| TM26 | Earthquake | 100 | 100 | |
| TM48 | Rock Slide | 75 | 90 | |

**Only Crush Grip is new.** Every other move already exists in Gen 1 at exactly the power and accuracy shown, and the six TM numbers are the vanilla ones.

**Crush Grip (1:56–3:02).** The real move's power scales with the target's remaining HP — 120 at full, down to 1 at 1%. He deliberately replaced that with a flat **100 power Normal, 100% accuracy, 5 PP**, calling it "only the second time that I've ever used my executive power to change a move to make it more in line with my vision" (the other being Regieleki's Thunder Cage). His stated reasons: he wanted it stronger than Body Slam so the mid-game choice between them would be interesting given Body Slam's 1-in-3 paralysis, and "since the move only has 5 PP anything less than 100 sort of felt bad and not really indicative of a legendary signature move."

### A4. Reading the overlay

The `*` next to some moves marks **STAB**, not "newly added" — the starred entries are exactly the Normal-type ones, and the left-hand in-battle panel shows STAB-adjusted power (Crush Grip 150, Dizzy Punch 105, the non-Normal punches unchanged at 75).

### A5. Sprites

The back sprite is drawn at **native 6×6 tiles (48×48)**, not the vanilla 4×4 scaled 2×: 256 of 784 2×2 pixel blocks fail the uniformity test, and the ink extent is exactly 48×48 at the position the engine centers a 6×6 pic. Same finding, and same engine change, as the Shedinja run.

---

## Part B — What was built

| Area | Files | What |
|---|---|---|
| New move | `constants/move_constants.asm`, `data/moves/{names,moves,animations,sfx}.asm` | `CRUSH_GRIP` inserted **before** `STRUGGLE` (Metronome asserts `NUM_ATTACKS == STRUGGLE`): 100 power, NORMAL, 100%, 5 PP, no additional effect. Animation and sfx reuse Mega Punch. |
| Species | `data/pokemon/regigigas.asm` (was `mew.asm`, bank 1), `data/pokemon/base_stats/regigigas.asm`, `evos_moves`, `names`, `palettes` (YELLOWMON), `cries`, `menu_icons`, `dex_entries` ("COLOSSAL", 12'02", 925.9 lb), `dex_text`, `dex_order`, `constants/pokemon_constants.asm`, `constants/pokedex_constants.asm`, `home/pokemon.asm`, `home/pics.asm`, `engine/debug/debug_party.asm`, `main.asm` | All Mew references renamed. Base stats 110/160/110/100/110, NORMAL/NORMAL, catch rate 3, base exp 220, Slow growth, L1 moveset Crush Grip / Ice Punch / Thunder Punch / Dizzy Punch, TMs 01/08/14/24/26/48, empty level-up learnset. |
| Sprites | `gfx/pokemon/front/regigigas.png` (56×56, supplied), `gfx/pokemon/back/regigigasb.png` (48×48, reconstructed from the video) | Front is 7×7 tiles (a standard vanilla size — 56 of the 151 originals use it); back is 6×6. |
| Back-sprite path | `engine/battle/core.asm` (`LoadMonBackPic`) | For Regigigas, skip `ScaleSpriteByTwo` and center the 6×6 pic in the 7×7 box via `LoadUncompressedSpriteData` (dimension byte: width in `a`'s low nybble, height in `c`'s high nybble). Every other species is untouched. |
| Starter | `scripts/OaksLab.asm`, `text/OaksLab.asm`, `engine/events/starter_dex.asm` | **All three balls** hand the player a Regigigas (one shared "You want the colossal #MON, REGIGIGAS?" prompt, Pokédex preview shows #151). `STARTER1..3` stay vanilla: the rival still takes the counterpart of the ball you chose (left→Squirtle, middle→Bulbasaur, right→Charmander), and his walk to the remaining ball is keyed off his own pick. |
| Title / intro | `data/pokemon/title_mons.asm`, `engine/movie/title.asm`, `engine/movie/oak_speech/oak_speech.asm`, `macros/scripts/text.asm`, `home/text.asm` | Title screen shows only Regigigas (all 16 slots; the vanilla "must pick a different mon" retry loop was removed since it would never terminate). Oak's speech shows Regigigas instead of Nidorino and plays its cry (`sound_cry_regigigas`, formerly the `sound_cry_nidorina` text command, which nothing else used). The intro *movie* (Gengar vs Nidorino) is unchanged — it uses dedicated intro graphics, not species sprites. |

### Values the video never shows

Catch rate and base experience. Regigigas's real values were used: **catch rate 3**, **base exp 220** (which sits naturally in Gen 1's range — Mewtwo is 220).

---

## Part C — Verification

Clean `make` from scratch with RGBDS 1.0.3, no errors.

**Read straight out of the built ROM:** base stats 110/160/110/100/110, types NORMAL/NORMAL, catch 3, base exp 220, sprite dims `$77`, L1 moves Crush Grip / Ice Punch / Thunder Punch / Dizzy Punch, growth rate 5 (Slow), TM bits → 1, 8, 14, 24, 26, 48. Crush Grip's move entry: power 100, NORMAL, 100%, 5 PP.

**Played headlessly (PyBoy, `pokered.gbc`, title → Oak's speech → bedroom → Route 1 → lab):**
- Title mon is Regigigas before and after a cycle; Oak's speech shows Regigigas and loads its cry data ($F0/$20, not Nidorina's $2C/$E0).
- Each of the three balls → Pokédex preview (front sprite, №151, COLOSSAL, 12'02", 925.9 lb, entry text) → "REGIGIGAS?" → `RED received a REGIGIGAS!`; party = Regigigas, `wRivalStarter` = Squirtle / Bulbasaur / Charmander for left / middle / right, and the rival walks to the correct remaining ball each time.

**In battle (debug build's TestBattle):**
- Level 5 HP 27/27 — matches the video's overlay exactly. Types (0,0) = NORMAL.
- PP 5 / 15 / 15 / 10 — matches the video's table.
- Back sprite: **100% pixel match** against the reconstruction.
- STAB (`wDamageMultipliers` bit 7): Crush Grip and Dizzy Punch get it, Ice Punch does not.

Sprite reconstruction was validated by rebuilding the *enemy* Geodude from the same frames and matching the repo's own `geodude.png` at 100%, which pins the pixel calibration (screen at x 393–1526, y 29–1049, 7.0875 video px per GB pixel). The Regigigas back sprite itself is identical across 8 frames drawn from two different battles (Brock's Onix and Misty's Staryu).

Not exercised at runtime: SGB palette (PyBoy has no SGB).

---

## Part D — Slow Start (deliberate deviation from the video)

The video's premise is that Gen 1 has no abilities, so Slow Start doesn't exist. This build puts it back, hardcoded to Regigigas rather than by adding an ability system.

**Behaviour:** for the first `SLOW_START_TURNS` (5) full turns after Regigigas enters the field, its **Attack and Speed are halved**. Switching out and back in re-arms it, exactly as the real ability does.

**Messages.** Gen 1 has no ability for the player to inspect and never shows in-battle stats, so the effect would otherwise be invisible. Two lines make it legible:

- On send-out, straight after `Go! REGIGIGAS!` — `<USER> is slow to start!`
- At the end of the fifth turn — `<USER> got its act together!`

(The real games announce only the wear-off; the entry line is a deliberate addition. Its wording drops the real message's "finally" because `REGIGIGAS finally got` is 21 characters against an 18-character text box.)

| Piece | Where | Note |
|---|---|---|
| Counter | `ram/wram.asm` → `wSlowStartTurns` at **$D06E** | Claims an existing unnamed `ds 1` padding byte between `wPlayerDisabledMove` and `wEnemyNumAttacksLeft`, so **no other WRAM address shifts** (verified: `wEnemyNumAttacksLeft` is still $D06F, `wPlayerName` still $D158). Nothing else reads or clears that byte. |
| Arming | `engine/battle/core.asm`, `SendOutMon` | Set to 5 when the mon being sent out is Regigigas, 0 otherwise — so it is self-clearing for every other species and every new battle. |
| Attack | `engine/battle/core.asm`, `GetDamageVarsForPlayerAttack.scaleStats` → `SlowStartHalveAttack` | Applied at the point the damage routine has just read the offensive stat. **This deliberately sits after the critical-hit branch**, which reads the unmodified Attack straight out of the party data — hooking anywhere earlier would let crits ignore Slow Start entirely, and Regigigas crits ~19.5% of the time (base Speed 100). Skipped for special moves, since Slow Start does not touch Special. |
| Speed | `engine/battle/core.asm`, `MainInBattleLoop.compareSpeed` → `GetPlayerSpeedForTurnOrder` | The vanilla `StringCmp` against two RAM addresses was replaced with an inline 16-bit compare so the halved value never needs to be written anywhere. |
| Countdown | `engine/battle/core.asm`, `SlowStartEndOfTurn` | Called after `CheckNumAttacksLeft` in both turn-order branches, i.e. once per full turn. |
| Messages | `engine/battle/core.asm` (`SlowStartAnnounce`, `SlowStartEndOfTurn`) + `data/text/text_2.asm` → `_SlowStartBeganText`, `_SlowStartEndedText` | Both use the `<USER>` text macro, which resolves through `hWhoseTurn`, so each zeroes it first to name the player's mon. The entry line is printed at the tail of `SendOutMon` *before* `PrintEmptyString`, so the text box is cleared again before the screen is saved. |

Both halvings floor at 1 rather than 0, so a stat can never be scaled out of existence.

### A quirk worth knowing

Gen 1 splits physical/special **by move type**, and Ice/Electric are special types. So Ice Punch and Thunder Punch run off Special and are **not** weakened by Slow Start — only the Normal-type moves (Crush Grip, Dizzy Punch, Body Slam, Mega Punch) are. That happens to match the real ability, which leaves Special Attack alone, and it gives the early game a real texture: during the first five turns the punches are your full-power option.

### Verified

Regigigas L20 vs Rattata L20, enemy speed pinned between half and full Regigigas speed, enemy restricted to a non-priority move, PP topped up each turn:

- Message order on entry: `Wild RATTATA appeared!` → `Go! REGIGIGAS!` → `REGIGIGAS is slow to start!`, with the counter armed to 5.
- Counter runs 5 → 4 → 3 → 2 → 1 → 0, and `REGIGIGAS got its act together!` prints at the end of turn 5.
- **Turn order:** enemy moves first on turns 1–5, Regigigas moves first from turn 6 on — the speed halving and its restoration are both real.
- **Crush Grip damage** (3 runs, 30 turns, split by the critical-hit flag with a status-only enemy so the flag is unambiguous):

| | non-crit | crit |
|---|---|---|
| Slow Start active | ~45–52 | ~82 |
| Slow Start over | ~92–103 | 184 |

  Both tiers halve cleanly, and the crit column confirms the hook covers the critical-hit path.

**Scope:** the hooks are player-side only (`wBattleMonSpecies`, `wPlayerMoveType`, `wBattleMonSpeed`), which is complete for this ROM since Regigigas is obtainable only as the starter. An *enemy* Regigigas — reachable only through the debug party — would not have Slow Start.

---

## Part E — Modernizing the learnset to generation 9

The video's set is the generation 6 learnset. Generation 9 (Scarlet/Violet) reworked it substantially, and this build now follows gen 9 instead. Learnset checked against **pokemondb** and **Serebii**, which agree exactly on the level-up list.

### What gen 9 actually gives it

| Lv | Move | Type | Gen 1 verdict |
|---|---|---|---|
| 1 | Pound | Normal | kept |
| 1 | Confuse Ray | Ghost | kept |
| 6 | Payback | Dark | **dropped** — no Dark type |
| 12 | Facade | Normal | **added** (its 2x-when-statused effect is not expressible) |
| 18 | Stomp | Normal | kept |
| 24 | Protect | Normal | **dropped** — no such mechanic |
| 30 | Knock Off | Dark | **dropped** — no Dark type |
| 36 | Mega Punch | Normal | kept |
| 42 | Body Press | Fighting | **dropped** — attacks off Defense |
| 48 | Wide Guard | Rock | **dropped** — doubles-only mechanic |
| 54 | Zen Headbutt | Psychic | **added** |
| 60 | Heavy Slam | Steel | **dropped** — no Steel type on this branch |
| 66 | Hammer Arm | Fighting | **added** (the self Speed drop is not expressible) |
| 72 | Giga Impact | Normal | **substituted** with Hyper Beam — gen 1's is an exact match at 150/90%/5 PP with a recharge turn |
| 78 | Crush Grip | Normal | kept |

### Decisions taken

**1. Levels rescaled to gen 1 pacing.** Gen 9 runs the curve out to level 78, but Regigigas is in the *slow* growth group and a gen 1 playthrough ends in the fifties — a verbatim port would leave the signature move and Giga Impact permanently unreachable, with Pound as the only attack for the first eighteen levels. The gen 9 *order* is preserved and only the levels are compressed:

```
 1  Pound          (gen 9: 1)      30  Zen Headbutt  (gen 9: 54)
 1  Confuse Ray    (gen 9: 1)      38  Hammer Arm    (gen 9: 66)
 8  Facade         (gen 9: 12)     44  Hyper Beam    (gen 9: 72, as Giga Impact)
14  Stomp          (gen 9: 18)     48  Crush Grip    (gen 9: 78)
22  Mega Punch     (gen 9: 36)
```

**2. TM list = gen 9's TMs intersected with gen 1's 50.** TM01 Mega Punch, TM08 Body Slam, TM10 Double-Edge, TM15 Hyper Beam, TM24 Thunderbolt, TM25 Thunder, TM26 Earthquake, TM44 Rest, TM45 Thunder Wave, TM48 Rock Slide, TM50 Substitute. Fire/Thunder/Ice Punch are gen 9 TMs but not gen 1 TMs, so they are simply not available. Hyper Beam is both a level-up move and a TM, exactly as Giga Impact is in gen 9.

**3. No new types.** Dark and Steel stay out, so Payback, Knock Off and Heavy Slam are dropped rather than retyped.

### Two casualties worth flagging

Generation 9 drops both **Blizzard** and **Dizzy Punch** from the learnset entirely. Dizzy Punch was one of the video's four starting moves and Blizzard was its strongest TM, so modernizing costs Regigigas its 120-power Ice option. It also now *starts* with only Pound and Confuse Ray instead of four strong moves, which makes the early game markedly harder — that is faithful to gen 9, not an oversight.

### The three new moves

| Move | Entry | Gen 1 compromise |
|---|---|---|
| Facade | 70 / Normal / 100% / 20 PP | Effect dropped; gen 1 cannot check the user's status for a damage bonus. |
| Zen Headbutt | 80 / Psychic / 90% / 15 PP | Real flinch chance is 20%; gen 1 offers only 10% or 30%, so `FLINCH_SIDE_EFFECT1` (10%) was chosen to avoid buffing an already overpowered mon. Switching to `FLINCH_SIDE_EFFECT2` is a one-word change. |
| Hammer Arm | 100 / Fighting / 90% / 10 PP | Effect dropped; gen 1 has no "lower the user's Speed" side effect. |

Animations and cries are reused (Body Slam, Confusion and Submission respectively).

### An interaction worth knowing

Gen 1 decides physical vs special **by move type**, so **Zen Headbutt is a special move here** and runs off Special (110) rather than Attack (160). That means it is the one damaging move Slow Start does not weaken — during the opening five turns it is Regigigas' best option, while every Normal and Fighting move is at half power.

### Verified

Read out of the built ROM: level-1 moveset `POUND, CONFUSE_RAY, NO_MOVE, NO_MOVE`; learnset L8/14/22/30/38/44/48; TM bits → 1, 8, 10, 15, 24, 25, 26, 44, 45, 48, 50; and the three new move entries at the values above.

In the emulator, movesets come out right at every level (L5 Pound + Confuse Ray; L20 Pound, Confuse Ray, Facade, Stomp; L50 Zen Headbutt, Hammer Arm, Hyper Beam, Crush Grip), and damage sampling with RNG jitter confirms the Slow Start split:

| Move | Slow Start on | Slow Start off |
|---|---|---|
| Crush Grip (Normal) | 76 | 145 |
| Facade (Normal) | 55 | 108 |
| Hammer Arm (Fighting) | 90–103 (crit 163–168) | 179–206 (crit 345–377) |
| **Zen Headbutt (Psychic)** | **63–74 (crit 137)** | **63–74 (crit 137)** |

## Not done

ROM/title-screen renaming (explicitly not requested). `regigigas_00.png` at the repo root is the supplied source art; the build uses the copy in `gfx/pokemon/front/`, so the root file can be deleted whenever you like.

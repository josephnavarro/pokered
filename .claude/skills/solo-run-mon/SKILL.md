---
name: solo-run-mon
description: Implement a cross-generation Pokemon into this pokered tree for a solo-challenge ROM hack, usually following a GymLeaderMatt reference video. Use when asked to add/implement a Pokemon (Shedinja, Regigigas, ...), port a modern learnset into gen 1, reconstruct sprites from gameplay footage, or hardcode a modern ability into gen 1. Covers video analysis, species replacement, new moves and types, and emulator verification.
---

# Implementing a solo-run Pokemon in pokered

Pattern used for Shedinja (branch `shedinja`) and Regigigas (branch `regigigas`). Each lives on its own branch cut from `master`, with a `<NAME>_NOTES.md` at the repo root recording what the source specified, what was built, and how it was verified. **Write that notes file — it is the deliverable the user relies on between sessions.**

## Workflow

1. **Branch.** `git checkout master && git checkout -b <mon>`. Check `git status` first; do not carry another mon's work across.
2. **Analyze the source video** (below). Report findings before building.
3. **Surface decisions** with AskUserQuestion — which species to replace, sprite sourcing, scope of flavor extras. These materially change the work.
4. **Pause for the front sprite.** It is almost never visible in the footage (you only see the player's *back* sprite in battle). The user supplies it. The back sprite you can usually reconstruct.
5. **Implement** — see `references/species-checklist.md`.
6. **Verify in the emulator** — see `scripts/`. "It builds" is not verification.
7. **Write/update the notes file.**

## Video analysis

Captions and frames:

```bash
yt-dlp --skip-download --write-auto-sub --sub-lang "en.*" -o out "https://www.youtube.com/watch?v=<ID>"
ffmpeg -v error -t <secs> -i "<file.mkv>" -vf "fps=1/10,scale=640:-1,tile=3x2" -q:v 3 sheet_%02d.jpg
```

Contact sheets at `fps=1/10, tile=3x2` give one minute per sheet — good for locating the stat/learnset panels. Then pull full-res frames at the interesting timestamps.

What to extract, and how to corroborate it rather than trusting one reading:

- **Base stats** from the overlay panel. Cross-check two ways: the displayed crit rate equals `baseSpeed/512`, and the level-N overlay stats must reproduce from the bases under the gen 1 formula with max DVs.
- **Moves/TMs** from the persistent side table. **A `*` next to a move marks STAB, not "newly added"** — the left in-battle panel shows STAB-adjusted power (e.g. 100 -> 150). Work out what is genuinely new by diffing against `data/moves/moves.asm`.
- **Growth rate / type** from the overlay badges.
- Check whether every move already exists in gen 1 before assuming you must add it. For Regigigas only Crush Grip was new; everything else matched vanilla power/accuracy exactly.

Sprites: `scripts/reconstruct_sprite.py` handles calibration, the native-vs-scaled test, and majority voting. Read its header for the method.

## Hard-won engine facts

Full list in `references/engine-gotchas.md`. The ones that bite every time:

- **Back sprites**: these hacks draw the back pic at native 6x6, not vanilla's 2x-scaled 4x4. Needs a branch in `LoadMonBackPic`. Test the footage before assuming either.
- **New moves go *before* `STRUGGLE`** — `core.asm` asserts `NUM_ATTACKS == STRUGGLE`.
- **Physical vs special is by move TYPE** (`type >= SPECIAL`), not per-move. Ice Punch and Zen Headbutt are *special* in gen 1. This changes which stat they use and whether stat-halving effects touch them.
- **New types must go in the `UNUSED_TYPES` gap below `SPECIAL`** or their moves become special.
- **Type chart rows are order-sensitive**: damage is multiplied by every matching row but the *message* comes from the last one. Immunity rows must come last.
- There is **unused `ds` padding in the battle WRAM region** (e.g. `$D06E`) usable for new per-battle state without shifting any address.

## Verification

`scripts/pyboy_harness.py` drives the debug build's `TestBattle` (title screen + SELECT -> FIGHT). It patches the player species/level and opponent into the ROM, and gives you screen-text decoding, damage/STAB probes and stat reads.

`scripts/verify_rom.py` reads base stats, learnset, TM bits and move entries straight out of the built ROM — the most reliable check, since it bypasses random DVs.

Pitfalls that produced wrong conclusions in past sessions:

- **PyBoy is deterministic.** Identical inputs give identical RNG. If one condition changes turn order, the RNG stream shifts and you can get "every trial crits" artifacts. Add random tick jitter before the action to decorrelate.
- **TestBattle forces POUND** via `wTestBattlePlayerSelectedMove`; poke that address to choose a move. The *menu* still spends the real move's PP, so restore PP each turn or a 5 PP move dries up by turn 6 and later turns silently never run.
- **Enemy priority moves** (Quick Attack) bypass speed checks — neuter the enemy moveset when testing turn order.
- Pin enemy HP high when you need a target to survive many turns.
- Separate crit from non-crit samples before comparing damage; a crit roughly doubles damage and will masquerade as "the effect didn't apply".

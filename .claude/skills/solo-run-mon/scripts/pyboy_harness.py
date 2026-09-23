#!/usr/bin/env python3
"""PyBoy harness for testing a modded pokered build.

Two entry points:

  TestBattle  -- fastest.  Build `pokeblue_debug.gbc`, then patch the player's
                 species/level and the opponent into a copy of the ROM and jump
                 straight into a battle from the title screen (hold SELECT, then
                 START, then FIGHT).  No save file, no overworld walking.

  Game        -- boots the real `pokered.gbc` for intro/lab/overworld checks.

Setup:
    python3 -m venv venv && ./venv/bin/pip install pyboy pillow numpy

Example:
    from pyboy_harness import TestBattle
    g = TestBattle(level=20, opponent=0xA5, species=0x15, nick="REGIGIGAS")
    g.to_battle_menu()
    print(g.stats())
    print(g.take_turn(move=0xA5))

READ THIS BEFORE TRUSTING A RESULT
  * PyBoy is deterministic: same inputs => same RNG.  If the condition you are
    varying also changes turn order, the RNG stream shifts and you can get
    absurd artifacts ("every single trial was a crit").  Call `g.jitter()`
    before the action to decorrelate, and take several samples.
  * TestBattle hardcodes POUND into wTestBattlePlayerSelectedMove; `take_turn`
    overrides it.  The *menu* still spends the real slot-1 move's PP, so a 5 PP
    move dries up by turn 6 and later turns silently never execute.
    `restore_pp()` each turn.
  * Enemy priority moves (Quick Attack) bypass the speed check entirely -- use
    `set_enemy_moves()` when testing turn order.
  * Separate crit from non-crit samples before comparing damage; a crit roughly
    doubles it and will look like "the effect didn't apply".
  * PrintMenuItem is skipped in TestBattle, so the move-info (TYPE/PP) box never
    draws.  Check the type via the status screen or verify_rom.py instead.
"""
import os
import random
import re

import numpy as np
from PIL import Image
from pyboy import PyBoy

REPO = os.environ.get("POKERED", os.getcwd())

# WRAM addresses are stable across these builds, but re-check with:
#   grep -iE " wBattleMonHP$" pokeblue_debug.sym
A = dict(
    wTestBattlePlayerSelectedMove=0xCCD9, wCriticalHitOrOHKO=0xD05E, wMoveMissed=0xD05F,
    wDamageMultipliers=0xD05B, wDamage=0xD0D7, wIsInBattle=0xD057,
    wBattleMonSpecies=0xD014, wBattleMonHP=0xD015, wBattleMonType1=0xD019,
    wBattleMonType2=0xD01A, wBattleMonMoves=0xD01C, wBattleMonLevel=0xD022,
    wBattleMonMaxHP=0xD023, wBattleMonAttack=0xD025, wBattleMonSpeed=0xD029,
    wBattleMonPP=0xD02D, wEnemyMonSpecies=0xCFE5, wEnemyMonHP=0xCFE6,
    wEnemyMonMoves=0xCFED, wEnemyMonMaxHP=0xCFF4, wEnemyMonSpeed=0xCFFA,
    wCurMap=0xD35E, wYCoord=0xD361, wXCoord=0xD362, wPartyCount=0xD163,
    wPartyMon1Species=0xD16B, wPlayerStarter=0xD717, wRivalStarter=0xD715,
    wTitleMonSpecies=0xCD3D, wJoyIgnore=0xCD6B, wWalkCounter=0xCFC5,
    wFrequencyModifier=0xC0F1, wTempoModifier=0xC0F2, wTileMap=0xC3A0,
)

# tile id -> character, for reading the screen (the game's own wTileMap buffer;
# PyBoy's tilemap view is unreliable here because the game draws via $9C00)
CH = {0x7F: " ", 0xE7: "!", 0xE8: ".", 0xE6: "?", 0xE3: "-", 0xF4: ",", 0xBA: "e",
      0xED: ">", 0xEE: "v", 0xE1: "P", 0xE2: "k", 0xF3: "/", 0x9C: ":", 0x6E: "L", 0x54: "#"}
for _i in range(26):
    CH[0x80 + _i] = chr(65 + _i)
    CH[0xA0 + _i] = chr(97 + _i)
for _i in range(10):
    CH[0xF6 + _i] = str(_i)


class Base:
    def __init__(self, rom, shots="shots"):
        self.pb = PyBoy(rom, window="null", sound_emulated=False)
        self.pb.set_emulation_speed(0)
        self.shots = shots
        os.makedirs(shots, exist_ok=True)

    # --- primitives -------------------------------------------------------
    def tick(self, n=1):
        self.pb.tick(n)

    def press(self, btn, hold=2, wait=10):
        self.pb.button_press(btn); self.pb.tick(hold)
        self.pb.button_release(btn); self.pb.tick(wait)

    def jitter(self, lo=1, hi=180):
        self.pb.tick(random.randint(lo, hi))

    def r(self, k):
        return self.pb.memory[A[k]]

    def r16(self, k):
        return self.pb.memory[A[k]] * 256 + self.pb.memory[A[k] + 1]

    def w16(self, k, v):
        self.pb.memory[A[k]] = v >> 8
        self.pb.memory[A[k] + 1] = v & 0xFF

    def shot(self, name):
        Image.fromarray(np.array(self.pb.screen.ndarray)[:, :, :3]).resize(
            (480, 432), Image.NEAREST).save(f"{self.shots}/{name}.png")

    # --- screen text ------------------------------------------------------
    def row(self, y, x0=0, x1=20):
        m = self.pb.memory
        return "".join(CH.get(m[A["wTileMap"] + y * 20 + x], "?") for x in range(x0, x1))

    def screen(self):
        return [self.row(y).rstrip() for y in range(18)]

    def has(self, text):
        return any(text in r for r in self.screen())

    def textbox(self):
        return " ".join(x for x in (self.row(14, 1, 19).rstrip(),
                                    self.row(16, 1, 19).rstrip()) if x).strip()

    def at_fight_menu(self):
        return self.pb.memory[A["wTileMap"] + 14 * 20 + 9] == 0xED and \
            self.row(14, 10, 15) == "FIGHT"

    def wait_for(self, text, max_frames=1500, retry=None):
        for i in range(max_frames // 10):
            if self.has(text):
                return True
            if retry and i % 4 == 3:
                self.press(retry, hold=2, wait=8)
            else:
                self.tick(10)
        raise RuntimeError(f"timeout waiting for {text!r}")

    def stop(self):
        self.pb.stop()


class TestBattle(Base):
    """Jump straight into a battle in the debug build."""

    def __init__(self, level, opponent, species=0x15, nick="REGIGIGAS", out="t.gbc", **kw):
        src = os.path.join(REPO, "pokeblue_debug.gbc")
        sym = open(os.path.join(REPO, "pokeblue_debug.sym")).read()
        b, a = re.search(r"([0-9a-f]{2}):([0-9a-f]{4}) TestBattle$", sym, re.M).groups()
        off = int(b, 16) * 0x4000 + (int(a, 16) - 0x4000)
        rom = bytearray(open(src, "rb").read())
        mb, ma = re.search(r"([0-9a-f]{2}):([0-9a-f]{4}) Moves$", sym, re.M).groups()
        self._moves = int(mb, 16) * 0x4000 + (int(ma, 16) - 0x4000)
        self._rom = bytes(rom)
        seg = rom[off:off + 80]
        RHYDON = 0x01
        i_pl = seg.find(bytes([0x3E, RHYDON]))
        i_lv = seg.find(bytes([0x3E, 20]))
        i_op = seg.find(bytes([0x3E, RHYDON]), i_pl + 2)
        assert min(i_pl, i_lv, i_op) >= 0, "TestBattle layout changed"
        rom[off + i_pl + 1] = species
        rom[off + i_lv + 1] = level
        rom[off + i_op + 1] = opponent
        open(out, "wb").write(rom)
        self.nick = nick
        super().__init__(out, **kw)

    def to_battle_menu(self):
        self.tick(1400)
        self.pb.button_press("select"); self.tick(5)
        self.press("start", hold=5, wait=60)
        self.pb.button_release("select")
        self.wait_for("FIGHT"); self.tick(30)
        self.press("a", wait=60)
        self.wait_for("to " + self.nick, retry="a")     # nickname yes/no menu
        self.tick(30); self.press("down", wait=15); self.press("a", wait=60)
        self.wait_for("appeared"); self.tick(60); self.press("a", wait=200)
        for _ in range(100):
            if self.at_fight_menu():
                break
            self.tick(10)
        self.tick(30)

    # --- battle helpers ---------------------------------------------------
    def stats(self):
        return dict(species=self.r("wBattleMonSpecies"), level=self.r("wBattleMonLevel"),
                    hp=self.r16("wBattleMonHP"), maxhp=self.r16("wBattleMonMaxHP"),
                    attack=self.r16("wBattleMonAttack"), speed=self.r16("wBattleMonSpeed"),
                    types=(self.r("wBattleMonType1"), self.r("wBattleMonType2")),
                    moves=[self.pb.memory[A["wBattleMonMoves"] + i] for i in range(4)],
                    pp=[self.pb.memory[A["wBattleMonPP"] + i] & 0x3F for i in range(4)],
                    enemy_hp=self.r16("wEnemyMonHP"))

    def move_pp(self, move):
        """Base PP of a move id, read from the ROM's Moves table."""
        return self._rom[self._moves + (move - 1) * 6 + 5] if move else 0

    def restore_pp(self):
        """Top every slot back up. Call once per turn: the FIGHT menu spends
        slot 1's PP even though take_turn() overrides which move executes, so a
        5 PP move otherwise runs dry and later turns silently never happen."""
        for i in range(4):
            mv = self.pb.memory[A["wBattleMonMoves"] + i]
            self.pb.memory[A["wBattleMonPP"] + i] = self.move_pp(mv)

    def set_enemy_moves(self, *moves):
        """e.g. set_enemy_moves(39) for Tail Whip only -- no damage, no priority."""
        for i in range(4):
            self.pb.memory[A["wEnemyMonMoves"] + i] = moves[i] if i < len(moves) else 0

    def pin_enemy_hp(self, hp=999):
        self.w16("wEnemyMonHP", hp); self.w16("wEnemyMonMaxHP", hp)

    def take_turn(self, move, max_frames=1500):
        """Force `move`, play out one full turn, return what happened."""
        self.pb.memory[A["wTestBattlePlayerSelectedMove"]] = move
        self.pb.memory[A["wCriticalHitOrOHKO"]] = 0
        self.press("a", wait=60); self.press("a", wait=10)
        dmg = mult = 0
        crit = False
        first = None
        msgs = []
        for i in range(max_frames):
            self.tick(1)
            d = self.r16("wDamage")
            if d > dmg:
                dmg, mult = d, self.r("wDamageMultipliers")
            if self.r("wCriticalHitOrOHKO") == 1:
                crit = True
            if i % 12 == 11:
                line = self.textbox()
                if line and (not msgs or msgs[-1] != line):
                    msgs.append(line)
                if first is None and "used" in line:
                    first = "player" if line.startswith(self.nick) else "enemy"
                if self.at_fight_menu() or self.r("wIsInBattle") == 0:
                    break
                self.press("a", hold=2, wait=1)
        return dict(damage=dmg, crit=crit, stab=bool(mult & 0x80), multiplier=mult & 0x7F,
                    moved_first=first, messages=msgs)


class Game(Base):
    """Boot the real ROM (title screen, Oak's intro, overworld, Oak's lab)."""

    def __init__(self, rom=None, **kw):
        super().__init__(rom or os.path.join(REPO, "pokered.gbc"), **kw)

    def in_textbox(self):
        return self.pb.memory[A["wTileMap"] + 12 * 20] == 0x79   # the box's top-left corner

    def pos(self):
        return (self.r("wCurMap"), self.r("wXCoord"), self.r("wYCoord"))

    def walk(self, direction, steps):
        """Step-accurate movement -- waits for each tile to finish."""
        for _ in range(steps):
            self.pb.button_press(direction); self.pb.tick(4)
            self.pb.button_release(direction)
            for _ in range(40):
                self.pb.tick(1)
                if self.r("wWalkCounter") == 0:
                    break
            self.pb.tick(4)
        return self.pos()

    def mash(self, until=None, max_iter=400, wait=30):
        """Advance dialogue. Battle/intro text is slow -- wait>=30 per press."""
        for _ in range(max_iter):
            if until and self.has(until):
                return True
            if self.in_textbox():
                self.press("a", hold=2, wait=wait)
            else:
                self.tick(wait)
        return False

    def save(self, path):
        with open(path, "wb") as f:
            self.pb.save_state(f)

    def load(self, path):
        with open(path, "rb") as f:
            self.pb.load_state(f)


# Route from the bedroom to Oak's lab, for intro/starter tests.
# From (map 38, 3, 6): right 2, up 6, right 2 -> 1F; down 6, left 4, down 1 ->
# Pallet; right 5, up 3, up 3 -> stopped by Oak; then mash through the cutscene
# until wCurMap == 40 with wJoyIgnore == 0.

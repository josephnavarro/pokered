#!/usr/bin/env python3
"""Read species and move data straight out of a built ROM.

This is the most reliable check available: it bypasses the emulator entirely,
so it is unaffected by the random DVs a test battle rolls. Always confirm the
data here before drawing conclusions from in-game stat readings.

Usage (from the repo root, after `make`):
    verify_rom.py species RegigigasBaseStats
    verify_rom.py move CRUSH_GRIP FACADE
    verify_rom.py learnset RegigigasEvosMoves
"""
import argparse
import re
import sys

ROM = "pokered.gbc"
SYM = "pokered.sym"
TYPES = {0x00: "NORMAL", 0x01: "FIGHTING", 0x02: "FLYING", 0x03: "POISON", 0x04: "GROUND",
         0x05: "ROCK", 0x06: "BIRD", 0x07: "BUG", 0x08: "GHOST", 0x14: "FIRE", 0x15: "WATER",
         0x16: "GRASS", 0x17: "ELECTRIC", 0x18: "PSYCHIC", 0x19: "ICE", 0x1A: "DRAGON"}
GROWTH = {0: "MEDIUM_FAST", 1: "SLIGHTLY_FAST", 2: "SLIGHTLY_SLOW", 3: "MEDIUM_SLOW",
          4: "FAST", 5: "SLOW"}


def load():
    sym = open(SYM).read()
    rom = open(ROM, "rb").read()
    return sym, rom


def addr(sym, label):
    m = re.search(r"^([0-9a-f]{2}):([0-9a-f]{4}) %s$" % re.escape(label), sym, re.M)
    if not m:
        sys.exit(f"label {label!r} not found in {SYM}")
    return int(m.group(1), 16) * 0x4000 + (int(m.group(2), 16) - 0x4000)


def move_names():
    """move constant -> index, parsed from the source so it always matches."""
    out, n = {}, 0
    for line in open("constants/move_constants.asm"):
        m = re.match(r"\tconst ([A-Z0-9_]+)", line)
        if m:
            out[m.group(1)] = n
            n += 1
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["species", "move", "learnset"])
    ap.add_argument("args", nargs="+")
    a = ap.parse_args()
    sym, rom = load()
    names = move_names()
    by_index = {v: k for k, v in names.items()}

    if a.cmd == "species":
        raw = rom[addr(sym, a.args[0]):][:28]
        print("dex id      :", raw[0])
        print("hp/atk/def/spd/spc:", list(raw[1:6]))
        print("types       :", TYPES.get(raw[6], raw[6]), "/", TYPES.get(raw[7], raw[7]))
        print("catch rate  :", raw[8])
        print("base exp    :", raw[9])
        print("sprite dims : $%02X (%dx%d tiles)" % (raw[10], raw[10] >> 4, raw[10] & 0xF))
        print("L1 moveset  :", [by_index.get(x, x) for x in raw[15:19]])
        print("growth rate :", raw[19], GROWTH.get(raw[19], "?"))
        tms = [i + 1 for i in range(55) if rom[addr(sym, a.args[0]) + 20 + i // 8] >> (i % 8) & 1]
        print("TM/HM       :", tms)

    elif a.cmd == "learnset":
        i = addr(sym, a.args[0])
        assert rom[i] == 0, "expected no evolutions"
        i += 1
        out = []
        while rom[i]:
            out.append("L%d %s" % (rom[i], by_index.get(rom[i + 1], rom[i + 1])))
            i += 2
        print("learnset:", "; ".join(out) or "(empty)")

    else:
        base = addr(sym, "Moves")
        for nm in a.args:
            if nm not in names:
                print(f"{nm}: not a move constant"); continue
            e = rom[base + (names[nm] - 1) * 6: base + names[nm] * 6]
            print("%-14s effect=%-3d power=%-3d type=%-9s acc=%3d%% pp=%2d" %
                  (nm, e[1], e[2], TYPES.get(e[3], e[3]), round(e[4] / 255 * 100), e[5]))


if __name__ == "__main__":
    main()

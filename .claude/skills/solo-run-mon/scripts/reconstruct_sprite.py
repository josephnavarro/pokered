#!/usr/bin/env python3
"""Reconstruct a Game Boy sprite pixel-for-pixel from gameplay footage.

Method (validated on both the Shedinja and Regigigas videos):

1.  Locate the emulator screen in a full-res frame and derive the scale.
    These overlays are non-integer (7.0875 and 7.25 px per GB pixel), so the
    scale must be measured, never assumed.
2.  CALIBRATE by rebuilding a sprite you already have -- the *enemy's* front
    pic -- and diffing it against the repo PNG.  Both videos used vanilla
    enemy sprites, so this should hit 100%.  If it does not, the geometry is
    wrong and nothing downstream is trustworthy.
3.  Decide native vs 2x-scaled: if the pic were vanilla (4x4 stored, doubled
    on screen) every 2x2 block of GB pixels would be uniform.  Hundreds of
    non-uniform blocks means the hack draws it at native resolution.
4.  Sample, quantize to gen 1's four shades, and majority-vote across frames
    from *different battles* so AV1 compression noise cannot survive.

Sprite box positions (see home/pics.asm centering: x offset (8-w)/2 tiles,
y offset 7-h tiles):
    player back pic, 7x7 box at tile (1,5)  -> GB x8..63,  y40..95
    a 6x6 pic inside it                     -> GB x16..63, y48..95
    enemy front pic, 7x7 box at tile (12,0) -> GB x96..151, y0..55

Usage:
    reconstruct_sprite.py bounds   FRAME.png
    reconstruct_sprite.py calibrate FRAME.png --x0 393 --y0 29 --scale 7.0875 \\
        --ref gfx/pokemon/front/geodude.png
    reconstruct_sprite.py extract  FRAME.png [FRAME.png ...] --x0 .. --y0 .. \\
        --scale .. --gx 16 --gy 48 --w 48 --h 48 -o out.png
"""
import argparse
import sys

import numpy as np
from PIL import Image

SHADES = np.array([255, 170, 85, 0], np.uint8)


def find_bounds(path, search=(380, 1560)):
    """Locate the emulator screen by its white interior."""
    im = np.array(Image.open(path).convert("RGB")).astype(int).mean(axis=2)
    sub = im[:, search[0]:search[1]]
    cols = (sub[80:1000] > 235).mean(axis=0)
    rows = (sub[:, 100:1000] > 235).mean(axis=1)
    c = np.where(cols > 0.5)[0]
    r = np.where(rows > 0.5)[0]
    x0, x1 = int(c.min()) + search[0], int(c.max()) + search[0]
    y0, y1 = int(r.min()), int(r.max())
    return x0, y0, (x1 - x0 + 1) / 160.0, (y1 - y0 + 1) / 144.0


def sample(img, x0, y0, scale, gx, gy, r=2):
    x = int(round(x0 + (gx + 0.5) * scale))
    y = int(round(y0 + (gy + 0.5) * scale))
    return float(np.median(img[y - r:y + r + 1, x - r:x + r + 1].reshape(-1, 3), axis=0).mean())


def grid(path, x0, y0, scale, gx, gy, w, h):
    img = np.array(Image.open(path).convert("RGB")).astype(float)
    return np.array([[sample(img, x0, y0, scale, gx + i, gy + j) for i in range(w)]
                     for j in range(h)])


def quantize(lum):
    """k-means to gen 1's four shades; returns indices 0(white)..3(black)."""
    c = np.array([0.0, 85.0, 170.0, 255.0])
    for _ in range(40):
        lab = np.abs(lum[..., None] - c).argmin(-1)
        for k in range(4):
            if (lab == k).any():
                c[k] = lum[lab == k].mean()
    order = np.argsort(-c)
    remap = np.empty(4, int)
    remap[order] = np.arange(4)
    return remap[lab], np.sort(c)[::-1]


def to_index(png):
    return (3 - np.round(np.array(Image.open(png).convert("L")) / 85)).astype(int)


def block_test(lum):
    """Fraction of 2x2 blocks that are NOT uniform. ~0 => vanilla 2x scaling."""
    h, w = lum.shape
    b = lum[:h // 2 * 2, :w // 2 * 2]
    b = b.reshape(h // 2, 2, w // 2, 2).transpose(0, 2, 1, 3).reshape(h // 2, w // 2, 4)
    spread = b.max(axis=2) - b.min(axis=2)
    return int((spread > 40).sum()), spread.size


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["bounds", "calibrate", "extract"])
    ap.add_argument("frames", nargs="+")
    for a, t, d in (("--x0", float, None), ("--y0", float, None), ("--scale", float, None),
                    ("--gx", int, 16), ("--gy", int, 48), ("--w", int, 48), ("--h", int, 48)):
        ap.add_argument(a, type=t, default=d)
    ap.add_argument("--ref")
    ap.add_argument("-o", "--out", default="sprite.png")
    args = ap.parse_args()

    if args.cmd == "bounds":
        x0, y0, sx, sy = find_bounds(args.frames[0])
        print(f"x0={x0} y0={y0} scale_x={sx:.4f} scale_y={sy:.4f}")
        print("use --x0 %d --y0 %d --scale %.4f" % (x0, y0, sx))
        return

    if args.x0 is None or args.y0 is None or args.scale is None:
        sys.exit("need --x0 --y0 --scale (run the 'bounds' command first)")

    if args.cmd == "calibrate":
        ref = to_index(args.ref)
        n = ref.shape[0]
        tiles = n // 8
        gx = 96 + ((8 - tiles) // 2) * 8      # enemy front box starts at tile 12
        gy = (7 - tiles) * 8
        q, centers = quantize(grid(args.frames[0], args.x0, args.y0, args.scale, gx, gy, n, n))
        acc = (q == ref).mean()
        print(f"shade centers: {np.round(centers, 1)}")
        print(f"match vs {args.ref}: {acc:.4f}")
        print("PASS - geometry is right" if acc > 0.999 else "FAIL - fix bounds/scale first")
        return

    grids, keep = {}, []
    for f in args.frames:
        lum = grid(f, args.x0, args.y0, args.scale, args.gx, args.gy, args.w, args.h)
        grids[f] = (lum, quantize(lum)[0])
    base = grids[args.frames[0]][1]
    for f, (lum, q) in grids.items():
        agree = (q == base).mean()
        if agree > 0.9:
            keep.append(f)
        else:
            print(f"  skip {f} (agreement {agree:.2f} - sprite absent or mid-animation)")
    if not keep:
        sys.exit("no usable frames")

    bad, total = block_test(grids[keep[0]][0])
    print(f"2x2 uniformity: {bad}/{total} blocks non-uniform -> "
          + ("NATIVE resolution" if bad > total * 0.05 else "vanilla 2x-scaled"))

    stack = np.stack([grids[f][1] for f in keep])
    vote = np.apply_along_axis(lambda v: np.bincount(v, minlength=4).argmax(), 0, stack)
    print(f"{len(keep)} frames voted; unanimous on {(stack == vote).all(axis=0).mean():.4f} of pixels")
    nz = np.argwhere(vote != 0)
    if len(nz):
        print("ink extent: x %d..%d  y %d..%d" % (nz[:, 1].min() + args.gx, nz[:, 1].max() + args.gx,
                                                  nz[:, 0].min() + args.gy, nz[:, 0].max() + args.gy))
    Image.fromarray(SHADES[vote]).save(args.out)
    print("wrote", args.out)


if __name__ == "__main__":
    main()

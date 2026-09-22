; Shedinja replaces Mew, whose pics and base data are not grouped with the
; other Pokémon because Mew was a last-minute addition "as a kind of prank".
; Shigeki Morimoto explained in an Iwata Asks interview:
; "We put Mew in right at the very end. The cartridge was really full and
; there wasn't room for much more on there. Then the debug features which
; weren't going to be included in the final version of the game were removed,
; creating a miniscule 300 bytes of free space. So we thought that we could
; slot Mew in there. What we did would be unthinkable nowadays!"
; http://iwataasks.nintendo.com/interviews/#/ds/pokemon/0/0

ShedinjaPicFront:: INCBIN "gfx/pokemon/front/shedinja.pic"
ShedinjaPicBack::  INCBIN "gfx/pokemon/back/shedinjab.pic"

ShedinjaBaseStats::
INCLUDE "data/pokemon/base_stats/shedinja.asm"

	db DEX_REGIGIGAS ; pokedex id

	db 110, 160, 110, 100, 110
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 3 ; catch rate
	db 220 ; base exp

	INCBIN "gfx/pokemon/front/regigigas.pic", 0, 1 ; sprite dimensions
	dw RegigigasPicFront, RegigigasPicBack

	db POUND, CONFUSE_RAY, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset: generation 9's TM list, intersected with gen 1's 50 TMs
	tmhm MEGA_PUNCH,   BODY_SLAM,    DOUBLE_EDGE,  HYPER_BEAM,   THUNDERBOLT,  \
	     THUNDER,      EARTHQUAKE,   REST,         THUNDER_WAVE, ROCK_SLIDE,   \
	     SUBSTITUTE
	; end

	db 0 ; padding

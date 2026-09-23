	db DEX_REGIGIGAS ; pokedex id

	db 110, 160, 110, 100, 110
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 3 ; catch rate
	db 220 ; base exp

	INCBIN "gfx/pokemon/front/regigigas.pic", 0, 1 ; sprite dimensions
	dw RegigigasPicFront, RegigigasPicBack

	db CRUSH_GRIP, ICE_PUNCH, THUNDERPUNCH, DIZZY_PUNCH ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   BODY_SLAM,    BLIZZARD,     THUNDERBOLT,  EARTHQUAKE,   \
	     ROCK_SLIDE
	; end

	db 0 ; padding

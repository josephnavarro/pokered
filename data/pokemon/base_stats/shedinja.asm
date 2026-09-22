	db DEX_SHEDINJA ; pokedex id

	db   1,  90,  45,  40,  30
	;   hp  atk  def  spd  spc
	; HP is forced to 1 at every level in CalcStat (home/move_mon.asm)

	db WONDER, GUARD ; type
	db 45 ; catch rate
	db 83 ; base exp

	INCBIN "gfx/pokemon/front/shedinja.pic", 0, 1 ; sprite dimensions
	dw ShedinjaPicFront, ShedinjaPicBack

	db SHADOW_CLAW, METAL_CLAW, DIG, HARDEN ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm HYPER_BEAM,   SEISMIC_TOSS, MEGA_DRAIN,   DIG,          MIMIC,        \
	     SUBSTITUTE
	; end

	db 0 ; padding

; this function temporarily makes the starters (and Ivysaur) owned
; so that the full Pokedex information gets displayed in Oak's lab
StarterDex:
	; every ball holds a Shedinja, so only its entry needs to be shown in full
	ld hl, wPokedexOwned + (DEX_SHEDINJA - 1) / 8
	set (DEX_SHEDINJA - 1) % 8, [hl]
	predef ShowPokedexData
	ld hl, wPokedexOwned + (DEX_SHEDINJA - 1) / 8
	res (DEX_SHEDINJA - 1) % 8, [hl]
	ret

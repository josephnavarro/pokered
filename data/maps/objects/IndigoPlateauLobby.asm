	object_const_def
	const_export INDIGOPLATEAULOBBY_NURSE
	const_export INDIGOPLATEAULOBBY_GYM_GUIDE
	const_export INDIGOPLATEAULOBBY_COOLTRAINER_F
	const_export INDIGOPLATEAULOBBY_CLERK
	const_export INDIGOPLATEAULOBBY_LINK_RECEPTIONIST
	const_export INDIGOPLATEAULOBBY_BIRD_CHECKER1
	const_export INDIGOPLATEAULOBBY_BIRD_CHECKER2
	const_export INDIGOPLATEAULOBBY_BIRD_CHECKER3

IndigoPlateauLobby_Object:
	db $0 ; border block

	def_warp_events
	warp_event  7, 11, LAST_MAP, 1
	warp_event  8, 11, LAST_MAP, 2
	warp_event  8,  0, LORELEIS_ROOM, 1

	def_bg_events

	def_object_events
	object_event  7,  5, SPRITE_NURSE, STAY, DOWN, TEXT_INDIGOPLATEAULOBBY_NURSE
	object_event  4,  9, SPRITE_GYM_GUIDE, STAY, RIGHT, TEXT_INDIGOPLATEAULOBBY_GYM_GUIDE
	object_event  5,  1, SPRITE_COOLTRAINER_F, STAY, DOWN, TEXT_INDIGOPLATEAULOBBY_COOLTRAINER_F
	object_event  0,  5, SPRITE_CLERK, STAY, RIGHT, TEXT_INDIGOPLATEAULOBBY_CLERK
	object_event 13,  6, SPRITE_LINK_RECEPTIONIST, STAY, DOWN, TEXT_INDIGOPLATEAULOBBY_LINK_RECEPTIONIST
; The three checkers flank the approach to the ELITE FOUR door at (8, 0).
; They must not stand on (7, 2) and (7, 1) together, or on (8, 1) / (8, 2):
; those are the only tiles connecting the lobby to the door, and a pair of
; them there would seal it permanently even with all three birds in hand.
	object_event  7,  1, SPRITE_GUARD, STAY, RIGHT, TEXT_INDIGOPLATEAULOBBY_BIRD_CHECKER1
	object_event  9,  1, SPRITE_GUARD, STAY, LEFT, TEXT_INDIGOPLATEAULOBBY_BIRD_CHECKER2
	object_event  9,  2, SPRITE_GUARD, STAY, LEFT, TEXT_INDIGOPLATEAULOBBY_BIRD_CHECKER3

	def_warps_to INDIGO_PLATEAU_LOBBY

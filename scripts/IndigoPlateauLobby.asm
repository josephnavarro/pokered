IndigoPlateauLobby_Script:
	call Serial_TryEstablishingExternallyClockedConnection
	call EnableAutoTextBoxDrawing
	call IndigoPlateauLobbyShowOrHideEliteFourDoor
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	ResetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	ld hl, wBeatLorelei
	bit 1, [hl]
	res 1, [hl]
	ret z
	; Elite 4 events
	ResetEventRange INDIGO_PLATEAU_EVENTS_START, EVENT_LANCES_ROOM_LOCK_DOOR
	ret

IndigoPlateauLobbyShowOrHideEliteFourDoor:
; The door to the ELITE FOUR only opens for a trainer carrying all three
; legendary birds. Otherwise the doorway block is swapped for plain wall,
; the same trick LoreleiShowOrHideExitBlock uses between the ELITE FOUR rooms.
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	call IndigoPlateauLobbyHasAllThreeBirds
	ld a, $c ; wall
	jr nc, .setDoorBlock
	ld a, $d ; doorway
.setDoorBlock
	ld [wNewTileBlockID], a
	lb bc, 0, 4
	predef_jump ReplaceTileBlock

IndigoPlateauLobbyHasAllThreeBirds:
; Returns carry if ARTICUNO, ZAPDOS and MOLTRES are all in the party.
	ld a, ARTICUNO
	call IndigoPlateauLobbyIsMonInParty
	ret nc
	ld a, ZAPDOS
	call IndigoPlateauLobbyIsMonInParty
	ret nc
	ld a, MOLTRES
	; fallthrough

IndigoPlateauLobbyIsMonInParty:
; Returns carry if the species in a is in the player's party.
	ld b, a
	ld hl, wPartySpecies
.loop
	ld a, [hli]
	cp $ff ; end of the party list
	jr z, .notFound
	cp b
	jr nz, .loop
	scf
	ret
.notFound
	and a ; clear carry
	ret

IndigoPlateauLobbyBirdCheckerScript:
; a = the species this checker is looking for.
	ld [wd11e], a
	push af
	call GetMonName ; name into wcd6d, for the text_ram in both messages
	pop af
	call IndigoPlateauLobbyIsMonInParty
	ld hl, IndigoPlateauLobbyBirdMissingText
	jr nc, .print
	ld hl, IndigoPlateauLobbyBirdPresentText
.print
	jp PrintText

IndigoPlateauLobby_TextPointers:
	def_text_pointers
	dw_const IndigoPlateauLobbyNurseText,            TEXT_INDIGOPLATEAULOBBY_NURSE
	dw_const IndigoPlateauLobbyGymGuideText,         TEXT_INDIGOPLATEAULOBBY_GYM_GUIDE
	dw_const IndigoPlateauLobbyCooltrainerFText,     TEXT_INDIGOPLATEAULOBBY_COOLTRAINER_F
	dw_const IndigoPlateauLobbyClerkText,            TEXT_INDIGOPLATEAULOBBY_CLERK
	dw_const IndigoPlateauLobbyLinkReceptionistText, TEXT_INDIGOPLATEAULOBBY_LINK_RECEPTIONIST
	dw_const IndigoPlateauLobbyBirdChecker1Text,     TEXT_INDIGOPLATEAULOBBY_BIRD_CHECKER1
	dw_const IndigoPlateauLobbyBirdChecker2Text,     TEXT_INDIGOPLATEAULOBBY_BIRD_CHECKER2
	dw_const IndigoPlateauLobbyBirdChecker3Text,     TEXT_INDIGOPLATEAULOBBY_BIRD_CHECKER3

IndigoPlateauLobbyNurseText:
	script_pokecenter_nurse

IndigoPlateauLobbyGymGuideText:
	text_far _IndigoPlateauLobbyGymGuideText
	text_end

IndigoPlateauLobbyCooltrainerFText:
	text_far _IndigoPlateauLobbyCooltrainerFText
	text_end

IndigoPlateauLobbyLinkReceptionistText:
	script_cable_club_receptionist

IndigoPlateauLobbyBirdChecker1Text:
	text_asm
	ld a, ARTICUNO
	call IndigoPlateauLobbyBirdCheckerScript
	jp TextScriptEnd

IndigoPlateauLobbyBirdChecker2Text:
	text_asm
	ld a, ZAPDOS
	call IndigoPlateauLobbyBirdCheckerScript
	jp TextScriptEnd

IndigoPlateauLobbyBirdChecker3Text:
	text_asm
	ld a, MOLTRES
	call IndigoPlateauLobbyBirdCheckerScript
	jp TextScriptEnd

IndigoPlateauLobbyBirdMissingText:
	text_far _IndigoPlateauLobbyBirdMissingText
	text_asm
	ld a, SFX_DENIED
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	jp TextScriptEnd

IndigoPlateauLobbyBirdPresentText:
	text_far _IndigoPlateauLobbyBirdPresentText
	text_end

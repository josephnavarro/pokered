AnimateHealingMachine:
	ld de, PokeCenterFlashingMonitorAndHealBall
	ld hl, vChars0 tile $7c
	lb bc, BANK(PokeCenterFlashingMonitorAndHealBall), 3 ; should be 2
	call CopyVideoData
	ld hl, wUpdateSpritesEnabled
	ld a, [hl]
	push af
	ld [hl], $ff
	push hl
	ldh a, [rOBP1]
	push af
	ld a, $e0
	ldh [rOBP1], a
	ld hl, wOAMBuffer + $84
	ld de, PokeCenterOAMData
	call CopyHealingMachineOAM

	ld a, 4
	call StopMusic
	call WaitForSongToFinish
;	ld a, 4
;	ld [wAudioFadeOutControl], a
;	ld a, SFX_STOP_ALL_MUSIC
;	ld [wNewSoundID], a
;	call PlaySound
;.waitLoop
;	ld a, [wAudioFadeOutControl]
;	and a ; is fade-out finished?
;	jr nz, .waitLoop ; if not, check again

	ld a, [wPartyCount]
	ld b, a
.partyLoop
	call CopyHealingMachineOAM
	ld a, SFX_HEALING_MACHINE
	call PlaySound
	ld c, 30
	call DelayFrames
	dec b
	jr nz, .partyLoop
	ld a, [wAudioROMBank]
	cp $1f ; BANK("Audio Engine 3")
	ld [wAudioSavedROMBank], a
	jr nz, .next
	ld a, SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	ld a, 0 ; BANK(Music_PkmnHealed)
	ld [wAudioROMBank], a
.next
	ld a, MUSIC_PKMN_HEALED
	ld [wNewSoundID], a
	call PlayMusic
	ld d, $28
	call FlashSprite8Times
.waitLoop2
	ld a, [wChannel1MusicID]
	and a
	jr nz, .waitLoop2

	ld c, 32
	call DelayFrames
	pop af
	ldh [rOBP1], a
	pop hl
	pop af
	ld [hl], a
	jp UpdateSprites

PokeCenterFlashingMonitorAndHealBall:
	INCBIN "gfx/overworld/heal_machine.2bpp"

PokeCenterOAMData:
	; heal machine monitor
	dbsprite  6,  4,  4,  4, $7c, OAM_OBP1
	; poke balls 1-6
	dbsprite  6,  5,  0,  3, $7d, OAM_OBP1
	dbsprite  7,  5,  0,  3, $7d, OAM_OBP1 | OAM_HFLIP
	dbsprite  6,  6,  0,  0, $7d, OAM_OBP1
	dbsprite  7,  6,  0,  0, $7d, OAM_OBP1 | OAM_HFLIP
	dbsprite  6,  6,  0,  5, $7d, OAM_OBP1
	dbsprite  7,  6,  0,  5, $7d, OAM_OBP1 | OAM_HFLIP

; d = value to xor with palette
FlashSprite8Times:
	ld b, 8
.loop
	ldh a, [rOBP1]
	xor d
	ldh [rOBP1], a
	ld c, 10
	call DelayFrames
	dec b
	jr nz, .loop
	ret

CopyHealingMachineOAM:
; copy one OAM entry and advance the pointers
	REPT 4
	ld a, [de]
	inc de
	ld [hli], a
	ENDR
	ret

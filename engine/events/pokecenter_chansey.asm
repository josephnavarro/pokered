PokecenterChanseyText::
	ld hl, NurseChanseyText
	call PrintText
	ret

NurseChanseyText:
	text_far _NurseChanseyText
	text_end

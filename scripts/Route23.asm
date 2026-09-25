Route23_Script:
	call Route23SetVictoryRoadBoulders
	call EnableAutoTextBoxDrawing
	ld hl, Route23_ScriptPointers
	ld a, [wRoute23CurScript]
	jp CallFunctionInTable

Route23SetVictoryRoadBoulders:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	ResetEvents EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1, EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH2
	ResetEvents EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH1, EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH2
	ld a, HS_VICTORY_ROAD_3F_BOULDER
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_VICTORY_ROAD_2F_BOULDER
	ld [wMissableObjectIndex], a
	predef_jump HideObject

Route23_ScriptPointers:
	def_script_pointers
	dw_const Route23DefaultScript,        SCRIPT_ROUTE23_DEFAULT
	dw_const Route23PlayerMovingScript,   SCRIPT_ROUTE23_PLAYER_MOVING
	dw_const Route23ResetToDefaultScript, SCRIPT_ROUTE23_RESET_TO_DEFAULT

Route23DefaultScript:
; The badge checkpoints are gone: the road to VICTORY ROAD is always open.
; The gate to the ELITE FOUR now lives in the INDIGO PLATEAU LOBBY instead.
	ret

Route23PlayerMovingScript:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
Route23ResetToDefaultScript:
	ld a, SCRIPT_ROUTE23_DEFAULT
	ld [wRoute23CurScript], a
	ret

Route23_TextPointers:
	def_text_pointers
	dw_const Route23GuardText,               TEXT_ROUTE23_GUARD1
	dw_const Route23GuardText,               TEXT_ROUTE23_GUARD2
	dw_const Route23GuardText,               TEXT_ROUTE23_SWIMMER1
	dw_const Route23GuardText,               TEXT_ROUTE23_SWIMMER2
	dw_const Route23GuardText,               TEXT_ROUTE23_GUARD3
	dw_const Route23GuardText,               TEXT_ROUTE23_GUARD4
	dw_const Route23GuardText,               TEXT_ROUTE23_GUARD5
	dw_const Route23VictoryRoadGateSignText, TEXT_ROUTE23_VICTORY_ROAD_GATE_SIGN

Route23GuardText:
	text_far _Route23GuardText
	text_end

Route23VictoryRoadGateSignText:
	text_far _Route23VictoryRoadGateSignText
	text_end

; pokemon ids
; indexes for:
; - MonsterNames (see data/pokemon/names.asm)
; - EvosMovesPointerTable (see data/pokemon/evos_moves.asm)
; - CryData (see data/pokemon/cries.asm)
; - PokedexOrder (see data/pokemon/dex_order.asm)
; - PokedexEntryPointers (see data/pokemon/dex_entries.asm)
	const_def
	const NO_MON             ; $00
	const RHYDON             ; $01
	const KANGASKHAN         ; $02
	const NIDORAN_M          ; $03
	const CLEFAIRY           ; $04
	const SPEAROW            ; $05
	const VOLTORB            ; $06
	const NIDOKING           ; $07
	const SLOWBRO            ; $08
	const IVYSAUR            ; $09
	const EXEGGUTOR          ; $0A - Moon Stone (Evo Stone Glitch)
	const LICKITUNG          ; $0B
	const EXEGGCUTE          ; $0C
	const GRIMER             ; $0D
	const GENGAR             ; $0E
	const NIDORAN_F          ; $0F
	const NIDOQUEEN          ; $10
	const CUBONE             ; $11
	const RHYHORN            ; $12
	const LAPRAS             ; $13
	const ARCANINE           ; $14
	const MEW                ; $15
	const GYARADOS           ; $16
	const SHELLDER           ; $17
	const TENTACOOL          ; $18
	const GASTLY             ; $19
	const SCYTHER            ; $1A
	const STARYU             ; $1B
	const BLASTOISE          ; $1C
	const PINSIR             ; $1D
	const TANGELA            ; $1E
	const GYAOON             ; $1F	(new)
	const NIDOREIGN          ; $20	(new)  Fire Stone (Evo Stone Glitch)
	const GROWLITHE          ; $21 - Thunderstone (Evo Stone Glitch)
	const ONIX               ; $22 - Water Stone (Evo Stone Glitch)
	const FEAROW             ; $23
	const PIDGEY             ; $24
	const SLOWPOKE           ; $25
	const KADABRA            ; $26
	const GRAVELER           ; $27
	const CHANSEY            ; $28
	const MACHOKE            ; $29
	const MR_MIME            ; $2A
	const HITMONLEE          ; $2B
	const HITMONCHAN         ; $2C - Heart Stone (Evo Stone Glitch)
	const ARBOK              ; $2D
	const PARASECT           ; $2E
	const PSYDUCK            ; $2F - Leaf Stone (Evo Stone Glitch)
	const DROWZEE            ; $30
	const GOLEM              ; $31
	const BARUNDA            ; $32	(new)
	const MAGMAR             ; $33
	const BUU                ; $34	(new)
	const ELECTABUZZ         ; $35
	const MAGNETON           ; $36
	const KOFFING            ; $37
	const DEER               ; $38	(new)
	const MANKEY             ; $39
	const SEEL               ; $3A
	const DIGLETT            ; $3B
	const TAUROS             ; $3C
	const TRAMPEL            ; $3D	(new)
	const CROCKY             ; $3E	(new)
	const BLOTTLE            ; $3F	(new)
	const FARFETCHD          ; $40
	const VENONAT            ; $41
	const DRAGONITE          ; $42
	const CACTUS             ; $43	(new)
	const JAGG               ; $44	(new)
	const BITTYBAT           ; $45	(new)
	const DODUO              ; $46
	const POLIWAG            ; $47
	const JYNX               ; $48
	const MOLTRES            ; $49
	const ARTICUNO           ; $4A
	const ZAPDOS             ; $4B
	const DITTO              ; $4C - Candy Jar (Evo Stone Glitch)
	const MEOWTH             ; $4D
	const KRABBY             ; $4E
	const CHEEP              ; $4F	(new)
	const JABETTA            ; $50	(new)
	const MIKON              ; $51	(new)
	const VULPIX             ; $52
	const NINETALES          ; $53
	const PIKACHU            ; $54 - Ice Stone (Evo Stone Glitch)
	const RAICHU             ; $55 - Protector (Evo Stone Glitch)
	const RIBBITO            ; $56	(new) Poison Stone (Evo Stone Glitch)
	const CROAKOZUNA         ; $57	(new) Black Augurite (Evo Stone Glitch)
	const DRATINI            ; $58 - Dubious Disc (Evo Stone Glitch)
	const DRAGONAIR          ; $59
	const KABUTO             ; $5A
	const KABUTOPS           ; $5B - Up-Grade (Evo Stone Glitch)
	const HORSEA             ; $5C - Metal Coat (Evo Stone Glitch)
	const SEADRA             ; $5D
	const BAWLIGUA           ; $5E	(new)
	const CRYITHAN           ; $5F	(new)
	const SANDSHREW          ; $60
	const SANDSLASH          ; $61
	const OMANYTE            ; $62
	const OMASTAR            ; $63
	const JIGGLYPUFF         ; $64
	const WIGGLYTUFF         ; $65
	const EEVEE              ; $66
	const FLAREON            ; $67
	const JOLTEON            ; $68
	const VAPOREON           ; $69
	const MACHOP             ; $6A
	const ZUBAT              ; $6B
	const EKANS              ; $6C
	const PARAS              ; $6D
	const POLIWHIRL          ; $6E
	const POLIWRATH          ; $6F
	const WEEDLE             ; $70
	const KAKUNA             ; $71
	const BEEDRILL           ; $72
	const MADAAMU            ; $73	(new)
	const DODRIO             ; $74
	const PRIMEAPE           ; $75
	const DUGTRIO            ; $76
	const VENOMOTH           ; $77
	const DEWGONG            ; $78
	const PURAKKUSU          ; $79	(new)
	const PENDRAKEN          ; $7A	(new)
	const CATERPIE           ; $7B
	const METAPOD            ; $7C
	const BUTTERFREE         ; $7D
	const MACHAMP            ; $7E
	const WEIRDUCK           ; $7F	(new)
	const GOLDUCK            ; $80
	const HYPNO              ; $81
	const GOLBAT             ; $82
	const MEWTWO             ; $83
	const SNORLAX            ; $84
	const MAGIKARP           ; $85
	const KONYA              ; $86	(new)
	const OMEGA              ; $87	(new)
	const MUK                ; $88
	const DECILLA            ; $89	(new)
	const KINGLER            ; $8A
	const CLOYSTER           ; $8B
	const MAGNETITE          ; $8C	(new)
	const ELECTRODE          ; $8D
	const CLEFABLE           ; $8E
	const WEEZING            ; $8F
	const PERSIAN            ; $90
	const MAROWAK            ; $91
	const GUARDIA            ; $92	(new)
	const HAUNTER            ; $93
	const ABRA               ; $94
	const ALAKAZAM           ; $95
	const PIDGEOTTO          ; $96
	const PIDGEOT            ; $97
	const STARMIE            ; $98
	const BULBASAUR          ; $99
	const VENUSAUR           ; $9A
	const TENTACRUEL         ; $9B
	const GYOPIN             ; $9C	(new)
	const GOLDEEN            ; $9D
	const SEAKING            ; $9E
	const KOTORA             ; $9F	(new)
	const GAOTORA            ; $A0	(new)
	const GOROTORA           ; $A1	(new)
	const PUCHIKOON          ; $A2	(new)
	const PONYTA             ; $A3
	const RAPIDASH           ; $A4
	const RATTATA            ; $A5
	const RATICATE           ; $A6
	const NIDORINO           ; $A7
	const NIDORINA           ; $A8
	const GEODUDE            ; $A9
	const PORYGON            ; $AA
	const AERODACTYL         ; $AB
	const BLASTYKE           ; $AC	(new)
	const MAGNEMITE          ; $AD
	const SKIMPER            ; $AE	(new)
	const GOROCHU            ; $AF	(new)
	const CHARMANDER         ; $B0
	const SQUIRTLE           ; $B1
	const CHARMELEON         ; $B2
	const WARTORTLE          ; $B3
	const CHARIZARD          ; $B4
	const TOTARTLE           ; $B5	(new)
	const ARTICUNO_G         ; $B6	(new)
	const ZAPDOS_G           ; $FD	(new)
	const MOLTRES_G          ; $FE	(new)
	const ODDISH             ; $B9
	const GLOOM              ; $BA
	const VILEPLUME          ; $BB
	const BELLSPROUT         ; $BC
	const WEEPINBELL         ; $BD
	const VICTREEBEL         ; $BE
	const MONJA              ; $BF	(new pokemon start here)
	const SCIZOR             ; $C0
	const RHYPERIOR          ; $C1
	const ESPEON             ; $C2
	const UMBREON            ; $C3
	const LEAFEON            ; $C4
	const GLACEON            ; $C5
	const SYLVEON            ; $C6
	const LICKILICKY         ; $C7
	const TANGROWTH          ; $C8
	const KLEAVOR            ; $C9
	const TSUBOMITTO         ; $CA
	const STEELIX            ; $CB
	const BLISSEY            ; $CC
	const HITMONTOP          ; $CD
	const CROBAT             ; $CE
	const ANIMON             ; $CF
	const BELLOSSOM          ; $D0
	const PORYGON2           ; $D1
	const KINGDRA            ; $D2
	const POLITOED           ; $D3
	const SLOWKING           ; $D4
	const ELECTIVIRE         ; $D5
	const MAGMORTAR          ; $D6
	const TAABAN             ; $D7
	const KOKANA             ; $D8
	const KASANAGI           ; $D9
	const CARAPTHOR          ; $DA
	const MAGNEZONE          ; $DB
	const PORYGONZ           ; $DC
	const ANNIHILAPE         ; $DD
	const SCREAM_TAIL        ; $DE
	const SANDY_SHOCKS       ; $DF
	const WIGLETT            ; $E0
	const WUGTRIO            ; $E1
	const TOEDSCOOL          ; $E2
	const TOEDSCRUEL         ; $E3
	const PERRSERKER         ; $E4
	const SIRFETCHD          ; $E5
	const MR_RIME            ; $E6
	const MELTAN             ; $E7
	const MELMETAL           ; $E8
	const ARCANINE_H         ; $E9
	const ELECTRODE_H        ; $EA
	const RATICATE_A         ; $EB
	const RAICHU_A           ; $EC
	const SANDSLASH_A        ; $ED
	const NINETALES_A        ; $EE
	const DUGTRIO_A          ; $EF
	const PERSIAN_A          ; $F0
	const GOLEM_A            ; $F1
	const RAPIDASH_G         ; $F2
	const SLOWBRO_G          ; $F3
	const SLOWKING_G         ; $F4
	const MUK_A              ; $F5
	const EXEGGUTOR_A        ; $F6
	const MAROWAK_A          ; $F7
	const WEEZING_G          ; $F8
	const TAUROS_P           ; $F9
	const TAUROS_PA          ; $FA
	const TAUROS_PB          ; $FB	
	const FOSSIL_KABUTOPS    ; $FC	(was B6)
	const FOSSIL_AERODACTYL  ; $FD	(was B7)
	const MON_GHOST          ; $FE	(was B8)
	
DEF NUM_POKEMON_INDEXES EQU const_value - 1

; starters
DEF STARTER1 EQU CHARMANDER
DEF STARTER2 EQU SQUIRTLE
DEF STARTER3 EQU BULBASAUR
DEF STARTER4 EQU PIKACHU
DEF STARTER5 EQU EEVEE

; ghost Marowak in Pokémon Tower
DEF RESTLESS_SOUL EQU MAROWAK

MACRO move
	db \1 ; animation (interchangeable with move id)
	db \2 ; effect
	db \3 ; power
	db \4 ; type
	db \5 percent ; accuracy
	db \6 ; pp
	assert \6 <= 40, "PP must be 40 or less"
ENDM

Moves:
; Characteristics of each move.
	table_width MOVE_LENGTH, Moves
	move POUND,        HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move KARATE_CHOP,  HYPER_BEAM_EFFECT,          150, FIGHTING,     90,  5
	move DOUBLESLAP,   HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move COMET_PUNCH,  HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move MEGA_PUNCH,   HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move PAY_DAY,      HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move FIRE_PUNCH,   HYPER_BEAM_EFFECT,          150, FIRE,         90,  5
	move ICE_PUNCH,    HYPER_BEAM_EFFECT,          150, ICE,          90,  5
	move THUNDERPUNCH, HYPER_BEAM_EFFECT,          150, ELECTRIC,     90,  5
	move SCRATCH,      HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move VICEGRIP,     HYPER_BEAM_EFFECT,          150, WATER,        90,  5
	move GUILLOTINE,   HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move RAZOR_WIND,   HYPER_BEAM_EFFECT,          150, FLYING,       90,  5
	move SWORDS_DANCE, HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move CUT,          HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move GUST,         HYPER_BEAM_EFFECT,          150, FLYING,       90,  5
	move WING_ATTACK,  HYPER_BEAM_EFFECT,          150, FLYING,       90,  5
	move WHIRLWIND,    HYPER_BEAM_EFFECT,          150, FLYING,       90,  5
	move FLY,          HYPER_BEAM_EFFECT,          150, FLYING,       90,  5
	move BIND,         HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move SLAM,         HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move VINE_WHIP,    HYPER_BEAM_EFFECT,          150, GRASS,        90,  5
	move STOMP,        HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move DOUBLE_KICK,  HYPER_BEAM_EFFECT,          150, FIGHTING,     90,  5
	move MEGA_KICK,    HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move JUMP_KICK,    HYPER_BEAM_EFFECT,          150, FIGHTING,     90,  5
	move ROLLING_KICK, HYPER_BEAM_EFFECT,          150, FIGHTING,     90,  5
	move SAND_ATTACK,  HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move HEADBUTT,     HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move HORN_ATTACK,  HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move FURY_ATTACK,  HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move HORN_DRILL,   HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move TACKLE,       HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move BODY_SLAM,    HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move WRAP,         HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move TAKE_DOWN,    HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move THRASH,       HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move DOUBLE_EDGE,  HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move TAIL_WHIP,    HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move POISON_STING, HYPER_BEAM_EFFECT,          150, POISON,       90,  5
	move TWINEEDLE,    HYPER_BEAM_EFFECT,          150, BUG,          90,  5
	move PIN_MISSILE,  HYPER_BEAM_EFFECT,          150, BUG,          90,  5
	move LEER,         HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move BITE,         HYPER_BEAM_EFFECT,          150, DARK,         90,  5
	move GROWL,        HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move ROAR,         HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move SING,         HYPER_BEAM_EFFECT,          150, FAIRY,        90,  5
	move SUPERSONIC,   HYPER_BEAM_EFFECT,          150, POISON,       90,  5
	move SONICBOOM,    HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move DISABLE,      HYPER_BEAM_EFFECT,          150, NORMAL,       90,  5
	move ACID,         HYPER_BEAM_EFFECT,          150, POISON,       90,  5
	move EMBER,        HYPER_BEAM_EFFECT,          150, FIRE,         90,  5
	move FLAMETHROWER, HYPER_BEAM_EFFECT,          150, FIRE,         90,  5
	move MIST,         HYPER_BEAM_EFFECT,          150, ICE,          90,  5
	move WATER_GUN,    HYPER_BEAM_EFFECT,          150, WATER,        90,  5
	move HYDRO_PUMP,   HYPER_BEAM_EFFECT,          150, WATER,        90,  5
	move SURF,         HYPER_BEAM_EFFECT,          150, WATER,        90,  5
	move ICE_BEAM,     HYPER_BEAM_EFFECT,          150, ICE,          90,  5
	move BLIZZARD,     HYPER_BEAM_EFFECT,          150, ICE,          90,  5
	move PSYBEAM,      HYPER_BEAM_EFFECT,          150, PSYCHIC_TYPE, 90,  5
	move BUBBLEBEAM,      HYPER_BEAM_EFFECT,       150, WATER,        90,  5
	move AURORA_BEAM,     HYPER_BEAM_EFFECT,       150, ICE,          90,  5
	move HYPER_BEAM,      HYPER_BEAM_EFFECT,       150, DRAGON,       90,  5
	move PECK,            HYPER_BEAM_EFFECT,       150, FLYING,       90,  5
	move DRILL_PECK,      HYPER_BEAM_EFFECT,       150, FLYING,       90,  5
	move SUBMISSION,      HYPER_BEAM_EFFECT,       150, FIGHTING,     90,  5
	move LOW_KICK,        HYPER_BEAM_EFFECT,       150, FIGHTING,     90,  5
	move COUNTER,         HYPER_BEAM_EFFECT,       150, FIGHTING,     90,  5
	move SEISMIC_TOSS,    HYPER_BEAM_EFFECT,       150, FIGHTING,     90,  5
	move STRENGTH,        HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move ABSORB,          HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move MEGA_DRAIN,      HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move LEECH_SEED,      HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move GROWTH,          HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move RAZOR_LEAF,      HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move SOLARBEAM,       HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move POISONPOWDER,    HYPER_BEAM_EFFECT,       150, POISON,       90,  5
	move STUN_SPORE,      HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move SLEEP_POWDER,    HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move PETAL_DANCE,     HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move STRING_SHOT,     HYPER_BEAM_EFFECT,       150, BUG,          90,  5
	move DRAGON_RAGE,     HYPER_BEAM_EFFECT,       150, DRAGON,       90,  5
	move FIRE_SPIN,       HYPER_BEAM_EFFECT,       150, FIRE,         90,  5
	move THUNDERSHOCK,    HYPER_BEAM_EFFECT,       150, ELECTRIC,     90,  5
	move THUNDERBOLT,     HYPER_BEAM_EFFECT,       150, ELECTRIC,     90,  5
	move THUNDER_WAVE,    HYPER_BEAM_EFFECT,       150, ELECTRIC,     90,  5
	move THUNDER,         HYPER_BEAM_EFFECT,       150, ELECTRIC,     90,  5
	move ROCK_THROW,      HYPER_BEAM_EFFECT,       150, ROCK,         90,  5
	move EARTHQUAKE,      HYPER_BEAM_EFFECT,       150, GROUND,       90,  5
	move FISSURE,         HYPER_BEAM_EFFECT,       150, GROUND,       90,  5
	move DIG,             HYPER_BEAM_EFFECT,       150, GROUND,       90,  5
	move TOXIC,           HYPER_BEAM_EFFECT,       150, POISON,       90,  5
	move CONFUSION,       HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move PSYCHIC_M,       HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move HYPNOSIS,        HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move MEDITATE,        HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move AGILITY,         HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move QUICK_ATTACK,    HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move RAGE,            HYPER_BEAM_EFFECT,       150, DARK,         90,  5
	move TELEPORT,        HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move NIGHT_SHADE,     HYPER_BEAM_EFFECT,       150, GHOST,        90,  5
	move MIMIC,           HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SCREECH,         HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move DOUBLE_TEAM,     HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move RECOVER,         HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move HARDEN,          HYPER_BEAM_EFFECT,       150, STEEL,        90,  5
	move MINIMIZE,        HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SMOKESCREEN,     HYPER_BEAM_EFFECT,       150, GHOST,        90,  5
	move CONFUSE_RAY,     HYPER_BEAM_EFFECT,       150, GHOST,        90,  5
	move WITHDRAW,        HYPER_BEAM_EFFECT,       150, WATER,        90,  5
	move DEFENSE_CURL,    HYPER_BEAM_EFFECT,       150, STEEL,        90,  5
	move BARRIER,         HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move LIGHT_SCREEN,    HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move HAZE,            HYPER_BEAM_EFFECT,       150, ICE,          90,  5
	move REFLECT,         HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move FOCUS_ENERGY,    HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move BIDE,            HYPER_BEAM_EFFECT,       150, ROCK,         90,  5
	move METRONOME,       HYPER_BEAM_EFFECT,       150, FAIRY,        90,  5
	move MIRROR_MOVE,     HYPER_BEAM_EFFECT,       150, FLYING,       90,  5
	move SELFDESTRUCT,    EXPLODE_EFFECT,          250, NORMAL,       100, 5
	move EGG_BOMB,        HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move LICK,            HYPER_BEAM_EFFECT,       150, GHOST,        90,  5
	move SMOG,            HYPER_BEAM_EFFECT,       150, POISON,       90,  5
	move SLUDGE,          HYPER_BEAM_EFFECT,       150, POISON,       90,  5
	move BONE_CLUB,       HYPER_BEAM_EFFECT,       150, GROUND,       90,  5
	move FIRE_BLAST,      HYPER_BEAM_EFFECT,       150, FIRE,         90,  5
	move WATERFALL,       HYPER_BEAM_EFFECT,       150, WATER,        90,  5
	move CLAMP,           HYPER_BEAM_EFFECT,       150, WATER,        90,  5
	move SWIFT,           HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SKULL_BASH,      HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SPIKE_CANNON,    HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move CONSTRICT,       HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move AMNESIA,         HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move KINESIS,         HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move SOFTBOILED,      HYPER_BEAM_EFFECT,       150, FIRE,         90,  5
	move HI_JUMP_KICK,    HYPER_BEAM_EFFECT,       150, FIGHTING,     90,  5
	move GLARE,           HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move DREAM_EATER,     HYPER_BEAM_EFFECT,       150, GHOST,        90,  5
	move POISON_GAS,      HYPER_BEAM_EFFECT,       150, POISON,       90,  5
	move BARRAGE,         HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move LEECH_LIFE,      HYPER_BEAM_EFFECT,       150, BUG,          90,  5
	move LOVELY_KISS,     HYPER_BEAM_EFFECT,       150, FAIRY,        90,  5
	move SKY_ATTACK,      HYPER_BEAM_EFFECT,       150, FLYING,       90,  5
	move TRANSFORM,       HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move BUBBLE,          HYPER_BEAM_EFFECT,       150, WATER,        90,  5
	move DIZZY_PUNCH,     HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SPORE,           HYPER_BEAM_EFFECT,       150, GRASS,        90,  5
	move FLASH,           HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move PSYWAVE,         HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move SPLASH,          HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move ACID_ARMOR,      HYPER_BEAM_EFFECT,       150, POISON,       90,  5
	move CRABHAMMER,      HYPER_BEAM_EFFECT,       150, WATER,        90,  5
	move EXPLOSION,       EXPLODE_EFFECT,          250, NORMAL,       100, 5
	move FURY_SWIPES,     HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move BONEMERANG,      HYPER_BEAM_EFFECT,       150, GROUND,       90,  5
	move REST,            HYPER_BEAM_EFFECT,       150, PSYCHIC_TYPE, 90,  5
	move ROCK_SLIDE,      HYPER_BEAM_EFFECT,       150, ROCK,         90,  5
	move HYPER_FANG,      HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SHARPEN,         HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move CONVERSION,      HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move TRI_ATTACK,      HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SUPER_FANG,      HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SLASH,           HYPER_BEAM_EFFECT,       150, NORMAL,       90,  5
	move SUBSTITUTE,      HYPER_BEAM_EFFECT,       150, FIGHTING,     90,  5
	move FAIRY_WIND,      HYPER_BEAM_EFFECT,       150, FAIRY,        90,  5
	move DRAININGKISS,    HYPER_BEAM_EFFECT,       150, FAIRY,        90,  5
	move METAL_SOUND,     HYPER_BEAM_EFFECT,       150, STEEL,        90,  5
	move MAGNET_BOMB,     HYPER_BEAM_EFFECT,       150, STEEL,        90,  5
	move IRON_DEFENSE,    HYPER_BEAM_EFFECT,       150, STEEL,        90,  5
	move DAZZLE_GLEAM,    HYPER_BEAM_EFFECT,       150, FAIRY,        90,  5
	move NIGHT_SLASH,     HYPER_BEAM_EFFECT,       150, DARK,         90,  5
	move FEINT_ATTACK,    HYPER_BEAM_EFFECT,       150, DARK,         90,  5
	move IRON_HEAD,       HYPER_BEAM_EFFECT,       150, STEEL,        90,  5
	move BRUTAL_SWING,    HYPER_BEAM_EFFECT,       150, DARK,         90,  5
	move CHARM,           HYPER_BEAM_EFFECT,       150, FAIRY,        90,  5
	move SWEET_KISS,      HYPER_BEAM_EFFECT,       150, FAIRY,        90,  5
	move BULLET_PUNCH,    HYPER_BEAM_EFFECT,       150, STEEL,        90,  5
	move MIRROR_SHOT,     HYPER_BEAM_EFFECT, 	   150, STEEL,		  90,  5
	move SMART_STRIKE,    HYPER_BEAM_EFFECT,       150, STEEL,        90,  5
	move FAKE_TEARS,      HYPER_BEAM_EFFECT,       100, DARK,		  90,  5
	move FALSE_SURRENDER, HYPER_BEAM_EFFECT,       150, DARK,         90,  5 ; figure out the actual name another time
	move KOWTOW_CLEAVE,   HYPER_BEAM_EFFECT,       150, DARK,         90,  5
	move DISARMING_VOICE, HYPER_BEAM_EFFECT,       150, FAIRY,        90,  5
	move NASTY_PLOT,      HYPER_BEAM_EFFECT,       150, DARK,         90,  5
	move UPPERCUT,        HYPER_BEAM_EFFECT,       150, FIGHTING,     90,  5
	move POWDER_SNOW,     HYPER_BEAM_EFFECT,       150, ICE,          90,  5
	move STRUGGLE,        EXPLODE_EFFECT,          250, NORMAL,       100, 10
	assert_table_length NUM_ATTACKS

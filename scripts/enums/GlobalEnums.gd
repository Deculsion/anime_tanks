class_name Enums

enum Tag {
	ON_FIRE,
	IS_NANO,
	IS_DYING,
}

enum EffectType {
	DAMAGE_OVER_TIME,
	PROJECTILE,
	STAT_MULTIPLIER,
	COOLDOWN_RESET,
}

enum Stat {
	MAX_HP,
}

enum StatMultiplierType {
	FLAT,
	ADDITIVE,
	MULTIPLICATIVE,
}

enum HardpointStat {
	DAMAGE,
	SECONDARY_DAMAGE,
	MAX_AMMO,
	FIRE_RATE,
	COOLDOWN_TIME,
	OVERHEAT_GAIN,
	OVERHEAT_LOSS,
	RADIUS,
	PROJECTILE_COUNT,
}

enum Hardpoint {
	PRIMARY,
	SECONDARY,
	INTERNAL,
	SPECIAL,
	ULTIMATE,
	ARTILLERY,
}

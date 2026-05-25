class_name GameConfig
extends RefCounted

# --- Core Balance Constants ---
const BASE_TAP_VALUE: float = 1.0
const BASE_PASSIVE_RATE: float = 0.0
const PRESTIGE_THRESHOLD: float = 1000000.0
const PRESTIGE_CURRENCY_FORMULA_DIVISOR: float = 1000000.0
const MAX_OFFLINE_HOURS: int = 8
const AUTOSAVE_INTERVAL: float = 60.0
const COST_GROWTH_DEFAULT: float = 1.15
const OFFLINE_EARNING_RATE: float = 0.5
const PRESTIGE_BASE_MULTIPLIER: float = 1.0
const PRESTIGE_BONUS_PER_POINT: float = 0.1

# --- Upgrade Definitions ---
const UPGRADES: Dictionary = {
	"tap_power": {
		"name": "Tap Power",
		"description": "Increase gold per tap",
		"base_cost": 10,
		"cost_growth": 1.15,
		"effect_per_level": 1.0,
		"currency": "gold",
	},
	"auto_miner": {
		"name": "Auto Miner",
		"description": "Generates gold automatically",
		"base_cost": 50,
		"cost_growth": 1.18,
		"effect_per_level": 0.5,
		"currency": "gold",
	},
	"gold_boost": {
		"name": "Gold Boost",
		"description": "Multiply all gold income",
		"base_cost": 200,
		"cost_growth": 1.25,
		"effect_per_level": 0.1,
		"currency": "gold",
	},
	"gem_finder": {
		"name": "Gem Finder",
		"description": "Chance to find gems on tap",
		"base_cost": 500,
		"cost_growth": 1.30,
		"effect_per_level": 0.01,
		"currency": "gold",
	},
	"prestige_power": {
		"name": "Prestige Power",
		"description": "Boost prestige multiplier",
		"base_cost": 5,
		"cost_growth": 1.50,
		"effect_per_level": 0.05,
		"currency": "prestige_points",
	},
}

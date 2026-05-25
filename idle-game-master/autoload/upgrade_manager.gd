extends Node

signal upgrade_purchased(upgrade_id: String, new_level: int)

var _levels: Dictionary = {}  # upgrade_id -> int level

func _ready() -> void:
	# Initialize all upgrades at level 0
	for id in GameConfig.UPGRADES:
		_levels[id] = 0

func get_level(upgrade_id: String) -> int:
	return _levels.get(upgrade_id, 0)

func get_cost(upgrade_id: String) -> float:
	if upgrade_id not in GameConfig.UPGRADES:
		return INF
	var config = GameConfig.UPGRADES[upgrade_id]
	var level = get_level(upgrade_id)
	return config.base_cost * pow(config.cost_growth, level)

func get_effect(upgrade_id: String) -> float:
	if upgrade_id not in GameConfig.UPGRADES:
		return 0.0
	var config = GameConfig.UPGRADES[upgrade_id]
	return config.effect_per_level * get_level(upgrade_id)

func try_purchase(upgrade_id: String) -> bool:
	if upgrade_id not in GameConfig.UPGRADES:
		return false
	var config = GameConfig.UPGRADES[upgrade_id]
	var cost = get_cost(upgrade_id)
	var currency = config.get("currency", "gold")

	if CurrencyManager.spend(currency, cost):
		_levels[upgrade_id] += 1
		upgrade_purchased.emit(upgrade_id, _levels[upgrade_id])
		return true
	return false

func can_afford_upgrade(upgrade_id: String) -> bool:
	if upgrade_id not in GameConfig.UPGRADES:
		return false
	var config = GameConfig.UPGRADES[upgrade_id]
	var cost = get_cost(upgrade_id)
	var currency = config.get("currency", "gold")
	return CurrencyManager.can_afford(currency, cost)

func get_all_levels() -> Dictionary:
	return _levels.duplicate()

func set_levels(levels: Dictionary) -> void:
	for id in levels:
		if id in _levels:
			_levels[id] = levels[id]

func reset_levels(exclude: Array[String] = []) -> void:
	for id in _levels:
		if id not in exclude:
			_levels[id] = 0

# Calculate current tap value considering upgrades and prestige
func get_tap_value() -> float:
	var base = GameConfig.BASE_TAP_VALUE
	var tap_bonus = get_effect("tap_power")
	var gold_mult = 1.0 + get_effect("gold_boost")
	var prestige_mult = PrestigeManager.get_multiplier()
	return (base + tap_bonus) * gold_mult * prestige_mult

# Calculate current passive income per second
func get_passive_rate() -> float:
	var base = GameConfig.BASE_PASSIVE_RATE
	var auto_bonus = get_effect("auto_miner")
	var gold_mult = 1.0 + get_effect("gold_boost")
	var prestige_mult = PrestigeManager.get_multiplier()
	return (base + auto_bonus) * gold_mult * prestige_mult

# Calculate gem find chance per tap
func get_gem_chance() -> float:
	return get_effect("gem_finder")

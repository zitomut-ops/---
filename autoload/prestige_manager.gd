extends Node

signal prestige_available_changed(available: bool)
signal prestige_performed(points_gained: float, total_count: int)

var prestige_count: int = 0
var _was_available: bool = false

func _ready() -> void:
	# Check prestige availability when gold changes
	CurrencyManager.currency_changed.connect(_on_currency_changed)

func _on_currency_changed(currency_name: String, _new: float, _old: float) -> void:
	if currency_name == "gold":
		var available = can_prestige()
		if available != _was_available:
			_was_available = available
			prestige_available_changed.emit(available)

func can_prestige() -> bool:
	return CurrencyManager.get_amount("gold") >= GameConfig.PRESTIGE_THRESHOLD

func get_prestige_points_on_reset() -> float:
	var gold = CurrencyManager.get_amount("gold")
	if gold < GameConfig.PRESTIGE_THRESHOLD:
		return 0.0
	return floor(gold / GameConfig.PRESTIGE_CURRENCY_FORMULA_DIVISOR)

func get_multiplier() -> float:
	var prestige_points = CurrencyManager.get_amount("prestige_points")
	return GameConfig.PRESTIGE_BASE_MULTIPLIER + (prestige_points * GameConfig.PRESTIGE_BONUS_PER_POINT)

func perform_prestige() -> void:
	if not can_prestige():
		return

	var points_gained = get_prestige_points_on_reset()

	# Award prestige points
	CurrencyManager.earn("prestige_points", points_gained)

	# Reset gold (keep gems and prestige_points)
	CurrencyManager.reset_currency("gold")

	# Reset upgrades (keep prestige upgrades)
	UpgradeManager.reset_levels(["prestige_power"])

	prestige_count += 1
	prestige_performed.emit(points_gained, prestige_count)

	# Save after prestige
	SaveManager.save_game()

func get_next_prestige_at() -> float:
	return GameConfig.PRESTIGE_THRESHOLD

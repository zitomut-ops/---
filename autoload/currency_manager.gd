extends Node

signal currency_changed(currency_name: String, new_amount: float, old_amount: float)

var _currencies: Dictionary = {
	"gold": 0.0,
	"gems": 0.0,
	"prestige_points": 0.0
}

func _ready() -> void:
	pass

func get_amount(currency: String) -> float:
	return _currencies.get(currency, 0.0)

func earn(currency: String, amount: float) -> void:
	if amount <= 0 or not is_finite(amount) or not _currencies.has(currency):
		return
	var old = _currencies[currency]
	_currencies[currency] += amount
	currency_changed.emit(currency, _currencies[currency], old)

func spend(currency: String, amount: float) -> bool:
	if amount <= 0 or not is_finite(amount):
		return false
	if not can_afford(currency, amount):
		return false
	var old = _currencies[currency]
	_currencies[currency] -= amount
	currency_changed.emit(currency, _currencies[currency], old)
	return true

func can_afford(currency: String, amount: float) -> bool:
	return _currencies.get(currency, 0.0) >= amount

func set_amount(currency: String, amount: float) -> void:
	if not _currencies.has(currency) or not is_finite(amount):
		return
	var old = _currencies[currency]
	_currencies[currency] = amount
	currency_changed.emit(currency, amount, old)

func reset_currency(currency: String) -> void:
	set_amount(currency, 0.0)

func get_all_currencies() -> Dictionary:
	return _currencies.duplicate()

static func format_number(value: float) -> String:
	if is_nan(value): return "0"
	if is_inf(value): return "INF"
	if value < 0: return "-" + format_number(-value)
	if value < 1000: return str(int(value))

	var suffixes = ["", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc"]
	var magnitude = 0
	var display = value
	while display >= 1000.0 and magnitude < suffixes.size() - 1:
		display /= 1000.0
		magnitude += 1

	if display >= 100.0:
		return "%d%s" % [int(display), suffixes[magnitude]]
	elif display >= 10.0:
		return "%.1f%s" % [display, suffixes[magnitude]]
	else:
		return "%.2f%s" % [display, suffixes[magnitude]]

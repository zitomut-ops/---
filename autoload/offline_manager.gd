extends Node

signal offline_earnings_calculated(earnings: Dictionary, elapsed_seconds: float)

var _offline_earnings: Dictionary = {}
var _offline_seconds: float = 0.0

func _ready() -> void:
	pass

func calculate_offline_progress(save_data: Dictionary) -> void:
	if not save_data.has("last_played"):
		return

	var last_played = save_data.last_played
	var now = Time.get_unix_time_from_system()
	var elapsed = now - last_played

	# Guard against clock manipulation (negative elapsed)
	if elapsed < 0:
		return

	# Cap at max offline hours
	var max_seconds = GameConfig.MAX_OFFLINE_HOURS * 3600.0
	elapsed = min(elapsed, max_seconds)

	# Minimum 60 seconds to show offline popup
	if elapsed < 60.0:
		return

	_offline_seconds = elapsed

	# Calculate gold earned offline
	var passive_rate = UpgradeManager.get_passive_rate()
	var gold_earned = passive_rate * elapsed * GameConfig.OFFLINE_EARNING_RATE

	_offline_earnings = {}
	if gold_earned > 0:
		_offline_earnings["gold"] = gold_earned

	if not _offline_earnings.is_empty():
		offline_earnings_calculated.emit(_offline_earnings, elapsed)

func collect_offline_earnings() -> void:
	for currency in _offline_earnings:
		CurrencyManager.earn(currency, _offline_earnings[currency])
	_offline_earnings.clear()
	_offline_seconds = 0.0

func get_offline_earnings() -> Dictionary:
	return _offline_earnings

func get_offline_seconds() -> float:
	return _offline_seconds

func format_time(seconds: float) -> String:
	var hours = int(seconds) / 3600
	var minutes = (int(seconds) % 3600) / 60
	if hours > 0:
		return "%dh %dm" % [hours, minutes]
	else:
		return "%dm" % [minutes]

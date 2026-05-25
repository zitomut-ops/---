extends Node

const SAVE_PATH = "user://save.json"

signal game_saved
signal game_loaded

var _autosave_timer: Timer
var _total_playtime: float = 0.0
var _session_start_time: float = 0.0

func _ready() -> void:
	_session_start_time = Time.get_unix_time_from_system()

	_autosave_timer = Timer.new()
	_autosave_timer.wait_time = GameConfig.AUTOSAVE_INTERVAL
	_autosave_timer.autostart = true
	_autosave_timer.timeout.connect(_on_autosave)
	add_child(_autosave_timer)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		save_game()

func _on_autosave() -> void:
	save_game()

func save_game() -> void:
	var save_data = {
		"currencies": CurrencyManager.get_all_currencies(),
		"upgrade_levels": UpgradeManager.get_all_levels(),
		"last_played": Time.get_unix_time_from_system(),
		"total_playtime": _total_playtime + (Time.get_unix_time_from_system() - _session_start_time),
		"prestige_count": PrestigeManager.prestige_count,
		"version": 1
	}

	var json_string = JSON.stringify(save_data, "\t")
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		game_saved.emit()

func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return {}

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
		return {}

	var data = json.data
	if not data is Dictionary:
		return {}

	# Restore currencies
	if data.has("currencies"):
		for currency in data.currencies:
			CurrencyManager.set_amount(currency, data.currencies[currency])

	# Restore upgrade levels
	if data.has("upgrade_levels"):
		var levels = {}
		for key in data.upgrade_levels:
			levels[key] = int(data.upgrade_levels[key])
		UpgradeManager.set_levels(levels)

	# Restore prestige count
	if data.has("prestige_count"):
		PrestigeManager.prestige_count = int(data.prestige_count)

	# Restore playtime
	if data.has("total_playtime"):
		_total_playtime = data.total_playtime

	_session_start_time = Time.get_unix_time_from_system()
	game_loaded.emit()
	return data

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

	# Reset all systems
	for currency in ["gold", "gems", "prestige_points"]:
		CurrencyManager.reset_currency(currency)
	UpgradeManager.reset_levels()
	PrestigeManager.prestige_count = 0
	_total_playtime = 0.0
	_session_start_time = Time.get_unix_time_from_system()

func get_total_playtime() -> float:
	return _total_playtime + (Time.get_unix_time_from_system() - _session_start_time)

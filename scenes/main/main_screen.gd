extends Control

var target_scene = preload("res://scenes/Target.tscn")
@onready var upgrade_panel = $UpgradePanel # Убедись, что имя узла совпадает!
var is_panel_open: bool = false
var off_screen_pos: Vector2 = Vector2(720, 0) # Спрятана за правым краем
var on_screen_pos: Vector2 = Vector2(200, 0)  # Выдвинута на экран (настрой под себя)
@onready var gold_label: Label = $SafeArea/VBox/CurrencyDisplay/VBox/GoldLabel
@onready var gold_per_sec_label: Label = $SafeArea/VBox/CurrencyDisplay/VBox/GoldPerSecLabel
@onready var gems_label: Label = $SafeArea/VBox/TopBar/HBox/GemsLabel
@onready var prestige_points_label: Label = $SafeArea/VBox/TopBar/HBox/PrestigePointsLabel
@onready var tap_button: Button = $SafeArea/VBox/TapArea/TapButton
@onready var prestige_button: Button = $SafeArea/VBox/BottomBar/HBox/PrestigeButton
@onready var settings_button: Button = $SafeArea/VBox/BottomBar/HBox/SettingsButton
@onready var passive_timer: Timer = $PassiveTimer

var _settings_scene: PackedScene = preload("res://scenes/ui/settings_screen.tscn")
var _offline_popup_scene: PackedScene = preload("res://scenes/ui/offline_popup.tscn")
var _prestige_dialog_scene: PackedScene = preload("res://scenes/ui/prestige_dialog.tscn")


func _ready() -> void:
	
	var screen_width = get_viewport_rect().size.x
	on_screen_pos = Vector2(50, 0)
	off_screen_pos = Vector2(screen_width, 0)
	upgrade_panel.position = off_screen_pos
	
	CurrencyManager.currency_changed.connect(_on_currency_changed)
	UpgradeManager.upgrade_purchased.connect(_on_upgrade_purchased)
	PrestigeManager.prestige_available_changed.connect(_on_prestige_available_changed)
	OfflineManager.offline_earnings_calculated.connect(_on_offline_earnings_calculated)

	settings_button.pressed.connect(_on_settings_pressed)
	prestige_button.pressed.connect(_on_prestige_pressed)
	passive_timer.timeout.connect(_on_passive_tick)

	var save_data = SaveManager.load_game()
	OfflineManager.calculate_offline_progress(save_data)

	_update_all_displays()


func _on_tap_pressed() -> void:
	var tap_value = UpgradeManager.get_tap_value()
	CurrencyManager.earn("gold", tap_value)

	var gem_chance = UpgradeManager.get_gem_chance()
	if gem_chance > 0 and randf() < gem_chance:
		CurrencyManager.earn("gems", 1.0)


func _on_passive_tick() -> void:
	var passive_rate = UpgradeManager.get_passive_rate()
	if passive_rate > 0:
		CurrencyManager.earn("gold", passive_rate)


func _on_currency_changed(_currency_name: String, _new_amount: float, _old_amount: float) -> void:
	_update_all_displays()


func _on_upgrade_purchased(_upgrade_id: String, _new_level: int) -> void:
	_update_gold_per_sec()


func _on_prestige_available_changed(available: bool) -> void:
	if available:
		prestige_button.modulate = Color(1, 1, 0.5)
	else:
		prestige_button.modulate = Color(1, 1, 1)


func _on_offline_earnings_calculated(earnings: Dictionary, elapsed_seconds: float) -> void:
	var popup = _offline_popup_scene.instantiate()
	add_child(popup)
	popup.show_earnings(earnings, elapsed_seconds)


func _on_settings_pressed() -> void:
	var settings = _settings_scene.instantiate()
	add_child(settings)


func _on_prestige_pressed() -> void:
	var dialog = _prestige_dialog_scene.instantiate()
	add_child(dialog)
	dialog.show_prestige_info()


func _update_all_displays() -> void:
	var gold = CurrencyManager.get_amount("gold")
	gold_label.text = CurrencyManager.format_number(gold) + " Gold"

	var gems = CurrencyManager.get_amount("gems")
	gems_label.text = "Gems: " + CurrencyManager.format_number(gems)

	var pp = CurrencyManager.get_amount("prestige_points")
	prestige_points_label.text = "PP: " + CurrencyManager.format_number(pp)

	_update_gold_per_sec()


func _update_gold_per_sec() -> void:
	var rate = UpgradeManager.get_passive_rate()
	gold_per_sec_label.text = CurrencyManager.format_number(rate) + "/s"


func _on_menu_button_pressed() -> void:
	is_panel_open = !is_panel_open
	var target_pos = on_screen_pos if is_panel_open else off_screen_pos
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(upgrade_panel, "position", target_pos, 0.4)


func _on_spawn_timer_timeout() -> void:
	var target = target_scene.instantiate()
	
	$SpawnArea.add_child(target)
	
	var random_x = randf_range(0, $SpawnArea.size.x - target.size.x)
	
	target.position = Vector2(random_x, 0)

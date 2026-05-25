extends VBoxContainer

var _upgrade_row_scene: PackedScene = preload("res://scenes/ui/upgrade_row.tscn")
var _rows: Dictionary = {}


func _ready() -> void:
	CurrencyManager.currency_changed.connect(_on_currency_changed)
	UpgradeManager.upgrade_purchased.connect(_on_upgrade_purchased)
	_build_rows()


func _build_rows() -> void:
	for id in GameConfig.UPGRADES:
		var row = _upgrade_row_scene.instantiate()
		add_child(row)
		row.setup(id)
		_rows[id] = row


func refresh_all() -> void:
	for id in _rows:
		_rows[id].refresh()


func _on_currency_changed(_currency_name: String, _new_amount: float, _old_amount: float) -> void:
	refresh_all()


func _on_upgrade_purchased(_upgrade_id: String, _new_level: int) -> void:
	refresh_all()

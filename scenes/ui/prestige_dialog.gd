extends CanvasLayer

@onready var points_label: Label = $CenterContainer/Panel/VBox/PointsLabel
@onready var multiplier_label: Label = $CenterContainer/Panel/VBox/MultiplierLabel
@onready var confirm_button: Button = $CenterContainer/Panel/VBox/ButtonRow/ConfirmButton
@onready var cancel_button: Button = $CenterContainer/Panel/VBox/ButtonRow/CancelButton


func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)


func show_prestige_info() -> void:
	var points = PrestigeManager.get_prestige_points_on_reset()
	var current_mult = PrestigeManager.get_multiplier()
	var new_mult = current_mult + points * GameConfig.PRESTIGE_BONUS_PER_POINT

	points_label.text = "You will gain " + CurrencyManager.format_number(points) + " prestige points"
	multiplier_label.text = "Multiplier: %.1fx -> %.1fx" % [current_mult, new_mult]

	confirm_button.disabled = not PrestigeManager.can_prestige()


func _on_confirm_pressed() -> void:
	PrestigeManager.perform_prestige()
	queue_free()


func _on_cancel_pressed() -> void:
	queue_free()

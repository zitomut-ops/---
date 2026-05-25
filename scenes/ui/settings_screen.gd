extends CanvasLayer

@onready var sound_button: Button = $CenterContainer/Panel/VBox/SoundButton
@onready var reset_button: Button = $CenterContainer/Panel/VBox/ResetButton
@onready var confirm_reset: HBoxContainer = $CenterContainer/Panel/VBox/ConfirmReset
@onready var yes_button: Button = $CenterContainer/Panel/VBox/ConfirmReset/YesButton
@onready var no_button: Button = $CenterContainer/Panel/VBox/ConfirmReset/NoButton
@onready var close_button: Button = $CenterContainer/Panel/VBox/CloseButton


func _ready() -> void:
	sound_button.pressed.connect(_on_sound_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	yes_button.pressed.connect(_on_confirm_reset)
	no_button.pressed.connect(_on_cancel_reset)
	close_button.pressed.connect(_on_close_pressed)


func _on_sound_pressed() -> void:
	print("Sound toggled (placeholder)")


func _on_reset_pressed() -> void:
	confirm_reset.visible = true


func _on_confirm_reset() -> void:
	SaveManager.delete_save()
	confirm_reset.visible = false


func _on_cancel_reset() -> void:
	confirm_reset.visible = false


func _on_close_pressed() -> void:
	queue_free()

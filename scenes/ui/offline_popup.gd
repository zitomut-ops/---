extends CanvasLayer

@onready var time_label: Label = $CenterContainer/Panel/VBox/TimeLabel
@onready var earnings_label: Label = $CenterContainer/Panel/VBox/EarningsLabel
@onready var collect_button: Button = $CenterContainer/Panel/VBox/CollectButton


func _ready() -> void:
	collect_button.pressed.connect(_on_collect_pressed)


func show_earnings(earnings: Dictionary, elapsed_seconds: float) -> void:
	time_label.text = "You were away for " + OfflineManager.format_time(elapsed_seconds)

	var parts: Array[String] = []
	for currency in earnings:
		parts.append(CurrencyManager.format_number(earnings[currency]) + " " + currency)
	earnings_label.text = "You earned: " + ", ".join(parts)


func _on_collect_pressed() -> void:
	OfflineManager.collect_offline_earnings()
	queue_free()

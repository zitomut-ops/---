extends TextureButton

var fall_speed: float = 200.0 # Скорость падения

func _ready() -> void:
	# Подключаем клик по мишени
	pressed.connect(_on_pressed)

# Двигаем мишень вниз каждый кадр
func _process(delta: float) -> void:
	position.y += fall_speed * delta
	
	# Если упала за нижний край экрана (например, экран высотой 1280) — удаляем
	if position.y > 1280: 
		queue_free()

func _on_pressed() -> void:
	disabled = true
	visible = false
	CurrencyManager.earn("gold", 1.0)
	$ShootSound.play()
	await $ShootSound.finished
	queue_free()

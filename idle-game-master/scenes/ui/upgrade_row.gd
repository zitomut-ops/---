extends PanelContainer

var upgrade_id: String = ""

@onready var name_label: Label = $HBox/InfoVBox/NameLabel
@onready var desc_label: Label = $HBox/InfoVBox/DescLabel
@onready var cost_label: Label = $HBox/BuyVBox/CostLabel
@onready var buy_button: Button = $HBox/BuyVBox/BuyButton


func _ready() -> void:
	buy_button.pressed.connect(_on_buy_pressed)


func setup(id: String) -> void:
	upgrade_id = id
	var config = GameConfig.UPGRADES[id]
	desc_label.text = config.description
	refresh()


func refresh() -> void:
	if upgrade_id.is_empty():
		return
	var config = GameConfig.UPGRADES[upgrade_id]
	var level = UpgradeManager.get_level(upgrade_id)
	var cost = UpgradeManager.get_cost(upgrade_id)
	name_label.text = config.name + " Lv." + str(level)
	cost_label.text = CurrencyManager.format_number(cost)
	buy_button.disabled = not UpgradeManager.can_afford_upgrade(upgrade_id)


func _on_buy_pressed() -> void:
	UpgradeManager.try_purchase(upgrade_id)

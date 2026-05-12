extends Control

@export var data: UpgradeData

@onready var button = $TextureButton
@onready var title = $TextureButton/LabelTitle
@onready var price = $TextureButton/LabelPrice
@onready var bonus = $TextureButton/LabelBonus

@onready var stars = [
	$TextureButton/Stars/Star0,
	$TextureButton/Stars/Star1,
	$TextureButton/Stars/Star2,
	$TextureButton/Stars/Star3,
	$TextureButton/Stars/Star4,
	$TextureButton/Stars/Star5
]

func _ready():
	button.pressed.connect(_buy)
	await get_tree().process_frame
	update_ui()

func get_level():
	return Global.get_level(data.id)

func _buy():

	# защита от двойного клика
	if button.disabled:
		return

	button.disabled = true

	var lvl = Global.get_level(data.id)

	if lvl >= data.max_level:
		button.disabled = false
		return

	# безопасный индекс
	var index = min(lvl, data.prices.size() - 1)

	var price_val = data.prices[index]

	if Global.money < price_val:
		button.disabled = false
		return

	Global.money -= price_val

	var bonus_val = data.bonuses[index]

	if data.is_per_second:
		Global.moneyPerSecond += bonus_val
	else:
		Global.moneyPerClick += bonus_val

	Global.upgrades[data.id] = lvl + 1

	# SAVE
	Save.SaveValue("Main", "Money", Global.money)
	Save.SaveValue("Main", "MoneyPerSecond", Global.moneyPerSecond)
	Save.SaveValue("Main", "MoneyPerClick", Global.moneyPerClick)
	Save.SaveValue("Shops", "Upgrades", Global.upgrades)

	update_ui()

	button.disabled = false

func update_ui():

	var lvl = Global.get_level(data.id)

	for s in stars:
		s.hide()

	title.text = tr(data.title_key)

	# MAX LEVEL
	if lvl >= data.max_level:

		stars[data.max_level].show()
		price.hide()
		button.disabled = true

		var last_bonus = data.bonuses[data.max_level - 1]

		bonus.text = tr("plus_sec").format({
			"value": last_bonus
		})

		return

	# обычный уровень
	stars[lvl].show()

	price.show()
	button.disabled = false

	price.text = tr("price").format({"price": data.prices[lvl]})

	bonus.text = tr("plus_sec").format({"value": data.bonuses[lvl]})

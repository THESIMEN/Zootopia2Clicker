extends Node2D

const SHOP_MAX_LVL := 5

# Цены и бонусы (целые числа)
var prices_larok = [1, 1, 1, 1, 1]
var bonus_larok  = [1, 2, 3, 4, 5]  # целые монеты в сек

# Массив спрайтов звездочек
var stars = []

func _ready() -> void:
	# Собираем все спрайты в массив для удобства
	stars = [
		$"Scroll/Box/TextureButton/0Star",
		$"Scroll/Box/TextureButton/1Star",
		$"Scroll/Box/TextureButton/2Star",
		$"Scroll/Box/TextureButton/3Star",
		$"Scroll/Box/TextureButton/4Star",
		$"Scroll/Box/TextureButton/5Star"
	]
	
	_update_ui()

func _on_texture_button_pressed() -> void:
	if Global.shop1Click >= SHOP_MAX_LVL:
		return  # Уже MAX, кнопка заблокирована
	
	if Global.money >= prices_larok[Global.shop1Click]:
		Global.money -= prices_larok[Global.shop1Click]
		Global.moneyPerSecond += bonus_larok[Global.shop1Click]
		Global.shop1Click += 1
		
		Save.SaveValue("Main", "MoneyPerSecond", Global.moneyPerSecond)
		Save.SaveValue("Shops", "Shop1Click", Global.shop1Click)
		
		_update_ui()
	else:
		print("Не хватает Монет!!!")

func _update_ui() -> void:
	
	# Сначала скрываем все спрайты
	for s in stars:
		s.hide()
	
	# Показываем нужный спрайт
	if Global.shop1Click >= SHOP_MAX_LVL:
		stars[SHOP_MAX_LVL].show()  # 5Star для MAX
		$Scroll/Box/TextureButton/LabelPrice.hide()
		$Scroll/Box/TextureButton/Cash.hide()
		$Scroll/Box/TextureButton/LabelInfo.text = "+" + str(bonus_larok[SHOP_MAX_LVL - 1]) + " сек"
		$Scroll/Box/TextureButton.disabled = true
	else:
		stars[Global.shop1Click].show()  # 0Star…4Star
		$Scroll/Box/TextureButton/LabelPrice.text = str(prices_larok[Global.shop1Click])
		$Scroll/Box/TextureButton/LabelInfo.text = "+" + str(bonus_larok[Global.shop1Click]) + " сек"

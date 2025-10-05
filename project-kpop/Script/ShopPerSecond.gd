extends Node2D


func _ready() -> void:
	$Scroll/Box/TextureButton/LabelLVL.text = "LVL: " + str(Global.shop1Click)
	$Scroll/Box/TextureButton/LabelPrice.text = "Цена: " + str(Global.shop1Click + 1 * 10)
	
	$Scroll/Box/TextureButton2/LabelLVL.text = "LVL: " + str(Global.shop2Click)
	$Scroll/Box/TextureButton2/LabelPrice.text = "Цена: " + str(Global.shop2Click + 1 * 50)

func _on_texture_button_pressed() -> void:
	if Global.money >= Global.shop1Click + 1 * 10:
		Global.shop1Click += 1
		Global.moneyPerSecond += 1
		Global.money -= Global.shop1Click + 1 * 10
		Save.SaveValue("Main", "MoneyPerSecond", Global.moneyPerSecond)
		Save.SaveValue("Shops", "Shop1Click", Global.shop1Click)
		$Scroll/Box/TextureButton/LabelLVL.text = "LVL: " + str(Global.shop1Click)
		$Scroll/Box/TextureButton/LabelPrice.text = "Цена: " + str(Global.shop1Click + 1 * 10)
	else:
		print("Не хватает Монет!!!")


func _on_texture_button_2_pressed() -> void:
	if Global.money >= Global.shop2Click + 1 * 50:
		Global.shop2Click += 1
		Global.moneyPerSecond += 5
		Global.money -= Global.shop2Click + 1 * 50
		Save.SaveValue("Main", "MoneyPerSecond", Global.moneyPerSecond)
		Save.SaveValue("Shops", "Shop2Click", Global.shop2Click)
		$Scroll/Box/TextureButton2/LabelLVL.text = "LVL: " + str(Global.shop2Click)
		$Scroll/Box/TextureButton2/LabelPrice.text = "Цена: " + str(Global.shop2Click + 1 * 50)
	else:
		print("Не хватает Монет!!!")

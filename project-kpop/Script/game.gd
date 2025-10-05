extends Node2D

func _ready() -> void:
	$Control/LabelMoney.text = 'Money: ' + str(Global.money)
	$Control/LabelMoneyPerSecond.text = 'Money: ' + str(Global.moneyPerSecond)  + '/s'

func _physics_process(_delta):
	$Control/LabelMoney.text = 'Money: ' + str(Global.money)
	$Control/LabelMoneyPerSecond.text = 'Money: ' + str(Global.moneyPerSecond)  + '/s'

func _on_clicker_button_pressed() -> void:
	Global.money += Global.moneyPerClick
	Save.SaveValue("Main", "Money", Global.money)
	var click = load("res://Scene/Click_msg.tscn")
	var clickInstance = click.instantiate()
	clickInstance.position = get_local_mouse_position()
	add_child(clickInstance)
	
func _on_timer_timeout() -> void:
	Global.money += Global.moneyPerSecond
	$Control/LabelMoney.text = 'Money: ' + str(Global.money)
	Save.SaveValue("Main", "Money", Global.money)
func _on_close_shop_button_pressed() -> void:
	$Control/MenuShop.hide()
	$Control/ShopButton.show()

func _on_shop_button_pressed() -> void:
	$Control/ShopButton.hide()
	$Control/MenuShop.show()


func _on_money_per_click_button_pressed() -> void:
	$Control/MenuShop/ShopPerClick.show()
	$Control/MenuShop/ShopPerSecond.hide()


func _on_money_per_second_button_pressed() -> void:
	$Control/MenuShop/ShopPerSecond.show()
	$Control/MenuShop/ShopPerClick.hide()

extends Node2D

func _ready() -> void:
	$Control/LabelMoney.text = 'Money: ' + str(Global.money)
	$Control/LabelMoneyPerSecond.text = 'Money: ' + str(Global.moneyPerSecond)  + '/s'

func _on_clicker_button_pressed() -> void:
	Global.money += Global.moneyPerClick
	$Control/LabelMoney.text = 'Money: ' + str(Global.money)
	Save.SaveValue("Main", "money", Global.money)
	var click = load("res://Scene/click_msg.tscn")
	var clickInstance = click.instantiate()
	clickInstance.position = get_local_mouse_position()
	add_child(clickInstance)
	
func _on_timer_timeout() -> void:
	Global.money += Global.moneyPerSecond
	$Control/LabelMoney.text = 'Money: ' + str(Global.money)

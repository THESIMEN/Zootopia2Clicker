extends Node

var money = 0
var moneyPerSecond = 0
var moneyPerClick = 1

var shop1 = 0
var shop2 = 0

func _ready() -> void:
	money = Save.LoadValue("Main", "Money", 0)
	moneyPerSecond = Save.LoadValue("Main", "MoneyPerSecond", 0)
	shop1 = Save.LoadValue("Shops", "Shop1", 0)

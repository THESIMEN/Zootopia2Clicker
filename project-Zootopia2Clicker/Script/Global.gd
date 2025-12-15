extends Node

var money = 0
var moneyPerSecond = 0
var moneyPerClick = 1

var shop1Click = 0
var shop2Click = 0

func _ready() -> void:
	money = Save.LoadValue("Main", "Money", 0)
	moneyPerSecond = Save.LoadValue("Main", "MoneyPerSecond", 0)
	shop1Click = Save.LoadValue("Shops", "Shop1Click", 0)
	shop2Click = Save.LoadValue("Shops", "Shop2Click", 0)

extends Node

var money := 0
var moneyPerSecond := 0
var moneyPerClick := 1

var upgrades := {}

func _ready():
	money = Save.LoadValue("Main", "Money", 0)
	moneyPerSecond = Save.LoadValue("Main", "MoneyPerSecond", 0)
	moneyPerClick = Save.LoadValue("Main", "MoneyPerClick", 1)
	upgrades = Save.LoadValue("Shops", "Upgrades", {})

func get_level(id):
	return upgrades.get(id, 0)

func save():
	Save.SaveValue("Main", "Money", money)
	Save.SaveValue("Main", "MoneyPerSecond", moneyPerSecond)
	Save.SaveValue("Main", "MoneyPerClick", moneyPerClick)
	Save.SaveValue("Shops", "Upgrades", upgrades)

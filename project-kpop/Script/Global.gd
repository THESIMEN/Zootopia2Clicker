extends Node

var money = 0
var moneyPerSecond = 0
var moneyPerClick = 1

func _ready() -> void:
	money = Save.LoadValue("Main", "money", 0)

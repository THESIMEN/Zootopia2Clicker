extends Node

var money := 0
var moneyPerSecond := 0
var moneyPerClick := 1

var total_earned := 0
var player_level := 1

var upgrades := {}

func _ready():
	money = Save.LoadValue("Main", "Money", 0)
	moneyPerSecond = Save.LoadValue("Main", "MoneyPerSecond", 0)
	moneyPerClick = Save.LoadValue("Main", "MoneyPerClick", 1)
	total_earned = Save.LoadValue("Main", "TotalEarned", 0)
	player_level = Save.LoadValue("Main", "PlayerLevel", 1)
	upgrades = Save.LoadValue("Shops", "Upgrades", {})


func get_level(id):
	return upgrades.get(id, 0)


func add_money(amount):
	money += amount
	total_earned += amount

	check_level()

	Save.SaveValue("Main", "Money", money)
	Save.SaveValue("Main", "TotalEarned", total_earned)
	Save.SaveValue("Main", "PlayerLevel", player_level)


func check_level():
	var new_level := 1

	if total_earned >= 250:
		new_level = 2

	if total_earned >= 2000:
		new_level = 3

	if total_earned >= 50000:
		new_level = 4

	if total_earned >= 200000:
		new_level = 5

	if total_earned >= 750000:
		new_level = 6

	if total_earned >= 2000000:
		new_level = 7

	if total_earned >= 5000000:
		new_level = 8

	if total_earned >= 12000000:
		new_level = 9

	if total_earned >= 50000000:
		new_level = 10

	if new_level != player_level:
		player_level = new_level
		print("LEVEL UP! Новый уровень: ", player_level)


func save():
	Save.SaveValue("Main", "Money", money)
	Save.SaveValue("Main", "MoneyPerSecond", moneyPerSecond)
	Save.SaveValue("Main", "MoneyPerClick", moneyPerClick)
	Save.SaveValue("Main", "TotalEarned", total_earned)
	Save.SaveValue("Main", "PlayerLevel", player_level)
	Save.SaveValue("Shops", "Upgrades", upgrades)

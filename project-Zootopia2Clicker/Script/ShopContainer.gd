extends Node2D

@export var upgrades: Array[UpgradeData]

@onready var box = $ScrollContainer/VBoxContainer

func _ready():
	for u in upgrades:
		var cell = preload("res://Scene/UpgradeCell.tscn").instantiate()
		box.add_child(cell)
		cell.data = u

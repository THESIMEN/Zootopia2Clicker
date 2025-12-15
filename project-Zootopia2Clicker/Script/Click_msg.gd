extends Node2D

var distanceToDestroy = 10

func _ready() -> void:
	$LabelAmount.text = "+" + str(Global.moneyPerClick)

func _physics_process(_delta):
	position.y -= 4
	if position.y < -distanceToDestroy:
		queue_free()

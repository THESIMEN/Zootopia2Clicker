extends Node2D

var distanceToDestroy = 10
var value := 0

func set_value(v: int) -> void:
	value = v

func _ready() -> void:
	$LabelAmount.text = "+" + str(value)

func _physics_process(_delta):
	position.y -= 4
	if position.y < -distanceToDestroy:
		queue_free()

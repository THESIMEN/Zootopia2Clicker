extends Control

var clicks: int

func _ready() -> void:
	$TextureButton.pressed.connect(_on_click)
	_update_graphics()
	
func _on_click():
	clicks += 1
	_update_graphics()

func _update_graphics():
	$Label.text = 'Clicks: ' + str(clicks)

extends Node

export var ingameMenu = preload("res://UI/IngameMenu.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		add_child(ingameMenu.instance())
		get_tree().paused = true

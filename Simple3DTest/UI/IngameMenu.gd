extends CanvasLayer

const menu_scene_path = "res://UI/MainMenu.tscn"

onready var selector_one = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/Selector
onready var selector_two = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer2/Selector
onready var selector_three = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer3/Selector



var current_selection = 0

func _ready():
	set_current_selection(0)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)
		

func handle_selection(_current_selection):
	if _current_selection == 0:
		resume_game()
	elif _current_selection == 1:
		var menu_scene = load(menu_scene_path)
		
		for child in get_tree().get_root().get_children():
			child.queue_free()
		get_tree().get_root().add_child(menu_scene.instance())
		get_tree().paused = false
	elif _current_selection == 2:
		get_tree().quit()
		
func resume_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	
	queue_free()
func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
	if _current_selection == 0:
		selector_one.text = ">"
	elif _current_selection == 1:
		selector_two.text = ">"
	elif _current_selection == 2:
		selector_three.text = ">"

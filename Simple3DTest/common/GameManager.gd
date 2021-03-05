extends Node

signal player_initialised

var player

func _process(delta):
	if not check_player_ready(player):
		initialise_player()
		return
	
	if Input.is_action_just_pressed("freelook_camera"):
		player.get_node("ThirdPersonCamera").freelook = true
	if Input.is_action_just_released("freelook_camera"):
		player.get_node("ThirdPersonCamera").freelook = false
	
	
		
func initialise_player():
	player = get_node("/root/TestScene/Player")
	if not check_player_ready(player):
		player = null
		return
	emit_signal("player_initialised", player)
	
func check_player_ready(player):
	return player and player.isReady

extends Node


export(NodePath) var player_node_path  

export var turnSmoothTime : float = 0.1

var player_node : Player
func _ready():
	player_node = get_node(player_node_path) as KinematicBody

func _physics_process(delta):
	handle_movement(delta)
	
func handle_movement(delta):
	var direction = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		direction += player_node.transform.basis.z
		
	if Input.is_action_pressed("move_backward"):
		direction -= player_node.transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction += player_node.transform.basis.x
		
	if Input.is_action_pressed("move_right"):
		direction -= player_node.transform.basis.x
		
	direction = direction.normalized()
	
	var accel = player_node.acceleration if player_node.is_on_floor() else player_node.air_acceleration
	player_node.velocity = player_node.velocity.linear_interpolate(direction * player_node.speed, accel * delta)

	if player_node.is_on_floor():
		player_node.y_velocity = -0.01
	else:
		player_node.y_velocity = clamp(player_node.y_velocity - player_node.gravity, -player_node.max_terminal_velocity, player_node.max_terminal_velocity)

	if Input.is_action_just_pressed("jump") and player_node.is_on_floor():
		player_node.y_velocity = player_node.jump_power

	player_node.velocity.y = player_node.y_velocity
	player_node.velocity = player_node.move_and_slide(player_node.velocity, Vector3.UP)

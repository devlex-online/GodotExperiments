extends Node

export var speed : float = 20
export var acceleration : float = 15
export var air_acceleration : float = 5
export var gravity : float = 0.98
export var max_terminal_velocity : float = 54
export var jump_power : float = 20
export(NodePath) var player_node_path  

export var turnSmoothTime : float = 0.1

var velocity : Vector3
var y_velocity : float
var player_node : KinematicBody
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
	
	var accel = acceleration if player_node.is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)

	if player_node.is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)

	if Input.is_action_just_pressed("jump") and player_node.is_on_floor():
		y_velocity = jump_power

	velocity.y = y_velocity
	velocity = player_node.move_and_slide(velocity, Vector3.UP)

extends KinematicBody2D

var speed = 800
var obstacle_index = 0
puppet var puppet_pos
puppet var puppet_direction

func _ready():
	puppet_pos = position
	puppet_direction = Vector2()
	
func _physics_process(delta):
	
	var direction = Vector2()
	if is_network_master():
		if Input.is_action_pressed("move_up"):
			direction.y -= 1
		if Input.is_action_pressed("move_down"):
			direction.y += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_just_pressed("placeObstacle"):
			obstacle_index += 1
			var obstacle_name = get_name() + str(obstacle_index)
			var obstacle_pos = position + Vector2(0, 128)
			rpc("setup_obstacle", obstacle_name, obstacle_pos)
			
		direction = direction.normalized()
		
		rset("puppet_direction", direction)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		direction = puppet_direction
	
	move_and_slide(direction * speed)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

# Use sync because it will be called everywhere
sync func setup_obstacle(obstacle_name, pos):
	var obstacle = preload("res://game/PlacableObstacle.tscn").instance()
	obstacle.set_name(obstacle_name) 
	obstacle.position = pos
	
	get_node("..").add_child(obstacle)

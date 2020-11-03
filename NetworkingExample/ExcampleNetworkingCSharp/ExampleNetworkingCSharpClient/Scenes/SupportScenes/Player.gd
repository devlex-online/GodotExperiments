extends KinematicBody2D

var speed = 800
var obstacle_index = 0

	
func _physics_process(delta):
	
	var direction = Vector2()
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_just_pressed("placeObstacle"):
		Server.FetchDamage(get_instance_id())
		#obstacle_index += 1
		#var obstacle_name = get_name() + str(obstacle_index)
		#var obstacle_pos = position + Vector2(0, 128)
		
	direction = direction.normalized()
	
	
	move_and_slide(direction * speed)
func set_damage(damage):
	print("doing damage: " + str(damage))
# Use sync because it will be called everywhere
sync func setup_obstacle(obstacle_name, pos):
	var obstacle = preload("res://Scenes/SupportScenes/PlacableObstacle.tscn").instance()
	obstacle.set_name(obstacle_name) 
	obstacle.position = pos
	
	get_node("..").add_child(obstacle)

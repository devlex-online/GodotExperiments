extends KinematicBody2D

var speed : = 400.0
var path : = PoolVector2Array() setget set_path
onready var nav_2d : Navigation2D = get_node("/root/World/Navigation2D")
var target = null

puppet var puppet_pos
puppet var puppet_velocity


func _ready():
	puppet_pos = position
	puppet_velocity = Vector2()
	
	
func _process(delta : float):
	
	var velocity = Vector2()
	if is_network_master():
		var sprite : Sprite = $Sprite
		sprite.modulate = Color.black
		if target != null :
			path = nav_2d.get_simple_path(global_position, target.global_position)
			var move_distance : = speed * delta
			velocity = move_along_path(move_distance)
			
			rset("puppet_velocity", velocity)
			rset("puppet_pos", position)
	else:
		position = puppet_pos
		velocity = puppet_velocity
	
	move_and_slide(velocity * speed)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

master func move_along_path(distance : float):
	var starting_point : = position
	for i in range(path.size()):
		var distance_to_next : = starting_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			var velocity = position.direction_to(starting_point.linear_interpolate(path[0], distance / distance_to_next))
			return velocity
		elif distance < 0.0:
			var velocity = position.direction_to(path[0])
			return velocity
		distance -= distance_to_next
		starting_point = path[0]
		path.remove(0)
	return Vector2()
	
master func set_path(value : PoolVector2Array) -> void :
	path = value
	if value.size() == 0:
		return
	
master func _on_Area2D_body_entered(body):
	target = body
	

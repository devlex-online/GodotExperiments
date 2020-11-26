extends Node

class_name random_movement_controller

export var kinematic_body_node_path : NodePath

onready var kinematic_body : KinematicBody2D = get_node(kinematic_body_node_path)

var rng : RandomNumberGenerator

var velocity : Vector2

var target : Vector2

var has_target : bool

func get_target() -> Vector2:
	return target
	
func set_target(value : Vector2):
	target = value
	has_target = value != null

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
#	velocity = new_velocity()

func _physics_process(delta):
	print("has target " + String(has_target) + " - velocity " + String(velocity) + " - target " + String(get_target()))
	if has_target:
		velocity = get_velocity_to_target()
		print("velo to target: " + String(velocity))
		
	var collision = kinematic_body.move_and_collide(velocity * delta)
	if collision != null:
		velocity = new_velocity()
		print("velo after collsion " + String(velocity))
		
	
func get_velocity_to_target() -> Vector2:
	if has_target:
		var parent : Node2D = get_parent()
		return parent.position.direction_to(get_target()).normalized() * 100.0
	else:
		return new_velocity()

func new_velocity() -> Vector2:
	var new_velocity = Vector2(rng.randf(), rng.randf()).normalized()
	if rng.randi_range(1,100) > 50:
		new_velocity.x =  new_velocity.x *-1
	if rng.randi_range(1,100) > 50:
		new_velocity.y =  new_velocity.y *-1
	new_velocity = new_velocity * 100.0
	return new_velocity

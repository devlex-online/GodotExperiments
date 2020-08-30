extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move = Vector3()
	if Input.is_key_pressed(KEY_W):
		move += Vector3(0,0,-1)
	if Input.is_key_pressed(KEY_S):
		move += Vector3(0,0,1)
	if Input.is_key_pressed(KEY_A):
		move += Vector3(-1,0,0)
	if Input.is_key_pressed(KEY_D):
		move += Vector3(1,0,0)
	move_and_slide(move * 400 * delta)
	

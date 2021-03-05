extends Spatial

export(float, 0.1, 1) var mouse_sensitivity : float = 0.1
export(float, -90, 0) var min_pitch : float = -90
export(float, 0, 90) var max_pitch : float = 90
export(bool) var freelook = false

onready var y_rotation_camera_before_freelook = rotation_degrees.y
onready var y_rotation_player_before_freelook = get_parent().rotation_degrees.y



func _input(event):
	if event is InputEventMouseMotion:
		if not freelook:
			if get_parent().rotation_degrees.y != y_rotation_player_before_freelook:
				get_parent().rotation_degrees.y = y_rotation_player_before_freelook 
			if rotation_degrees.y != y_rotation_camera_before_freelook:
				rotation_degrees.y = y_rotation_camera_before_freelook
			get_parent().rotate_y(-(event.relative.x * mouse_sensitivity))
			y_rotation_player_before_freelook = get_parent().rotation_degrees.y
			y_rotation_camera_before_freelook = rotation_degrees.y
		else:
			rotate_y(-(event.relative.x * mouse_sensitivity))
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)

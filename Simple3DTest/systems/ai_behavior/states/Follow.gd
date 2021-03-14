class_name Follow
extends EntityState

var target: Spatial
# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
		entity.velocity = (target.transform.origin - entity.transform.origin) * entity.speed * _delta
		entity.look_at(target.transform.origin, Vector3.UP)
		entity.velocity = entity.move_and_slide(entity.velocity)
		

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	target = _msg['target']


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass

# Boilerplate class to get full autocompletion and type checks for the `entity` when coding the entity's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name EntityState
extends StateBaseClass


# Typed reference to the entity node.
var entity: Entity


func _ready() -> void:
	# The states are children of the `Entity` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `Entity` type.
	# If the `owner` is not a `Entity`, we'll get `null`.
	entity = owner as Entity
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `Entity.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(entity != null)

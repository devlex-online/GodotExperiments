class_name Seek
extends EntityState


export(NodePath) var SearchAreaPath
export(NodePath) var NextStatePath

var next_state : EntityState
var search_area : Area
var player_in_range : Player
# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if player_in_range:
		state_machine.transition_to(next_state.name, {'target': player_in_range})
	


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	
	search_area = get_node(SearchAreaPath)
	search_area.connect("body_entered", self, "on_search_area_body_entered")
	if not next_state:
		next_state = get_node(NextStatePath)


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	search_area.disconnect("body_entered", self, "on_search_area_body_entered")
	search_area = null
	
	pass

func on_search_area_body_entered(body):
	if body is Player:
		player_in_range = body
		

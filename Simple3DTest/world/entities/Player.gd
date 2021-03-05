extends KinematicBody
class_name Player

var isReady = false
func _ready():
	DevlexInventoryManager.register_inventory(get_node("DevlexInventory"))
	isReady = true

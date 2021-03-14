class_name Player
extends Entity


var isReady = false
func _ready():
	DevlexInventoryManager.register_inventory(get_node("DevlexInventory"))
	isReady = true

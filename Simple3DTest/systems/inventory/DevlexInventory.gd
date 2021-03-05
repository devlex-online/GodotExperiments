extends Node
class_name DevlexInventory

export(bool) var persist_inventory = true
export var inventory_persistence_path = "user://player_inventory.tres"
export var inventory_resource_path = "res://systems/inventory/DevlexInventoryResource.gd"
var inventory_resource = load(inventory_resource_path)
var inventory = inventory_resource.new()

func _ready():
	inventory.inventory_instance = self

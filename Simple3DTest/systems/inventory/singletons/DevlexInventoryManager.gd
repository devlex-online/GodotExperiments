extends Node

var inventories = Array()

func register_inventory(inventory: DevlexInventory):
	inventory.inventory.connect("inventory_changed", self, "on_player_inventory_changed")
	
	if inventory.persist_inventory:
		var existing_inventory = load(inventory.inventory_persistence_path)
		if existing_inventory:
			inventory.inventory.set_items(existing_inventory.get_items())

	
func on_player_inventory_changed(inventory: DevlexInventory):
	if inventory.persist_inventory:
		ResourceSaver.save(inventory.inventory_persistence_path, inventory.inventory)

extends GridContainer

func _ready():
	GameManager.connect("player_initialised", self, "on_player_initialised")
	
func on_player_initialised(player):
	var inventory = player.get_node("DevlexInventory")
	on_player_inventory_changed(inventory)
	inventory.inventory.connect("inventory_changed", self, "on_player_inventory_changed")

func on_player_inventory_changed(inventory : DevlexInventory):
	for n in get_children():
		n.queue_free()
	for item in inventory.inventory.get_items():
		var item_label = Label.new()
		item_label.text = "%s x%d" % [item.item_reference.name, item.quantity]
		add_child(item_label)

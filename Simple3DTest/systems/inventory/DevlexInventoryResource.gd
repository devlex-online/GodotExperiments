class_name DevlexInventoryResource
extends Resource


signal inventory_changed

var inventory_instance
export var _items = Array() setget set_items, get_items

func set_items(new_items):
	_items = new_items
	emit_signal("inventory_changed", inventory_instance)
	
func get_items():
	return _items
	
func get_item(index):
	return _items[index]

func add_item(item_id: int, quantity: int):
	if quantity <= 0:
		print("Can't at negative number of items")
		return
	
	var item = DevlexItemDatabase.get_item(item_id)
	if not item:
		print("Item not found")
		return
	
	var remaining_quanitity = quantity
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	if item.stackable:
		for i in range(_items.size()):
			if remaining_quanitity == 0:
				break
			var inventory_item: DevlexInventoryItem 
			inventory_item = _items[i]
			if inventory_item.item_reference.name != item.name:
				continue
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quanitity, max_stack_size)
				remaining_quanitity -= inventory_item.quantity - original_quantity
	while remaining_quanitity > 0:
		var new_item : DevlexInventoryItem = DevlexInventoryItem.new()
		new_item.item_reference = item
		new_item.quantity = min(remaining_quanitity, max_stack_size) 
		
		_items.append(new_item)
		remaining_quanitity -= new_item.quantity
	emit_signal("inventory_changed", inventory_instance)

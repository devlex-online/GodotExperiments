extends Spatial

func _on_PickUpArea_body_entered(body):
	if body is Player:
		body.get_node("DevlexInventory").inventory.add_item(0, 1)
		queue_free()

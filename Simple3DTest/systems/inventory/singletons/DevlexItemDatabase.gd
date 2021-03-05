extends Node

var items = {}

export var item_dir = "res://items"

func _ready():
	var directory = Directory.new()
	directory.open(item_dir)
	directory.list_dir_begin()
	var file = directory.get_next()
	while(file):
		if not directory.current_is_dir():
			var item_res : DevlexItemResource = load("%s/%s" %[item_dir , file])
			items[item_res.id] = item_res
		file = directory.get_next()

func get_item(item_id):
	return items.get(item_id)

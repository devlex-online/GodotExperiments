extends TileMap

class_name ExtendedTileMap

func get_used_cells_by_tile_names(tile_names: PoolStringArray) -> Array:
	var used_tiles = []
	for tile_name in tile_names:
		var temp_used_tiles = get_used_cells_by_id(tile_set.find_tile_by_name(tile_name))
		for temp_used_tile in temp_used_tiles:
			used_tiles.append(temp_used_tile)
	return used_tiles;

func add_node_to_tiles(path_to_added_scene: String, tile_names: PoolStringArray, auto_tile_coordinate_vectors: PoolVector2Array):
	var scene_to_add : PackedScene = load(path_to_added_scene)
	var used_plant_tiles = get_used_cells_by_tile_names(tile_names)
	for tile_vector_in_grid in used_plant_tiles:
		for auto_tile_coordinate_vector in auto_tile_coordinate_vectors:
			var converted_to_int_vector = Vector2(int(auto_tile_coordinate_vector.x), int(auto_tile_coordinate_vector.y))
			if converted_to_int_vector == get_cell_autotile_coord(int(tile_vector_in_grid.x), int(tile_vector_in_grid.y)):
				var plant_instance : Area2D = scene_to_add.instance()
				plant_instance.position = map_to_world(tile_vector_in_grid)
				add_child(plant_instance)

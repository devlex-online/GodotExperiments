extends ExtendedTileMap

export var tile_names: PoolStringArray
export var auto_tile_coordinate_vectors: PoolVector2Array
export var path_to_added_scene: String

func _ready():
	add_node_to_tiles(path_to_added_scene, tile_names, auto_tile_coordinate_vectors)

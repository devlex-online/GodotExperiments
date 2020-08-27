extends ColorRect


onready var _tilemap = $TileMap
onready var _gridtilemap = get_node("/root/MainScene/TileMap")

func _process(delta):
	var grid = _gridtilemap.grid
	for x in _gridtilemap.grid_size.x:
		for y in _gridtilemap.grid_size.y:
			_tilemap.set_cell(x,y,grid[x][y])
				
	_tilemap.update_bitmask_region(Vector2(0,0), _gridtilemap.grid_size)

extends TileMap

var tile_size = cell_size
var half_tile_size = tile_size / 2

var grid_size = Vector2(16,16)
var grid = []

var tiles = []

func _ready():
	tiles.append(tile_set.find_tile_by_name("grass"))
	tiles.append(tile_set.find_tile_by_name("water"))
	tiles.append(tile_set.find_tile_by_name("sand"))
	tiles.append(tile_set.find_tile_by_name("stone"))
	
	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			grid[x].append(null)
			set_cell(x,y,tiles[randi()  % tiles.size()])
			
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends TileMap

var tile_size = cell_size
var half_tile_size = tile_size / 2
var tilemap_size = Vector2(128,128)

var grid_size = Vector2(128,128)
var grid = []

var tiles = []
var mapGenActive: bool = false

func _ready():
	randomize()
	tiles.append(tile_set.find_tile_by_name("grass"))
	tiles.append(tile_set.find_tile_by_name("water"))
	tiles.append(tile_set.find_tile_by_name("sand"))
	tiles.append(tile_set.find_tile_by_name("stone"))
	_generateMap()
	_drawMap()

			
func _generateMap():
	mapGenActive = true
	grid.clear()
	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			if rand_range(0,100) < 55:
				grid[x].append(4) #DummyAutoTile
			else:
				grid[x].append(1) #WaterTile
	mapGenActive = false
func _smoothGeneratedMap():
	mapGenActive = true
	var neighborCells = [Vector2(1,0), Vector2(-1,0), 
						Vector2(0,1), Vector2(0,-1),
						Vector2(1,1), Vector2(-1,1), Vector2(1,-1), Vector2(-1,-1)]
	for x in grid_size.x - 1:
		for y in grid_size.y - 1:
			var WaterNeighborhoodSize = 0
			for neighborPos in neighborCells:
				var neighborVector = Vector2(x,y) + neighborPos
				var neighborCell = grid[neighborVector.x][neighborVector.y]
				if neighborCell == 1:
					WaterNeighborhoodSize += 1
			if(WaterNeighborhoodSize > 4):
				grid[x][y] = 1
			elif(WaterNeighborhoodSize < 4):
				grid[x][y] = 4
	mapGenActive = false
func _drawMap():
	for x in tilemap_size.x:
		for y in tilemap_size.y:
			set_cell(x,y,grid[x][y])
				
	update_bitmask_region(Vector2(0,0), tilemap_size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not mapGenActive:
		if Input.is_key_pressed(KEY_SPACE):
			_smoothGeneratedMap()
			_drawMap()
			
		if Input.is_key_pressed(KEY_R):
			_generateMap()
			_drawMap()

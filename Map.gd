extends TileMap

enum DrawLayers {TERRAIN, FOLLIAGE, EFFECTS}
enum AutotilerLayers {GROUND, CLIFFS, FOLLIAGE_GREEN, FOLLIAGE_YELLOW}


func _ready():
	var map_shape = Constants.MAP_SHAPE
	
	# center map
	var viewport_center = get_viewport().size / 2
	viewport_center -= (map_shape * tile_set.tile_size) / 2
	position = viewport_center - Vector2i(0, rendering_quadrant_size/2)
	
	# set background of map
	for col in range(map_shape.x):
		for row in range(map_shape.y):
			var map_cell = Vector2i(col, row)
			BetterTerrain.set_cell(self, DrawLayers.TERRAIN, map_cell, AutotilerLayers.GROUND)
			BetterTerrain.update_terrain_cell(self, DrawLayers.TERRAIN, map_cell)
	
	# set map cliffs
	for col in map_shape.x:
		BetterTerrain.set_cell(self, DrawLayers.TERRAIN, Vector2i(col, map_shape.y), AutotilerLayers.CLIFFS)
		BetterTerrain.update_terrain_cell(self, DrawLayers.TERRAIN, Vector2i(col, map_shape.y))
	
	# set folliage of map
	for col in map_shape.x:
		for row in map_shape.y:
			var map_cell = Vector2i(col, row)
			BetterTerrain.set_cell(self, DrawLayers.FOLLIAGE, map_cell, AutotilerLayers.FOLLIAGE_GREEN)
			BetterTerrain.update_terrain_cell(self, DrawLayers.FOLLIAGE, map_cell)

func map_to_global(cell):
	var cell_local_position = map_to_local(cell)
	return to_global(cell_local_position)

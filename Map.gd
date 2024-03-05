extends TileMap

enum DrawLayers {TERRAIN, FOLIAGE, EFFECTS}
enum AutotilerLayers {GROUND, CLIFFS, FOLIAGE_GREEN, FOLIAGE_YELLOW}
enum TileSources {TERRAIN, EFFECTS}
enum HighlightColors {MOVE, ATTACK, ORIGIN}

var highlighted_cells = []


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
			GameState.add_interactable_cell(map_cell)
	
	# set map cliffs
	for col in map_shape.x:
		BetterTerrain.set_cell(self, DrawLayers.TERRAIN, Vector2i(col, map_shape.y), AutotilerLayers.CLIFFS)
		BetterTerrain.update_terrain_cell(self, DrawLayers.TERRAIN, Vector2i(col, map_shape.y))
	
	# set folliage of map
	for col in map_shape.x:
		for row in map_shape.y:
			var map_cell = Vector2i(col, row)
			BetterTerrain.set_cell(self, DrawLayers.FOLIAGE, map_cell, AutotilerLayers.FOLIAGE_GREEN)
			BetterTerrain.update_terrain_cell(self, DrawLayers.FOLIAGE, map_cell)

func global_to_map(target_position):
	return local_to_map(to_local(target_position))

func map_to_global(cell):
	var cell_local_position = map_to_local(cell)
	return to_global(cell_local_position)

func highlight_cells(cells, color=HighlightColors.MOVE):
	for cell in cells:
		set_cell(DrawLayers.EFFECTS, cell, TileSources.EFFECTS, Vector2.ZERO, color)
		highlighted_cells.append(cell)

func clear_all_highlighted_cells():
	for cell in highlighted_cells:
		erase_cell(DrawLayers.EFFECTS, cell)
	highlighted_cells = []

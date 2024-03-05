extends Node

enum MOVE_TYPES {CELL, SLIDE}
const MAP_SHAPE = Vector2i(8, 8)
var MAP_CELLS_META = {}

var UNITS = {
	"pawn": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadPawn.png")
		}
	},
	"rook": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadRook.png")
		}
	},
	"knight": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadKnight.png")
		}
	},
	"bishop": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadBishop.png")
		}
	},
	"king": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadKing.png")
		}
	},
	"queen": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadQueen.png")
		}
	}
}

var PALETTES = {
	"red": {
		"new_main_color": Color("#b25455"),
		"new_shadow_color": Color("#653b59"),
		"new_light_color": Color("#b65555")
	},
	"blue": {
		"new_main_color": Color("#3e8698"),
		"new_shadow_color": Color("#404e75"),
		"new_light_color": Color("#5ab3ac")
	},
	"yellow": {
		"new_main_color": Color("#bbaf45"),
		"new_shadow_color": Color("#6c5847"),
		"new_light_color": Color("#dcdf71")
	},
	"purple": {
		"new_main_color": Color("#785397"),
		"new_shadow_color": Color("#313049"),
		"new_light_color": Color("#a8719a")
	}
}

var DEFAULT_PALETTE = {
	"old_main_color": Color("#3e8698"),
	"old_shadow_color": Color("#404e75"),
	"old_light_color": Color("#5ab3ac")
}

func _ready():
	_init_map_cells_meta()

func _init_map_cells_meta():
	for col in MAP_SHAPE.x:
		for row in MAP_SHAPE.y:
			var cells_north = row
			var cells_south = (MAP_SHAPE.y - 1) - row
			var cells_west = col
			var cells_east = (MAP_SHAPE.x - 1) - col
			
			var cell_index = row * MAP_SHAPE.y + col
			
			MAP_CELLS_META[Vector2i(col, row)] = {
				"idx": cell_index,
				"cells_util_edge": {
					Vector2i.UP: cells_north,
					Vector2i.DOWN: cells_south,
					Vector2i.LEFT: cells_west,
					Vector2i.RIGHT: cells_east,
					Vector2i.UP + Vector2i.LEFT: min(cells_north, cells_west), # first half diag 1
					Vector2i.DOWN + Vector2i.RIGHT: min(cells_south, cells_east), # second half diag 1
					Vector2i.UP + Vector2i.RIGHT: min(cells_north, cells_east), # first half diag 2
					Vector2i.DOWN + Vector2i.LEFT: min(cells_south, cells_west)  # second half diag 2
				}
			}

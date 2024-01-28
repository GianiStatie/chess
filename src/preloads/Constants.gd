extends Node

enum MOVE_TYPES {CELL, SLIDE}
const MAP_SHAPE = Vector2i(8, 8)
var MAP_CELLS_META = {}

var UNITS = {
	"pawn": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadPawn.png")
		},
		"move_type": MOVE_TYPES.CELL,
		"move_directions": [],
		"move_directions_special": [
			"Vector2i(0, -1) if {unit}.unit_side == 'blue' else null",
			"Vector2i(0, 1) if not {unit}.unit_side != 'blue' else null",
			"Vector2i(0, -2) if not {unit}.has_moved and {unit}.unit_side == 'blue' else null",
			"Vector2i(0, 2) if not {unit}.has_moved and {unit}.unit_side != 'blue' else null",
		],
		"attack_directions": [
			Vector2i(-1, -1),
			Vector2i(1, -1)
		]
	},
	"rook": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadRook.png")
		},
		"move_type": MOVE_TYPES.SLIDE,
		"move_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT
		],
		"move_directions_special": [],
		"attack_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT
		]
	},
	"knight": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadKnight.png")
		},
		"move_type": MOVE_TYPES.CELL,
		"move_directions": [
			Vector2i(1, -2),
			Vector2i(2, -1),
			Vector2i(2, 1),
			Vector2i(1, 2),
			Vector2i(-1, 2),
			Vector2i(-2, 1),
			Vector2i(-2, -1),
			Vector2i(-1, -2),
		],
		"move_directions_special": [],
		"attack_directions": [
			Vector2i(1, -2),
			Vector2i(2, -1),
			Vector2i(2, 1),
			Vector2i(1, 2),
			Vector2i(-1, 2),
			Vector2i(-2, 1),
			Vector2i(-2, -1),
			Vector2i(-1, -2),
		]
	},
	"bishop": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadBishop.png")
		},
		"move_type": MOVE_TYPES.SLIDE,
		"move_directions": [
			Vector2i(1, 1),
			Vector2i(1, -1),
			Vector2i(-1, 1),
			Vector2i(-1, -1)
		],
		"move_directions_special": [],
		"attack_directions": [
			Vector2i(1, 1),
			Vector2i(1, -1),
			Vector2i(-1, 1),
			Vector2i(-1, -1)
		]
	},
	"king": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadKing.png")
		},
		"move_type": MOVE_TYPES.CELL,
		"move_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT,
			Vector2i(1, 1),
			Vector2i(1, -1),
			Vector2i(-1, 1),
			Vector2i(-1, -1)
		],
		"move_directions_special": [],
		"attack_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT,
			Vector2i(1, 1),
			Vector2i(1, -1),
			Vector2i(-1, 1),
			Vector2i(-1, -1)
		]
	},
	"queen": {
		"sprites": {
			"head": preload("res://assets/units/components/Head/HeadQueen.png")
		},
		"move_type": MOVE_TYPES.SLIDE,
		"move_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT,
			Vector2i(1, 1),
			Vector2i(1, -1),
			Vector2i(-1, 1),
			Vector2i(-1, -1)
		],
		"move_directions_special": [],
		"attack_directions": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.LEFT,
			Vector2i.RIGHT,
			Vector2i(1, 1),
			Vector2i(1, -1),
			Vector2i(-1, 1),
			Vector2i(-1, -1)
		]
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
					Vector2i(-1, -1): min(cells_north, cells_west), # first half diag 1
					Vector2i(1, 1): min(cells_south, cells_east), # second half diag 1
					Vector2i(1, -1): min(cells_north, cells_east), # first half diag 2
					Vector2i(-1, 1): min(cells_south, cells_west)  # second half diag 2
				}
			}

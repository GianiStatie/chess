extends Node

const MAP_SHAPE = Vector2i(8, 8)

var PIECES = {
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

var PALETTS = {
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

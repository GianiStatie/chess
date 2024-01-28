extends Node2D

@onready var sprites = $Sprites

var unit_type = "pawn"
var unit_side = "blue"

func init(unit_info):
	unit_type = unit_info["unit_type"]
	unit_side = unit_info["unit_side"]

func _ready():
	sprites.update_sprites(
		Constants.UNITS[unit_type]["sprites"],
		Constants.PALETTES[unit_side]
	)

extends Node2D

@onready var sprites = $Sprites

var piece_type = "pawn"
var piece_side = "blue"

func init(piece_info):
	piece_type = piece_info["piece_type"]
	piece_side = piece_info["piece_side"]

func _ready():
	sprites.update_sprites(
		Constants.PIECES[piece_type]["sprites"],
		Constants.PALETTS[piece_side]
	)

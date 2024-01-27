extends Node2D

@onready var PieceScene = preload("res://src/pieces/piece.tscn")

@export var map: TileMap


func init_board():
	var row = 0
	var column = 0
	for slice in GameState.start_FEN.split('/'):
		for element in slice:
			if element.is_valid_int():
				column += int(element)
			else:
				var piece_info = get_piece_info_from_symbol(element)
				var map_cell = Vector2i(column, row)
				create_piece_at_cell(piece_info, map_cell)
			column += 1
		row += 1
		column = 0

func create_piece_at_cell(piece_info, map_cell):
	var piece_global_position = map.map_to_global(map_cell)
	var piece = PieceScene.instantiate()
	piece.init(piece_info)
	piece.global_position = piece_global_position
	add_child(piece)

func get_piece_info_from_symbol(symbol: String):
	var piece_type = null
	match symbol.to_lower():
		"p": piece_type = "pawn"
		"n": piece_type = "knight"
		"r": piece_type = "rook"
		"b": piece_type = "bishop"
		"q": piece_type = "queen"
		"k": piece_type = "king"
	var piece_side = "red" if symbol.capitalize() == symbol else "blue"
	var piece_info = {
		"piece_type": piece_type,
		"piece_side": piece_side
	}
	return piece_info

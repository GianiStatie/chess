extends Node2D

@onready var UnitScene = preload("res://src/units/unit.tscn")
@export var map: TileMap

signal setup_ready


func init_board():
	var row = 0
	var column = 0
	for slice in GameState.start_FEN.split('/'):
		for element in slice:
			if element.is_valid_int():
				column += int(element)
				continue
			else:
				var unit_info = get_unit_info_from_symbol(element)
				var map_cell = Vector2i(column, row)
				create_unit_at_cell(unit_info, map_cell)
			column += 1
		row += 1
		column = 0
	emit_signal("setup_ready")

func create_unit_at_cell(unit_info, map_cell):
	var unit_global_position = map.map_to_global(map_cell)
	var unit = UnitScene.instantiate()
	unit.init(unit_info)
	unit.global_position = unit_global_position
	unit.connect("was_selected", _on_Unit_was_selected)
	unit.connect("was_unselected", _on_Unit_was_unselected)
	GameState.set_cell_occupied(unit, map_cell)
	add_child(unit)

func get_unit_info_from_symbol(symbol: String):
	var unit_type = null
	match symbol.to_lower():
		"p": unit_type = "pawn"
		"n": unit_type = "knight"
		"r": unit_type = "rook"
		"b": unit_type = "bishop"
		"q": unit_type = "queen"
		"k": unit_type = "king"
	var unit_side = "blue" if symbol.capitalize() == symbol else "red"
	var unit_info = {
		"unit_type": unit_type,
		"unit_side": unit_side
	}
	return unit_info

func _on_Unit_was_selected(unit):
	var moves = GameEngine.get_moves(unit)
	map.highlight_cells(moves["move"], map.HighlightColors.MOVE)
	map.highlight_cells(moves["attack"], map.HighlightColors.ATTACK)

func _on_Unit_was_unselected(unit):
	var placement_position = get_global_mouse_position()
	var placement_cell = map.global_to_map(placement_position)
	if placement_cell in map.highlighted_cells:
		var unit_return_cell = map.global_to_map(unit.return_position)
		unit.has_moved = true
		unit.global_position = map.map_to_global(placement_cell)
		var captured_unit = GameState.get_unit_at_cell(placement_cell)
		if captured_unit != null:
			captured_unit.queue_free()
		GameState.clear_cell(unit_return_cell)
		GameState.set_cell_occupied(unit, placement_cell)
	map.clear_all_highlighted_cells()

extends Node2D

@onready var UnitScene = preload("res://src/units/unit.tscn")

@export var map: TileMap

signal unit_spawned_at_cell(unit, cell)
signal setup_ready


func _ready():
	connect("unit_spawned_at_cell", GameState._on_unit_spawned_at_cell)
	connect("setup_ready", GameState._on_UnitManager_setup_ready)

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
	add_child(unit)
	emit_signal("unit_spawned_at_cell", unit, map_cell)

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
	GameState.selected_unit = unit
	var move_cells = GameState.get_movement(unit)
	var attack_cells = GameState.get_attack(unit)
	var unit_cell = GameState.get_unit_cell(unit)
	map.highlight_cells(move_cells, map.HighlightColors.MOVE)
	map.highlight_cells(attack_cells, map.HighlightColors.ATTACK)
	map.highlight_cells([unit_cell], map.HighlightColors.ORIGIN)

func _on_Unit_was_unselected(unit):
	GameState.selected_unit = null
	map.clear_all_highlighted_cells()

extends Node

var start_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
#var start_FEN = "8/8/8/8/8/4p3/3p4/2PQKNBR"
var interactable_cells = []
var occupied_cells = {}


func add_interactable_cell(map_cell):
	interactable_cells.append(map_cell)

func set_cell_occupied(unit, map_cell):
	occupied_cells[map_cell] = unit

func clear_cell(map_cell):
	occupied_cells.erase(map_cell)

func get_unit_at_cell(map_cell):
	return occupied_cells.get(map_cell)

func is_valid_cell(map_cell):
	return map_cell in interactable_cells

func is_cell_occupied(map_cell):
	return occupied_cells.get(map_cell, null) != null

func is_enemy_at_cell(map_cell, unit_side):
	var unit = occupied_cells.get(map_cell, null)
	if unit == null or unit.unit_side == unit_side:
		return false
	return true

func is_valid_move(map_cell):
	return is_valid_cell(map_cell) and not is_cell_occupied(map_cell)

func is_valid_attack(map_cell, unit_side):
	return is_valid_cell(map_cell) and is_enemy_at_cell(map_cell, unit_side)

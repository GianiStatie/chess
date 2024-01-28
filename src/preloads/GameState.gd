extends Node

#var start_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
var start_FEN = "r5r/8/8/8/8/8/8/R5R"

var map_setup_ready = false

var units_to_cell = {}
var cell_to_unit = {}
var units_movement_cells = {}
var units_attack_cells = {}


func _on_unit_spawned_at_cell(unit, cell):
	units_to_cell[unit] = cell
	cell_to_unit[cell] = unit

func _on_unit_removed_from_cell(unit):
	cell_to_unit.erase(units_to_cell[unit])
	units_to_cell.erase(unit)

func _on_UnitManager_setup_ready():
	map_setup_ready = true
	update_move_cells()

func update_move_cells():
	for unit in units_to_cell:
		var move_type = Constants.UNITS[unit.unit_type]["move_type"]
		
		if move_type == Constants.MOVE_TYPES.SLIDE:
			var unit_move_cells = generate_sliding_moves(unit)
			units_movement_cells[unit] = unit_move_cells

func generate_sliding_moves(unit):
	var unit_cell = units_to_cell[unit]
	var move_direction = Constants.UNITS[unit.unit_type]["move_directions"]
	var map_cells_util_edge = Constants.MAP_CELLS_META[unit_cell]["cells_util_edge"]
	
	var valid_move_cells = []
	for direction in move_direction:
		for direction_scale in range(map_cells_util_edge[direction]):
			var move_cell = unit_cell + direction * (direction_scale + 1)
			var unit_on_move_cell = cell_to_unit.get(move_cell)
			
			if unit_on_move_cell != null:
				break
			
			valid_move_cells.append(move_cell)
	return valid_move_cells

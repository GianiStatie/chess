extends Node

var start_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
#var start_FEN = "pp4pp/Pq4qP/8/8/8/8/p6p/BR4RB"

var map_setup_ready = false

var units_to_cell = {}
var cell_to_unit = {}
var units_movement_cells = {}
var units_attack_cells = {}

var selected_unit = null: set = set_selected_unit


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
		
		var unit_actions = {"move": [], "attack": []}
		if move_type == Constants.MOVE_TYPES.SLIDE:
			unit_actions = generate_sliding_actions(unit)
		elif move_type == Constants.MOVE_TYPES.CELL:
			unit_actions = generate_cell_actions(unit)
		units_movement_cells[unit] = unit_actions["move"]
		units_attack_cells[unit] = unit_actions["attack"]

func generate_sliding_actions(unit: Unit):
	var unit_cell = units_to_cell[unit]
	var move_directions = Constants.UNITS[unit.unit_type]["move_directions"]
	var map_cells_util_edge = Constants.MAP_CELLS_META[unit_cell]["cells_util_edge"]
	
	var valid_move_cells = []
	var valid_attack_cells = []
	for direction in move_directions:
		for direction_scale in range(map_cells_util_edge[direction]):
			var move_cell = unit_cell + direction * (direction_scale + 1)
			var unit_on_move_cell = cell_to_unit.get(move_cell)
			
			if unit_on_move_cell != null:
				if unit.unit_side != unit_on_move_cell.unit_side:
					valid_attack_cells.append(move_cell)
				break
			
			valid_move_cells.append(move_cell)
	return {"move": valid_move_cells, "attack": valid_attack_cells}

func generate_cell_actions(unit: Unit):
	var unit_cell = units_to_cell[unit]
	
	var valid_move_cells = []
	var move_directions = Constants.UNITS[unit.unit_type]["move_directions"]
	for direction in move_directions:
		var move_cell = unit_cell + direction
		var unit_on_move_cell = cell_to_unit.get(move_cell)
		
		if not is_valid_cell(move_cell) or unit_on_move_cell != null:
			continue
		
		valid_move_cells.append(move_cell)
	
	var move_directions_special = Constants.UNITS[unit.unit_type]["move_directions_special"]
	for direction_logic in move_directions_special:
		var direction = str_to_var(direction_logic.format({"unit": unit}))
		if direction == null:
			continue
			
		var move_cell = unit_cell + direction
		var unit_on_move_cell = cell_to_unit.get(move_cell)
		
		if not is_valid_cell(move_cell) or unit_on_move_cell != null:
			continue
		
		valid_move_cells.append(move_cell)
	
	var valid_attack_cells = []
	var attack_directions = Constants.UNITS[unit.unit_type]["attack_directions"]
	for direction in attack_directions:
		var attack_cell = unit_cell + direction
		var unit_on_attack_cell = cell_to_unit.get(attack_cell)
		
		if not is_valid_cell(attack_cell) or unit_on_attack_cell == null:
			continue
		
		if unit.unit_side == unit_on_attack_cell.unit_side:
			continue
		
		valid_attack_cells.append(attack_cell)
	
	return {"move": valid_move_cells, "attack": valid_attack_cells}

func is_valid_cell(cell):
	return cell in Constants.MAP_CELLS_META

func get_movement(unit):
	return units_movement_cells[unit]

func get_attack(unit):
	return units_attack_cells[unit]

func get_unit_cell(unit):
	return units_to_cell[unit]

func set_selected_unit(value):
	selected_unit = value

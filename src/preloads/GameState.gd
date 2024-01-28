extends Node

var start_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

var map_setup_ready = false

var units_to_cell = {}
var cell_to_unit = {}

var units_movement_cells = {}
var units_attack_cells = {}
var attacked_cells = {"blue": [], "red": []}

var selected_unit = null: set = set_selected_unit


func _on_unit_spawned_at_cell(unit, cell):
	units_to_cell[unit] = cell
	cell_to_unit[cell] = unit

func _on_unit_removed_from_cell(unit):
	cell_to_unit.erase(units_to_cell[unit])
	units_to_cell.erase(unit)

func _on_UnitManager_setup_ready():
	map_setup_ready = true
	reset_action_cells()
	update_action_cells()

func reset_action_cells():
	units_movement_cells = {}
	units_attack_cells = {}
	attacked_cells = {"blue": [], "red": []}

func update_action_cells():
	for unit in units_to_cell:
		var move_type = Constants.UNITS[unit.unit_type]["move_type"]
		var has_special_movement = Constants.UNITS[unit.unit_type]["has_special_move"]
		var has_special_attack = Constants.UNITS[unit.unit_type]["has_special_attack"]
		
		var unit_actions = {"move": [], "attack": []}
		if move_type == Constants.MOVE_TYPES.SLIDE:
			unit_actions = generate_sliding_actions(unit)
		elif move_type == Constants.MOVE_TYPES.CELL:
			unit_actions = generate_cell_actions(unit)
		
		units_movement_cells[unit] = unit_actions["move"]
		units_attack_cells[unit] = unit_actions["attack"]
		
		if has_special_movement:
			var special_movement = generate_special_movement(unit)
			units_movement_cells[unit] += special_movement
		
		if has_special_attack:
			var special_attack = generate_special_attack(unit)
			units_attack_cells[unit] += special_attack

func generate_sliding_actions(unit: Unit):
	var unit_cell = units_to_cell[unit]
	var move_directions = Constants.UNITS[unit.unit_type]["move_directions"]
	var map_cells_util_edge = Constants.MAP_CELLS_META[unit_cell]["cells_util_edge"]
	
	var attacked_side = "red" if unit.unit_side == "blue" else "blue"
	
	var valid_move_cells = []
	var valid_attack_cells = []
	for direction in move_directions:
		for direction_scale in range(map_cells_util_edge[direction]):
			var move_cell = unit_cell + direction * (direction_scale + 1)
			attacked_cells[attacked_side].append(move_cell)
			
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
		
		if unit_on_move_cell != null or not Utils.is_valid_cell(move_cell):
			continue
		
		valid_move_cells.append(move_cell)
	
	var valid_attack_cells = []
	var attack_directions = Constants.UNITS[unit.unit_type]["attack_directions"]
	for direction in attack_directions:
		var attack_cell = unit_cell + direction
		var unit_on_attack_cell = cell_to_unit.get(attack_cell)
		
		if unit_on_attack_cell == null or not Utils.is_valid_cell(attack_cell):
			continue
		
		if unit.unit_side == unit_on_attack_cell.unit_side:
			continue
		
		valid_attack_cells.append(attack_cell)
	
	return {"move": valid_move_cells, "attack": valid_attack_cells}

func generate_special_movement(unit):
	var special_moves = []
	
	match unit.unit_type:
		"pawn":
			return Utils.get_pawn_special_moves(unit)
		"king":
			return Utils.get_king_special_moves(unit)
	
	return special_moves

func generate_special_attack(unit):
	var special_moves = []
	match unit.unit_type:
		"pawn":
			return Utils.get_pawn_special_attack(unit)
		"king":
			return Utils.get_king_special_attack(unit)
	
	return special_moves

func get_movement(unit):
	return units_movement_cells[unit]

func get_attack(unit):
	return units_attack_cells[unit]

func get_unit_cell(unit):
	return units_to_cell[unit]

func set_selected_unit(value):
	selected_unit = value

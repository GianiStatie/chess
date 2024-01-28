extends Node


func is_valid_cell(cell):
	return cell in Constants.MAP_CELLS_META

func get_pawn_special_moves(pawn_unit):
	var special_moves = []
	var unit_cell = GameState.units_to_cell[pawn_unit]
	var direction = 1 if pawn_unit.unit_side == "blue" else -1
	
	# can move first cell in front
	var move_cell = unit_cell + Vector2i.UP * direction
	var unit_on_move_cell = GameState.cell_to_unit.get(move_cell)
	if unit_on_move_cell != null or not is_valid_cell(move_cell):
		return special_moves
	special_moves.append(move_cell)
	
	# can't move two spaces in front if already moved
	if pawn_unit.has_moved:
		return special_moves
	
	# check if there is any unit in front
	move_cell = unit_cell + (Vector2i.UP * 2 * direction)
	unit_on_move_cell = GameState.cell_to_unit.get(move_cell)
	if unit_on_move_cell != null or not is_valid_cell(move_cell):
		return special_moves
	
	return special_moves + [move_cell]

func get_pawn_special_attack(pawn_unit):
	var special_moves = []
	var unit_cell = GameState.units_to_cell[pawn_unit]
	
	var directions = [Vector2i(-1, -1), Vector2i(1, -1)] if pawn_unit.unit_side == "blue" else \
					[Vector2i(-1, 1), Vector2i(1, 1)]
	
	for direction in directions:
		var move_cell = unit_cell + direction
		var unit_on_move_cell = GameState.cell_to_unit.get(move_cell)
		
		if unit_on_move_cell == null or not is_valid_cell(move_cell):
			continue
		
		if unit_on_move_cell.unit_side == pawn_unit.unit_side:
			continue
		
		special_moves.append(move_cell)
	
	# TODO: add en passant
	
	return special_moves

func get_king_special_moves(king_unit):
	var special_moves = []
	
	var unit_cell = GameState.units_to_cell[king_unit]
	var attacked_cells_this_side = GameState.attacked_cells[king_unit.unit_side]
	for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		var move_cell = unit_cell + direction
		var unit_on_move_cell = GameState.cell_to_unit.get(move_cell)
		
		# can't move is unit is in the way, it's not a valid move or move cell is attacked
		if (unit_on_move_cell != null) or (not is_valid_cell(move_cell)) or (move_cell in attacked_cells_this_side):
			continue
		special_moves.append(move_cell)
	
	# can't castle if king has moved
	if king_unit.has_moved:
		return special_moves
	
	special_moves += get_valid_castle_move(king_unit, Vector2i.LEFT, 4)
	special_moves += get_valid_castle_move(king_unit, Vector2i.RIGHT, 3)
	
	return special_moves

func get_king_special_attack(king_unit):
	var special_moves = []
	
	var unit_cell = GameState.units_to_cell[king_unit]
	var attacked_cells_this_side = GameState.attacked_cells[king_unit.unit_side]
	for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		var attack_cell = unit_cell + direction
		var unit_on_attack_cell = GameState.cell_to_unit.get(attack_cell)
		
		if unit_on_attack_cell == null or attack_cell in attacked_cells_this_side:
			continue
		
		if unit_on_attack_cell.unit_side == king_unit.unit_side:
			continue
		
		special_moves.append(attack_cell)
	return special_moves

func get_valid_castle_move(king_unit, direction, max_step):
	var unit_cell = GameState.units_to_cell[king_unit]
	var attacked_cells_this_side = GameState.attacked_cells[king_unit.unit_side]
	
	# can't castle if is in check
	if unit_cell in attacked_cells_this_side:
		return []
	
	for step in [1, 2]:
		var move_cell = unit_cell + direction * step
		var unit_on_move_cell = GameState.cell_to_unit.get(move_cell)
		
		# can't castle if units are in the way
		if unit_on_move_cell != null:
			return []
		
		# can't castle if passing through attack
		if unit_on_move_cell in attacked_cells_this_side:
			return []
	
	# can't castle if you are landing in a check
	var final_destination_cell = unit_cell + direction * 2
	if final_destination_cell in attacked_cells_this_side:
		return []
	
	var rook_cell = unit_cell + direction * max_step
	var rook_unit = GameState.cell_to_unit.get(rook_cell)
	
	# can't castle a unit that is not a rook or that has moved or is enemy piece
	if rook_unit.unit_type != "rook" or rook_unit.has_moved or rook_unit.unit_side != king_unit.unit_side:
		return []
	
	return [final_destination_cell]

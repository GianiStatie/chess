extends Node


func get_moves(unit):
	# TODO: find a better way to get unit_map_cell
	var unit_map_cell = null
	for map_cell in GameState.occupied_cells:
		var map_unit = GameState.occupied_cells[map_cell]
		if map_unit == unit:
			unit_map_cell = map_cell
			break
	match unit.unit_type:
		"pawn":
			return get_pawn_moves(unit_map_cell, unit)
		"knight":
			return get_knight_moves(unit_map_cell, unit)
		"rook":
			return get_rook_moves(unit_map_cell, unit)
		"bishop":
			return get_bishop_moves(unit_map_cell, unit)
		"queen":
			return get_queen_moves(unit_map_cell, unit)
		"king":
			return get_king_moves(unit_map_cell, unit)

func get_pawn_moves(map_cell, unit):
	var moves = {
		"move": [],
		"attack": []
	}
	var orientation = 1 if unit.unit_side == "blue" else -1
	
	# single move forward
	var move = map_cell + Vector2i.UP * orientation
	if GameState.is_valid_move(move):
		moves["move"].append(move)
	
	# double move forward if hasn't moved before
	move = map_cell + Vector2i.UP * 2 * orientation
	if GameState.is_valid_move(move) and not unit.has_moved:
		moves["move"].append(move)
	
	# diagonal attack if unit is there
	for attack_direction in [Vector2i.UP + Vector2i.LEFT, Vector2i.UP + Vector2i.RIGHT]:
		move = map_cell + attack_direction * orientation
		if GameState.is_valid_attack(move, unit.unit_side):
			moves["attack"].append(move)
	
	# TODO: en-passant if enemy pawn moved two spaces
	for attack_direction in [Vector2i.LEFT, Vector2i.RIGHT]:
		move = map_cell + attack_direction
		if GameState.is_valid_attack(move, unit.unit_side):
			var attacked_unit = GameState.get_unit_at_cell(map_cell)
			move = map_cell + attack_direction + Vector2i.UP * orientation
			if attacked_unit.en_passant and not GameState.is_cell_occupied(move):
				moves["attack"].append(move)
	
	# TODO: promotion when pawn gets at end of board
	return moves

func get_knight_moves(map_cell, unit):
	var piece_directions = [
		Vector2i.UP*2 + Vector2i.LEFT, Vector2i.UP*2 + Vector2i.RIGHT,  
		Vector2i.DOWN*2 + Vector2i.LEFT, Vector2i.DOWN*2 + Vector2i.LEFT,
		Vector2i.LEFT*2 + Vector2i.UP, Vector2i.LEFT*2 + Vector2i.DOWN,
		Vector2i.RIGHT*2 + Vector2i.UP, Vector2i.RIGHT*2 + Vector2i.DOWN,  
	]
	return get_cell_move_attack(map_cell, piece_directions, unit)

func get_rook_moves(map_cell, unit):
	var piece_directions = [
		Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT
	]
	return get_slide_move_attack(map_cell, piece_directions, unit)

func get_bishop_moves(map_cell, unit):
	var piece_directions = [
		Vector2i.UP + Vector2i.RIGHT,
		Vector2i.UP + Vector2i.LEFT, 
		Vector2i.DOWN + Vector2i.RIGHT,
		Vector2i.DOWN + Vector2i.LEFT
	]
	return get_slide_move_attack(map_cell, piece_directions, unit)

func get_queen_moves(map_cell, unit):
	var piece_directions = [
		Vector2i.UP + Vector2i.RIGHT,
		Vector2i.UP + Vector2i.LEFT, 
		Vector2i.DOWN + Vector2i.RIGHT,
		Vector2i.DOWN + Vector2i.LEFT, 
		Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT
	]
	return get_slide_move_attack(map_cell, piece_directions, unit)

func get_king_moves(map_cell, unit):
	var piece_directions = [
		Vector2i.UP, Vector2i.DOWN, 
		Vector2i.LEFT, Vector2i.RIGHT,
		Vector2i.UP + Vector2i.LEFT, Vector2i.UP + Vector2i.RIGHT,
		Vector2i.DOWN + Vector2i.LEFT, Vector2i.DOWN + Vector2i.RIGHT
	]
	return get_cell_move_attack(map_cell, piece_directions, unit)

func get_cell_move_attack(map_cell, piece_directions, unit):
	var moves = {
		"move": [],
		"attack": []
	}
	for direction in piece_directions:
		var move = map_cell + direction
		if not GameState.is_valid_cell(move):
			continue
		if GameState.is_enemy_at_cell(move, unit.unit_side):
			moves["attack"].append(move)
		elif not GameState.is_cell_occupied(move):
			moves["move"].append(move)
	return moves

func get_slide_move_attack(map_cell, piece_directions, unit):
	var moves = {
		"move": [],
		"attack": []
	}
	for direction in piece_directions:
		var direction_shift = 1
		while true:
			var move = map_cell + direction * direction_shift
			if not GameState.is_valid_cell(move):
				break
			if GameState.is_enemy_at_cell(move, unit.unit_side):
				moves["attack"].append(move)
				break
			if not GameState.is_cell_occupied(move):
				moves["move"].append(move)
			else:
				break
			direction_shift += 1
	return moves

extends Node

const SQUARE_DIM = 20
const PADDING = 1.75

var rng = RandomNumberGenerator.new()

var square_path = 'res://resources/squares/'
var board : Dictionary
var resources : Dictionary

func generate_board(size_input : int) -> Dictionary:
	
	#Generate map with cells
	var square_paths = dir_contents(square_path)
	var local_board = generate_spiral_map(size_input)
	print(local_board)
	local_board.reverse()
	
	#Generate map with indexes, names and space_position
	var index = 0
	for local_position in local_board:
		if index == 0:
			board[index] = {"name" : "Inizio",
							"space_position" : local_to_space_position(local_position),
							"color" : Color.RED}
		elif index == size_input:
			board[index] = {"name" : "Fine",
							"space_position" : local_to_space_position(local_position),
							"color" : Color.GREEN}
		else:
			rng.randomize()
			var res_id = rng.randi_range(0, square_paths.size() - 1)
			
			#BUG https://godotengine.org/qa/150508/error-loading-resource-files-in-game-build-in-godot-4
			resources[index] = load(square_paths[res_id].trim_suffix('.remap'))
			board[index] = {"name" : resources[index].location_name,
							"space_position" : local_to_space_position(local_position)}
							
		#"number" : resources[index].card_number,
		#"description" : resources[index].description}
		index += 1
	return board


func get_last_idx() -> int:
	for idx in board.keys():
		if board[idx].has('name'):
			if board[idx]['name'] == 'Fine':
				return idx
	return -1


func size():
	return board.size()


func local_to_space_position(position : Vector2):
	return Vector3(	position.x * (SQUARE_DIM + PADDING),
					-1,
					position.y * (SQUARE_DIM + PADDING))


func sum_lists(a : Vector2, b : Vector2) -> Vector2:
	return Vector2(a.x + b.x, a.y + b.y)


func generate_spiral_map(len_map : int):
	var spiral = [Vector2(0,0)]
	var directions = [Vector2(-1, 0), Vector2(0, 1), Vector2(1, 0), Vector2(0, -1)]
	var actual_d = 0
	var square_to_complete = 1
	var square_completed = 0
	for _i in range(len_map):
		spiral.append(sum_lists(spiral.back(), directions[actual_d]))
		square_completed += 1
		if square_completed == square_to_complete:
			square_to_complete += 1
			square_completed = 0
			actual_d = (actual_d + 1) % 4
	return spiral


func dir_contents(path) -> Array:
	var dir = DirAccess.open(path)
	var dirs = []
	if dir.open(path) != null:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				dirs.append(path + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	print(dirs)
	return dirs

extends Node

var square_scene = preload("res://board/scenes/square.tscn")
var squares_list : Dictionary

func generate_map(board_array : Dictionary) -> void:
	for square_idx in board_array.keys():
		var square_node = initialize(square_idx, board_array[square_idx])
		squares_list[square_idx] = square_node
		
func initialize(idx: int, square : Dictionary) -> Node3D:
	var square_node = square_scene.instantiate()
	add_child(square_node)
	square_node.initialize(idx, square)
	return square_node

func get_square_name(id : int) -> String:
	return squares_list[id].get_name()

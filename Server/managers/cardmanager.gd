extends Node

@onready var card_node = $CardActivation
var cards_path = 'res://resources/cards/'

var paths : Dictionary

var this_card : Dictionary
var this_card_path : String

func initialize() -> void:
	var cards_paths = dir_contents(cards_path)
	var idx = 0
	for card_path in cards_paths:
		paths[idx] = card_path
		idx += 1


func pick_card() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var card_number = rng.randi_range(0, paths.size() - 1)
	card_node.set_script(load(paths[card_number]))
	this_card = {"description" : card_node.description, 
				"action" : card_node.action}

func get_this_card() -> Dictionary:
	return this_card

func activate(player_id : int,
				board_infos : Dictionary,
				board_resources : Dictionary,
				players_infos : Dictionary):
				
	return card_node.activate(player_id, board_infos, board_resources, players_infos)


func dir_contents(path) -> Array:
	#Aggiorna qua
	var dir = DirAccess.open(path)
	var dirs = []
	if dir:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				dirs.append(path + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return dirs

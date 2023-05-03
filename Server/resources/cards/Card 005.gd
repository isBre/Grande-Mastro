extends Node

var description = "You are looking for an animal to accompany you on your adventure"
var action = "If you are in a place where animals are present go ahead 1 square!"

func activate(	this_player_id : int, 
				board_infos : Dictionary,
				board_resources : Dictionary,
				players_infos : Dictionary) -> Dictionary:
	
	var square_idx = players_infos[this_player_id]['square_idx']
	var board_resource = board_resources[square_idx]
	
	if board_resource.has_animals:
		return {this_player_id : {"moves" : 1}}
	return {}

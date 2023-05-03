extends Node

var description = "You have the ancient amulet of Ahstana with you"
var action = "If you are in a Dragon kingdom go back 2 squares"

func activate(	this_player_id : int, 
				board_infos : Dictionary,
				board_resources : Dictionary,
				players_infos : Dictionary) -> Dictionary:
	
	var square_idx = players_infos[this_player_id]['square_idx']
	var board_resource = board_resources[square_idx]
	
	if board_resource.has_dragons:
		return {this_player_id : {"moves" : -2}}
	
	return {}

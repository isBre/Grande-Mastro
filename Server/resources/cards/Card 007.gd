extends Node

var description = "It is starting to snow"
var action = "If you are in Frostaria you skip a turn!"

func activate(	this_player_id : int, 
				board_infos : Dictionary,
				board_resources : Dictionary,
				players_infos : Dictionary) -> Dictionary:
					
	var square_idx = players_infos[this_player_id]['square_idx']
	var board_resource = board_resources[square_idx]
	
	if "Frostaria" == board_resource.location_name:
		return {this_player_id : {"waiting_turns" : 1}}
	return {}

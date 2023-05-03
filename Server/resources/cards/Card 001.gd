extends Node

var description = "You stumble upon a treasure chest filled with gold and jewels"
var action = "Move forward 2 squares!"

func activate(	this_player_id : int, 
				board_infos : Dictionary,
				board_resources : Dictionary,
				players_infos : Dictionary) -> Dictionary:
	
	return {this_player_id : {"moves" : 2}}

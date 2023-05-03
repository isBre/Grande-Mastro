extends Node

var description = "You found a healing potion"
var action = "Move forward 1 square!"

func activate(	this_player_id : int, 
				board_infos : Dictionary,
				board_resources : Dictionary,
				players_infos : Dictionary) -> Dictionary:
	
	return {this_player_id : {"moves" : 1}}

extends Node

var description = "Someone left a very powerful sword on the road"
var action = "Go ahead 1 square!"

func activate(	this_player_id : int, 
				board_infos : Dictionary,
				board_resources : Dictionary,
				players_infos : Dictionary) -> Dictionary:
	
	return {this_player_id : {"moves" : 1}}

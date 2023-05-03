extends Node

var description = "Misanuth's witch has cast a powerful spell on you"
var action = "Skip a Turn!"

func activate(	this_player_id : int, 
				board_infos : Dictionary,
				board_resources : Dictionary,
				players_infos : Dictionary) -> Dictionary:
	
	return {this_player_id : {"waiting_turns" : 1}}

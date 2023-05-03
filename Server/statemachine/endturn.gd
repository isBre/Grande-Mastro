extends "state.gd"

var response_type = "all"

func enter(_previous_state : Node, Server : Node, GameManager : Node):
	
	#Update turn counter for each player
	print("Updating Turn ...")
	GameManager.update_turn()
	print("Turn Updated")

	#Send all players informations
	Server.update_client("ask_roll_dice", "end_turn", GameManager.get_players_infos(), GameManager.get_board_infos())

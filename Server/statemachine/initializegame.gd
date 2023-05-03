extends "state.gd"

var response_type = "all"

func enter(_previous_state: Node, Server : Node, GameManager : Node):
	
	Server.initialize_game("ask_roll_dice", "initialize_game", GameManager.get_players_infos(), GameManager.get_board_infos())

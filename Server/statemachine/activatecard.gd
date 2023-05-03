extends "state.gd"

var response_type = "all"

func enter(_previous_state : Node, Server : Node, GameManager : Node):
	
	print("Activating the card ...")
	var instructions = GameManager.activate_card()
	GameManager.update(instructions)
	print("Card Activate!")
	
	Server.update_client("winning_condition", "activate_card", GameManager.get_players_infos(), GameManager.get_board_infos(), instructions)

extends "state.gd"

var response_type = "all"

func enter(_previous_state : Node, Server : Node, GameManager : Node):
	
	print("Picking a card ...")
	GameManager.pick_card()
	print("Card Picked!")
	
	Server.update_client("activate_card", "pick_card", GameManager.get_players_infos(), GameManager.get_board_infos(), {}, GameManager.this_card())

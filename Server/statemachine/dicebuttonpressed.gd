extends "state.gd"

#This single is cause only one player is able to roll the dice
var response_type = "single"

func enter(_previous_state : Node, Server : Node, GameManager : Node):
	
	var this_player = GameManager.get_turn_player()
	print("Player " + GameManager.get_player_name(this_player) + " rolled the Dice ...")
	Server.update_client("dice_show_value", "dice_button_pressed", GameManager.get_players_infos(), GameManager.get_board_infos())

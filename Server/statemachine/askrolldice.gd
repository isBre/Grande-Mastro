extends "state.gd"

var response_type = "all"

func enter(_previous_state : Node, Server : Node, GameManager : Node):
	
	var this_player = GameManager.get_turn_player()
	Server.allow_player_roll_dice(this_player, "dice_button_pressed", "ask_roll_dice")
	print("Waiting for " + GameManager.get_player_name(this_player) + " ... ")

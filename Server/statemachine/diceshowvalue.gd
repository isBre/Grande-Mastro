extends "state.gd"

var response_type = "all"


func enter(_previous_state : Node, Server : Node, GameManager : Node):
	
	#Throw Dice
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var dice_result = rng.randi_range(1, 6)
	print("Dice Value: " + str(dice_result) + "!")
	
	var instructions = {GameManager.get_turn_player() : 
						{"moves" : dice_result}}

	#Update all players
	GameManager.update(instructions)

	#Send all players informations
	Server.update_client("winning_condition", "dice_show_value", GameManager.get_players_infos(), GameManager.get_board_infos(), instructions)

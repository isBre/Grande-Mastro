extends "state.gd"

var response_type = "all"

func enter(_previous_state : Node, Server : Node, GameManager : Node):
	var winner_id = GameManager.who_won()
	print("Dentro end game: " + str(winner_id))
	print(str(winner_id) + "  Won!")
	Server.show_winner("end_game", winner_id, GameManager.get_players_infos(), GameManager.get_board_infos())

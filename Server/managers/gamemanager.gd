extends Node

@onready var BoardManager : Node = $BoardManager
@onready var PlayerManager : Node = $PlayerManager
@onready var CardManager : Node = $CardManager


func generate_board(dimension : int) -> void:
	BoardManager.generate_board(dimension)


func load_players(players : Dictionary) -> void:
	for id in players.keys():
		PlayerManager.add(id, players[id])


func load_cards() -> void:
	CardManager.initialize()


func pick_card() -> void:
	CardManager.pick_card()

	
func this_card() -> Dictionary:
	return CardManager.get_this_card()

	
func activate_card() -> Dictionary:
	return CardManager.activate(PlayerManager.get_this_turn_player_id(),
								BoardManager.board,
								BoardManager.resources,
								PlayerManager.players_list)


#The Dictionary is composed as follows:
#{PlayerID : {"moves" : x , 
#			  "waiting_turns" : y}}
func update(changes : Dictionary):
	PlayerManager.update(changes, BoardManager.board)


func get_players_infos() -> Dictionary:
	return PlayerManager.players_list


func get_board_infos() -> Dictionary:
	return BoardManager.board


func update_turn() -> void:
	PlayerManager.next_turn()
	while(PlayerManager.is_waiting(PlayerManager.get_this_turn_player_id())):
		PlayerManager.skip_waiting()


func winning_condition() -> bool:
	var last_square_idx = BoardManager.get_last_idx()
	return PlayerManager.winning_condition(last_square_idx)


func who_won() -> int:
	var last_square_idx = BoardManager.get_last_idx()
	return PlayerManager.who_won(last_square_idx)


func get_turn_player() -> int:
	return PlayerManager.get_this_turn_player_id()

	
func get_player_name(idx : int) -> String:
	return PlayerManager.get_player_name(idx)

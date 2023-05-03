extends Node

var players_list : Dictionary
var turn_value : int = -1


func initialize(players_info : Dictionary):
	for id in players_info.keys():
		add(id, players_info[id])


func add(id : int, player : Dictionary):
	turn_value += 1
	players_list[id] = player
	players_list[id]['square_idx'] = 0
	players_list[id]['waiting_turns'] = 0
	players_list[id]['next_turn_in'] = turn_value


func update(changes : Dictionary, board_infos : Dictionary):
	for id in changes.keys():
		if changes[id].has('moves'):
			update_moves(id, changes[id]['moves'], board_infos)
		if changes[id].has('waiting_turns'):
			update_waiting_turns(id, changes[id]['waiting_turns'])


func update_waiting_turns(id : int, waiting_turns : int) -> void:
	players_list[id]['waiting_turns'] += waiting_turns		


func update_moves(id : int, moves : int, board_infos : Dictionary) -> void:
	if players_list[id]['square_idx'] + moves > board_infos.size() - 1:
		players_list[id]['square_idx'] = 2 * (board_infos.size() - 1) - (players_list[id]['square_idx'] + moves)
	elif players_list[id]['square_idx'] + moves < 0:
		players_list[id]['square_idx'] = 0
	else:
		players_list[id]['square_idx'] += moves


func get_this_turn_player_id() -> int:
	for id in players_list.keys():
		if players_list[id]['next_turn_in'] == 0:
			return id
	return -1


#Here I enter to update the "next_turn_in" of all players
func next_turn() -> void:
	for id in players_list.keys():
		if players_list[id]['next_turn_in'] == 0:
			players_list[id]['next_turn_in'] = turn_value
		else:
			players_list[id]['next_turn_in'] -= 1

#Here If the player is in waiting block
func skip_waiting() -> void:
	for id in players_list.keys():
		if players_list[id]['next_turn_in'] == 0:
			players_list[id]['next_turn_in'] = turn_value
			players_list[id]['waiting_turns'] -= 1
		else:
			players_list[id]['next_turn_in'] -= 1
	

func winning_condition(last_idx : int) -> bool:
	for id in players_list.keys():
		if players_list[id]['square_idx'] == last_idx:
			return true
	return false


func who_won(last_idx : int) -> int:
	for id in players_list.keys():
		if players_list[id]['square_idx'] == last_idx:
			return id
	return -1


func is_waiting(id : int) -> bool:
	return players_list[id]['waiting_turns'] > 0


func get_players_list() -> Dictionary:
	return players_list


func size():
	return players_list.size()


func get_player_name(idx : int) -> String:
	return players_list[idx]['nickname']

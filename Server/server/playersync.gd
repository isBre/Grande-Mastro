extends Node

"""
This class handle multi connection to the server,
Sometimes we need to wait for everyone to be ready.
"""

var players : Dictionary = {}
var is_ready : Dictionary = {}

func add(id : int, player_data : Dictionary) -> void:
	players[id] = player_data
	is_ready[id] = false
	
func remove(id : int) -> void:
	players.erase(id)
	is_ready.erase(id)
	
func get_player_data(id: int) -> Dictionary:
	return players[id]

func get_players_data() -> Dictionary:
	return players
	
func get_players_status() -> Dictionary:
	return is_ready
	
func is_player_ready(id : int) -> void:
	is_ready[id] = true

func reset_ready() -> void:
	for id in is_ready.keys():
		is_ready[id] = false

func is_everyone_ready() -> bool:
	for id in is_ready.keys():
		if is_ready[id] == false:
			return false
	return true

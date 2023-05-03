extends Node

const PAWN_FOLDER : String = "res://board/pawns/"
var players_list : Dictionary

func initialize(players_infos : Dictionary, board_infos : Dictionary):
	for id in players_infos.keys():
		players_list[id] = add(players_infos[id], board_infos)
		
func add(player: Dictionary, board_infos : Dictionary) -> Node:
	var player_scene = load(PAWN_FOLDER + player['pawn'] + ".tscn")
	var player_node = player_scene.instantiate()
	add_child(player_node)
	player_node.initialize(player, board_infos)
	return player_node
	
func update(players_infos : Dictionary, board_infos : Dictionary):
	for id in players_infos.keys():
		players_list[id].update(players_infos[id], board_infos)

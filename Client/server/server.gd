extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 3234

var network = ENetMultiplayerPeer.new()

var local_player_id = 0
var nickname : String
var color : Color
var pawn : String

var RoomManager : Node

const GAME_NODE_PATH : String = "res://board/scenes/game.tscn"
var GameManager : Node




# =========================
# 	   Client Creation
# =========================


func _ready():
	multiplayer.connect("peer_connected", Callable(self, "_player_connected"))
	multiplayer.connect("peer_disconnected", Callable(self, "_player_disconnected"))
	multiplayer.connect("connection_failed", Callable(self, "_connected_fail"))
	multiplayer.connect("server_disconnected", Callable(self, "_server_disconnected"))


func _connect_to_server(ip_address, port):
	network.create_client(ip_address, port)
	multiplayer.connect("connected_to_server", Callable(self, "_connected_ok"))
	multiplayer.set_multiplayer_peer(network)


func _player_connected(id):
	print("Player: " + str(id) + " Connected")


func _player_disconnected(id):
	print("Player: " + str(id) + " Disconnected")


func _connected_fail():
	print("Failed to connect")


func _server_disconnected():
	print("Server Disconnected")


func _connected_ok():
	local_player_id = multiplayer.get_unique_id()
	rpc_id(1, "player_login", local_player_id, {"nickname": nickname, "color" : color, "pawn" : pawn})
	print("Successfully connected to server")
	RoomManager = get_tree().get_root().get_node('Room')




# =========================
# 	  Client Functions
# =========================


@rpc("any_peer")
func update_lobby(players_infos : Dictionary, players_status : Dictionary):
	RoomManager.update_lobby(players_infos, players_status)
	

#Try to load the game
#The server verify if everyone is ready
#If so will start the game procedure
func ready():
	rpc_id(1, "im_ready", local_player_id)


#Load the GameManager and call the update function
#this_state will trigger different function inside the GameManager
@rpc("any_peer")
func load_game_client(next_state : String, this_state : String, players_info : Dictionary, board_array : Dictionary):
	
	GameManager = preload(GAME_NODE_PATH).instantiate()
	get_tree().get_root().add_child(GameManager)
	get_tree().get_root().get_node("Room").queue_free()
	
	GameManager.set_local_id(local_player_id)
	GameManager.update(this_state, players_info, board_array)
	
	rpc_id(1, "update_server", local_player_id, next_state)


#Standard function called by the server
@rpc("any_peer")
func update_data(next_state : String, this_state : String, players_infos : Dictionary, board_infos : Dictionary, instructions : Dictionary, card_info : Dictionary):
	
	#next_state: represent the next state to communicate to the server
	#this_state: represent the current state communicate from the server
	#updated_players_infos: represent the informations about players
	#update_board_infos: represent the informations about the board
	#card_info: represent the card informations (optional)
	#instructions: represent the instruction in a Dictionary format (optional)
	
	await GameManager.update(this_state, players_infos, board_infos, instructions, card_info)
	
	rpc_id(1, "update_server", local_player_id, next_state)


#FIX awful code
#Communicate to the server that the dice button has been pressed
func dice_button_pressed():
	rpc_id(1, "update_server", local_player_id, "dice_button_pressed")


@rpc("any_peer")
func activate_dice_button(_next_state : String, this_state : String):
	await GameManager.update(this_state)



@rpc("any_peer")
func player_won(_this_state : String, id : int, players_infos : Dictionary, board_info : Dictionary) -> void:
	GameManager.player_won(id, players_infos, board_info)
	


# =========================
#   Empty Server Functions
# =========================

@rpc('any_peer')
func player_login(_id : int, _player_data : Dictionary): pass

@rpc('any_peer')
func im_ready(_id : int): pass

@rpc("any_peer")
func update_server(_player_id : int, _next_state : String): pass

extends Node

var network = ENetMultiplayerPeer.new()
var port = 3234
var max_players = 12

var ready_players = 0

@onready var PlayerSync : Node = $playersync

var StateMachine : Node




# =========================
# 	   Server Creation
# =========================


func _ready():
	start_server()


func start_server():
	network.create_server(port, max_players)
	multiplayer.set_multiplayer_peer(network)
	multiplayer.connect("peer_connected", Callable(self, "_player_connected"))
	multiplayer.connect("peer_disconnected", Callable(self, "_player_disconnected"))
	print("Server Started")
	
	
func _player_connected(player_id):
	print("Player: " + str(player_id) + " Connected")
	
	
func _player_disconnected(player_id):
	
	#It depend on situtation
	#I can do that only in lobby
	#If a player left during game it doesnt work
	
	PlayerSync.remove(player_id)
	rpc("update_lobby", PlayerSync.get_players_data(), PlayerSync.get_players_status())
	print("Player: " + str(player_id) + " Disconnected")




# =========================
# 	   Server Functions
# =========================


#This functions is called when a player succesfully connect to the server
#I going to update the lobby containing every player
@rpc('any_peer')
func player_login(id : int, player_data : Dictionary):
	print("Player " + player_data['nickname'] + " with color " + str(player_data['color']) + " and pawn " + player_data['pawn'] + " added in the Lobby Succesfully!")
	PlayerSync.add(id, player_data)
	rpc("update_lobby", PlayerSync.get_players_data(), PlayerSync.get_players_status())


#if everyone is ready we can start the StateMachine
#The StateMachine will then initialize the game also for the client
@rpc('any_peer')
func im_ready(id : int):
	PlayerSync.is_player_ready(id)
	print("Player: " + str(id) + " is Ready")
	rpc("update_lobby", PlayerSync.get_players_data(), PlayerSync.get_players_status())
	
	if PlayerSync.is_everyone_ready():
		print("Everyone is Ready!")
		PlayerSync.reset_ready()
		
		#Actually Load the game
		StateMachine = preload("res://statemachine/StateMachine.tscn").instantiate()
		get_tree().get_root().add_child(StateMachine)
		StateMachine.initialize(PlayerSync.get_players_data(), self)


#This function will be called by the Game Machine with state Initialize
#Ask the client to load the match with this data
func initialize_game(next_state : String, this_state : String, players_infos : Dictionary, board_infos : Dictionary):
	rpc("load_game_client", next_state, this_state, players_infos, board_infos)


#This function will activate the roll dice button to the client
func allow_player_roll_dice(this_player : int, next_state : String, this_state : String) -> void:
	rpc_id(this_player, "activate_dice_button", next_state, this_state)


func show_winner(this_state : String, winner_id : int, players_infos : Dictionary, board_infos : Dictionary) -> void:
	rpc("player_won", this_state, winner_id, players_infos, board_infos)


#Main function for communicate to the client
func update_client(next_state : String, this_state: String,  players_infos : Dictionary, board_infos : Dictionary, instructions : Dictionary = {}, card_info : Dictionary = {}):
	rpc("update_data", next_state, this_state, players_infos, board_infos, instructions, card_info)


@rpc("any_peer")
func update_server(player_id : int, next_state : String):
	
	print("[From Client]: " + next_state)
	
	match(StateMachine.get_response_type(next_state)):
		
		"single":
			StateMachine._change_state(next_state)
			
		"all":
			#Check if every player agree to proceed
			PlayerSync.is_player_ready(player_id)
			
			if PlayerSync.is_everyone_ready():
				PlayerSync.reset_ready()
			
				StateMachine._change_state(next_state)




# =========================
#  Empty Client Functions
# =========================


@rpc("any_peer")
func update_lobby(_players_infos : Dictionary, _players_status : Dictionary): pass

@rpc("any_peer")
func load_game_client(_next_state : String, _this_state : String, _players_info : Dictionary, _board_array : Dictionary): pass

@rpc("any_peer")
func update_data(_next_state : String, _this_state : String, _updated_players_infos : Dictionary, _updated_board_infos : Dictionary, _instructions : Dictionary, card_info : Dictionary): pass

@rpc("any_peer")
func player_won(_this_state : String, _id : int, _players_infos : Dictionary, _board_info : Dictionary) -> void: pass

@rpc("any_peer")
func activate_dice_button(next_state : String, this_state : String): pass

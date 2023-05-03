extends Node

var previous_state : Node = null
var current_state : Node = null

var GameManager : Node
var Server : Node

@onready var states_map = {
	"initialize_game" : $InitializeGame,
	"ask_roll_dice" : $AskRollDice,
	"dice_button_pressed" : $DiceButtonPressed,
	"dice_show_value" : $DiceShowValue,
	"pick_card" : $PickCard,
	"activate_card" : $ActivateCard,
	"end_turn" : $EndTurn,
	"winning_condition" : $WinningCondition,
	"end_game" : $EndGame
}


func initialize(_players : Dictionary,
				_server : Node):
	
	#Every Children should be connected to _change_state
	#function here when the signal finished is emitted
	for state_node in get_children():
		state_node.connect("finished", Callable(self, "_change_state"))
	
	#Get the Server Node
	Server = _server
	
	#Instantiate GameManager
	GameManager = preload("res://managers/gamemanager.tscn").instantiate()
	get_tree().get_root().add_child(GameManager)
	
	#Generate Players Infos
	print("Loading Players ...")
	GameManager.load_players(_players)
	print("Player Loaded!")
	
	#Ask GameManager to create the board
	print("Creating the Board ...")
	GameManager.generate_board(12)
	print("Board Generated!")
	
	#Load Cards
	print("Loading Cards ...")
	GameManager.load_cards()
	print("Cards Loaded!")
	
	current_state = states_map["initialize_game"]
	current_state.enter(previous_state, Server, GameManager)
	
	print("Current state: " + current_state.name)



func _change_state(state_name):
	
	#change_state
	previous_state = current_state
	current_state = states_map[state_name]
	print("Current state: " + current_state.name)
	
	#enter in a new state
	current_state.enter(previous_state, Server, GameManager)


#This is useful to coordinate player
#'all' means all player need to agree
#'single' only one player
func get_response_type(state_name : String) -> String:
	return states_map[state_name].response_type

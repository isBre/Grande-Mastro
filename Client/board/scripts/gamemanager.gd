extends Node

@onready var BoardManager : Node = $BoardManager
@onready var PlayerManager : Node = $PlayerManager
@onready var UIManager : Node = $UIManager
@onready var VisualManager : Node = $VisualManager

var local_player_id : int = 0


func update(this_state : String, players_infos : Dictionary = {}, board_infos : Dictionary = {}, instructions : Dictionary = {}, card_info : Dictionary = {}):
	await call(this_state, players_infos, board_infos, instructions, card_info)




# ==============================
#    STATE MACHINE FUNCTIONS
# ==============================


func initialize_game(players_info : Dictionary, board_array : Dictionary, _instructions : Dictionary, _card_info : Dictionary):
	
	BoardManager.generate_map(board_array)
	
	PlayerManager.initialize(players_info, board_array)
	
	UIManager.initialize_players_HUD(players_info, board_array)
	
	VisualManager.move_to_turn_player(players_info, board_array)
	VisualManager.set_global_camera()
	
	#Automatic or Manual Camera link to signal
	UIManager.connect("camera_mode_change", Callable(self, "update_camera_mode"))


func ask_roll_dice(_players_info : Dictionary, _board_array : Dictionary, _instructions : Dictionary, _card_info : Dictionary):
	VisualManager.set_global_camera()
	UIManager.activate_dice_button()


func dice_button_pressed(_players_info : Dictionary, _board_array : Dictionary, _instructions : Dictionary, _card_info : Dictionary):
	VisualManager.set_global_camera()
	await UIManager.random_numbers_fade_in(0.2)
	await wait(1.5)


func dice_show_value(players_info : Dictionary, board_array : Dictionary, instructions : Dictionary, _card_info : Dictionary):
	UIManager.show_actual_number(instructions[instructions.keys()[0]]['moves'])
	
	await wait(1)
	VisualManager.focus_on_turn_player(players_info, board_array, instructions)
	VisualManager.set_focus_on_player_camera()
	
	await wait(0.5)
	UIManager.update_players_HUD(players_info, board_array)
	PlayerManager.update(players_info, board_array)
	await UIManager.random_numbers_fade_out(0.2)
	
	await wait(2)



func pick_card(_players_info : Dictionary, _board_array : Dictionary, _instructions : Dictionary, card_info : Dictionary):
	VisualManager.set_global_camera()
	
	UIManager.card_update(card_info)
	await UIManager.card_fade_in(0.2)
	await wait(3.5)
	await UIManager.card_fade_out(0.2)


func activate_card(players_info : Dictionary, board_array : Dictionary, instructions : Dictionary, _card_info : Dictionary):
	VisualManager.focus_on_turn_player(players_info, board_array, instructions)
	VisualManager.set_focus_on_player_camera()
	await wait(0.5)
	
	PlayerManager.update(players_info, board_array)
	UIManager.update_players_HUD(players_info, board_array)
	await wait(2)


func end_turn(players_info : Dictionary, board_array : Dictionary, _instructions : Dictionary, _card_info : Dictionary):
	PlayerManager.update(players_info, board_array)
	
	UIManager.next_turn_update(players_info)
	await UIManager.next_turn_fade_in(0.2)
	await wait(2.5)
	await UIManager.next_turn_fade_out(0.2)
	
	UIManager.update_players_HUD(players_info, board_array)
	VisualManager.move_to_turn_player(players_info, board_array)
	VisualManager.set_global_camera()
	


# ==============================
#         OTHER FUNCTIONS
# ==============================

#this should be a state machine function
#func end_game(players_info : Dictionary, board_array : Dictionary, instructions : Dictionary, card_info : Dictionary):
func player_won(winner_id : int, players_info, board_array):
	UIManager.player_won(winner_id, players_info)
	VisualManager.player_won(winner_id, players_info, board_array)


func set_local_id(_local_player_id : int):
	local_player_id = _local_player_id


func update_camera_mode(user_choice):
	VisualManager.set_camera_mode(user_choice)
	
func wait(sec : float):
	await get_tree().create_timer(sec).timeout

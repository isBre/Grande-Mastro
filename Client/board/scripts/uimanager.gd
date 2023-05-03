extends Node

signal camera_mode_change(user_choice)

var player_HUD_scene = preload("res://board/scenes/playerhud.tscn")
var players_HUD_list : Dictionary

@onready var dice_button : Button = $DiceButton
@onready var number_label : Label = $NumberOutput
@onready var final_text : Label = $BottomPanel/FinalText

@onready var card : TextureRect = $Card
@onready var card_description : Label = $Card/VBoxContainer/Description
@onready var card_action : Label = $Card/VBoxContainer/Action

@onready var next_turn : ColorRect = $NewTurn
@onready var next_turn_label : Label = $NewTurn/VBoxContainer/NameSentence

@onready var camera_mode : CheckButton = $CameraMode

var rng = RandomNumberGenerator.new()
var generate = false




func _process(_delta):
	
	#Generate random number (visualization of roll dice)
	if generate:
		rng.randomize()
		number_label.text = str(rng.randi_range(1, 6))


#Allow random numbers to be visualized (roll dice)
func random_numbers_fade_in(sec : float):
	generate = true
	number_label.show()
	var tween = number_label.create_tween()
	tween.tween_property(number_label, "modulate", Color(1.0, 1.0, 1.0, 1.0), sec)
	await get_tree().create_timer(sec).timeout


#Show the actual value
func show_actual_number(roll : int):
	generate = false
	number_label.text = str(roll)


func random_numbers_fade_out(sec : float):
	var tween = number_label.create_tween()
	tween.tween_property(number_label, "modulate", Color(1.0, 1.0, 1.0, 0.0), sec)
	await get_tree().create_timer(sec).timeout
	number_label.hide()

#Initialize top-left player informations
func initialize_players_HUD(players_infos: Dictionary, board_infos : Dictionary) -> void:
	for id in players_infos.keys():
		var player_HUD_node = player_HUD_scene.instantiate()
		$AllPlayersInfo.add_child(player_HUD_node)
		players_HUD_list[id] = player_HUD_node
		update_player_HUD(id, players_infos, board_infos)

#Update top-left player informations
func update_players_HUD(players_infos: Dictionary, board_infos : Dictionary) -> void:
	for id in players_infos.keys():
		update_player_HUD(id, players_infos, board_infos)


func update_player_HUD(this_player_id : int, players_infos: Dictionary, board_infos : Dictionary):
	players_HUD_list[this_player_id].get_node("HBoxContainer/Contour/Color").modulate = players_infos[this_player_id]['color']
	players_HUD_list[this_player_id].get_node("HBoxContainer/Texts/Name").text = players_infos[this_player_id]['nickname']
	var player_square_name = board_infos[players_infos[this_player_id]['square_idx']]['name']
	players_HUD_list[this_player_id].get_node("HBoxContainer/Texts/Square").text = str(players_infos[this_player_id]['square_idx']) + " - " + player_square_name
	players_HUD_list[this_player_id].get_node("HBoxContainer/Contour/Stop").visible = players_infos[this_player_id]['waiting_turns'] > 0
	
	if players_infos[this_player_id]['next_turn_in'] == 0:
		players_HUD_list[this_player_id].get_node('Bg').color = players_infos[this_player_id]['color'] - Color(0.2, 0.2, 0.2, 0.0)
	else:
		players_HUD_list[this_player_id].get_node('Bg').color = Color("000000c8")


func activate_dice_button() -> void:
	dice_button.show()


func _on_dice_button_pressed():
	dice_button.hide()
	Server.dice_button_pressed()


#Won text
func player_won(id : int, players_infos: Dictionary):
	final_text.get_parent().show()
	final_text.text = players_infos[id]['nickname'] + " Won!"


#Update card UI
func card_update(card_info : Dictionary):
	card_description.text = card_info['description']
	card_action.text = card_info['action']


#Visualize Card
func card_fade_in(sec : float):
	card.show()
	var tween = card.create_tween()
	tween.tween_property(card, "modulate", Color(1.0, 1.0, 1.0, 1.0), sec)
	await get_tree().create_timer(sec).timeout


func card_fade_out(sec : float):
	var tween = card.create_tween()
	tween.tween_property(card, "modulate", Color(1.0, 1.0, 1.0, 0.0), sec)
	await get_tree().create_timer(sec).timeout
	card.hide()


#Update card UI
func next_turn_update(player_info : Dictionary):
	var id = get_this_turn_player(player_info)
	next_turn_label.text = "It's " + player_info[id]['nickname'] + "'s turn"


#Visualize Card
func next_turn_fade_in(sec : float):
	next_turn.show()
	var tween = next_turn.create_tween()
	tween.tween_property(next_turn, "modulate", Color(1.0, 1.0, 1.0, 1.0), sec)
	await get_tree().create_timer(sec).timeout


func next_turn_fade_out(sec : float):
	var tween = next_turn.create_tween()
	tween.tween_property(next_turn, "modulate", Color(1.0, 1.0, 1.0, 0.0), sec)
	await get_tree().create_timer(sec).timeout
	next_turn.hide()


func _on_camera_mode_toggled(button_pressed):
	if button_pressed:
		camera_mode.text = "Camera: Manual"
	else:
		camera_mode.text = "Camera: Auto"
	emit_signal("camera_mode_change", button_pressed)


func get_this_turn_player(players_info : Dictionary):
	for id in players_info:
		if players_info[id]['next_turn_in'] == 0:
			return id

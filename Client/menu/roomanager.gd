extends Node

@onready var players_parent = $HBoxContainer/VBoxContainer
@onready var ready_button = $HBoxContainer/VBoxContainer/ReadyButton

@onready var playerHUD = preload("res://board/scenes/playerhud.tscn")

func update_lobby(players_data : Dictionary, players_status : Dictionary):
	
	var nodes = players_parent.get_children()
	
	var nodes_name = []
	for n in nodes:
		if not n.name == "ReadyButton":
			nodes_name.append(n.name)
	
	for id in players_data.keys():
		if not str(id) in nodes_name:
			var new_player = playerHUD.instantiate()
			players_parent.add_child(new_player)
			new_player.name = str(id)
			new_player.get_node("HBoxContainer/Texts/Name").text = players_data[id]['nickname']
			new_player.get_node("HBoxContainer/Contour/Color").modulate = players_data[id]['color']
			new_player.get_node("HBoxContainer/Texts/Square").text = "Not Ready"
			nodes_name.append(new_player.name)
	
	for n in players_parent.get_children():
		if not int(str(n.name)) in players_data.keys():
			if not n.name == "ReadyButton":
				n.queue_free()
	
	for id in players_status.keys():
		if players_status[id] == true:
			players_parent.get_node(str(id)).get_node("HBoxContainer/Texts/Square").text = "Ready!"


func _on_ready_button_pressed():
	#var player_final_infos = {"nickname" : player_nickname.text, "color" : color_picker.color}
	Server.ready()
	ready_button.disabled = true
	ready_button.text = "Waiting for other players ..."

extends Node

@onready var nickname = $CenterContainer/HBoxContainer/VBoxContainer/Grid/Nickname
@onready var pawn = $CenterContainer/HBoxContainer/VBoxContainer/Grid/PawnName
@onready var color = $CenterContainer/HBoxContainer/VBoxContainer/Grid/ColorPickerButton
@onready var ip_address = $CenterContainer/HBoxContainer/VBoxContainer/Grid/IPAddress
@onready var port = $CenterContainer/HBoxContainer/VBoxContainer/Grid/Port
@onready var lobby_scene = preload("res://menu/room.tscn")

var random_names = ['Aria Dawnstrider', 'Aria Dawnstrider', 'Aria Dawnstrider', 'Saren the Swift', 'Saren the Swift']

#Initialize menu customization options
func _ready():
	nickname.text = random_names[randi() % random_names.size()]
	pawn.select(0)
	color.color = Color(randf(), randf(), randf())
	
	ip_address.text = Server.DEFAULT_IP
	port.text = str(Server.DEFAULT_PORT)


func _on_JoinBtn_pressed():
	Server.nickname = nickname.text
	Server.pawn = pawn.get_item_text(pawn.selected)
	Server.color = color.color
	Server._connect_to_server(ip_address.text, int(port.text))
	
	var lobby = lobby_scene.instantiate()
	get_tree().get_root().add_child(lobby)
	self.queue_free()

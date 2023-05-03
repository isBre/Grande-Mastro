extends Node3D

#Global Camera
@onready var global_camera = $TopDownCamera

#Zoom Camera
@onready var rotation_node = $SquareVision
@onready var focus_camera = $SquareVision/ZoomCamera

const HEIGHT = 60
var FOCUS_DISTANCE = 15

var manual_camera : bool = false

var this_camera : Camera3D
var turn_to : Vector3


func _ready():
	this_camera = global_camera


func _physics_process(delta):
	
	#Slowly move towards a player when in topdown
	if not manual_camera:
		global_camera.position = lerp(global_camera.position, turn_to, delta)

	#Rotate around player when in zoom_camera
	rotation_node.rotation.y = rotation_node.rotation.y + delta/10
	if rotation_node.rotation.y >= 360:
		rotation_node.rotation.y = rotation_node.rotation.y - 360


func player_won(winner: int, players_info, board_array):
	focus_this_player(winner, players_info, board_array)
	focus_camera.current = true


#Move toward the player current turn
func move_to_turn_player(players_info : Dictionary, board_array : Dictionary) -> void:
	var turn_id = get_this_turn_player(players_info)
	var player_pos = board_array[players_info[turn_id]['square_idx']]['space_position']
	turn_to = Vector3(player_pos.x, HEIGHT, player_pos.z)


func set_global_camera():
	if not manual_camera:
		this_camera = global_camera
		this_camera.current = true
		

func set_focus_on_player_camera():
	if not manual_camera:
		this_camera = focus_camera
		this_camera.current = true
	

func get_current_camera():
	return this_camera


#true: manual
#false: automatic
func set_camera_mode(value : bool):
	global_camera.current = true
	manual_camera = value


#Set focus camera on player considering the instruction
func focus_on_turn_player(players_infos : Dictionary, board_infos : Dictionary, _instructions : Dictionary) -> void:
	var focus_id = get_this_turn_player(players_infos)
	focus_this_player(focus_id, players_infos, board_infos)
	

#Set the focus camera on specified id player
func focus_this_player(this_player_id : int, players_infos : Dictionary, board_infos : Dictionary) -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	focus_camera.position.z = rng.randi_range(10, 100)
	var focus_position = board_infos[players_infos[this_player_id]['square_idx']]['space_position']
	rotation_node.position = focus_position
	focus_camera.look_at(focus_position, Vector3.UP)


func _unhandled_input(event):
	if manual_camera:
		if event is InputEventMouseMotion:
			if event.button_mask == MOUSE_BUTTON_LEFT:
				global_camera.position.x -= event.relative.x * (global_camera.position.y/500)
				global_camera.position.z -= event.relative.y * (global_camera.position.y/500)


func get_this_turn_player(players_info : Dictionary):
	for id in players_info:
		if players_info[id]['next_turn_in'] == 0:
			return id

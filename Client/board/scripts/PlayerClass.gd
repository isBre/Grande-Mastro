extends RigidBody3D

#How much higher than the square should be positionated
const TOP_POSITION : int = 6

#Basic Infos
var nickname : String
var color : Color
var square_idx : int = -1
var waiting_turns : int
var pawn_name : String


#This function must be called once when the game is started
#Contains all the initializations
func initialize(player_info : Dictionary, board_infos : Dictionary) -> void:
	nickname = player_info['nickname']
	waiting_turns = player_info['waiting_turns']
	pawn_name = player_info['pawn']
	set_color(player_info['color'])
	square_idx = player_info['square_idx']
	move(board_infos[square_idx]['space_position'])


#Here we only change: waiting_turns and square
func update(player_info : Dictionary, board_infos : Dictionary) -> void:
	waiting_turns = player_info['waiting_turns']
	if not player_info['square_idx'] == square_idx:
		square_idx = player_info['square_idx']
		move(board_infos[square_idx]['space_position'])


#Change the color of the player pawn
#Is computed only once in the initialize function
func set_color(_color : Color) -> void:
	color = _color
	get_node(pawn_name).get_surface_override_material(0).albedo_color = color
	
	#var material_shader = load(PAWN_MATERIAL).duplicate(true)
	#material_shader.albedo_color = color
	#$Particles.material_override = material_shader 
	

func get_color() -> Color:
	return color

func set_nickname(_nickname) -> void:
	nickname = _nickname

func get_nickname() -> String:
	return nickname

#Move tha player on top of a given square
#Player is moved in position y = TOP_POSITION
#Is added some randomness to avoid strange positions
func move(new_position : Vector3) -> void:
	
	#Generate x and z missalignment 
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randf_range(-6, 6)
	rng.randomize()
	var z = rng.randf_range(-6, 6)
	rng.randomize()
	var y_rotation = rng.randf_range(1,360)
	
	#The final position is the position of the square new_position
	#plus the y and the x,z randomized
	position = new_position + Vector3(x, TOP_POSITION, z) 
	rotate_y(y_rotation)
	linear_velocity = Vector3(0, -20, 0)
	await get_tree().create_timer(0.075).timeout
	$Particles.emitting = true


func is_waiting() -> bool:
	return not (waiting_turns == 0)
	
func update_waiting_turn() -> void:
	waiting_turns -= 1
	
func add_waiting_turn(w : int) -> void:
	waiting_turns += w

func get_waiting_turn() -> int:
	return waiting_turns

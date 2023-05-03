extends Node3D

#Square Infos Camera
@onready var square_visualization = $VisualizationCamera/PhotoInfos
@onready var visualization_camera = $VisualizationCamera
@onready var infos_square = $VisualizationCamera/Infos
@onready var back_panel = $VisualizationCamera/BackPanel

@onready var title = $VisualizationCamera/Infos/Title
@onready var description = $VisualizationCamera/Infos/Description
@onready var number = $VisualizationCamera/PhotoInfos/Circle/Number

const DIR_IMAGES = "res://resources/images/"
const IMG_EXTENSION = ".png"

var VisualManager : Node

var mouse : Vector2
var worldspace

func initialize(visual_manager : Node):
	VisualManager = visual_manager


func _process(delta):
	
	#Make square rotate
	square_visualization.rotation.y = square_visualization.rotation.y + delta
	if square_visualization.rotation.y >= 360:
		square_visualization.rotation.y = square_visualization.rotation.y - 360
		
	
	#FIX this, very ugly
	if VisualManager.get_block_access():
		if get_tree().root.get_node('GameManager/UIManager/Card').is_visible():
			get_tree().root.get_node('GameManager/UIManager/Card').hide()


func _physics_process(delta):
	worldspace = get_world_3d().direct_space_state


#This function handle the click and the mouse position
#Note that is unhandled 'cause we need to ignore control nodes
func _unhandled_input(event):
	if event is InputEventMouse:
		mouse = event.position
	if event is InputEventMouse and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var square = get_square_clicked()
			handle_square_visualization(square)


#Draw the raycast with the current camera in VisualManager
func get_square_clicked():
	var start = VisualManager.get_current_camera().project_ray_origin(mouse)
	var end = VisualManager.get_current_camera().project_position(mouse, 10000)
	var query = PhysicsRayQueryParameters3D.create(start, end)
	var result = worldspace.intersect_ray(query)
	
	if result.is_empty():
		return null
	else:
		return result.collider.get_owner()

func handle_square_visualization(square):
	
	#If raycast is not empty
	if square:
		
		#FIX second condition: very bad
		if square.name.contains("Square"):
			
			#Set values in rotating square
			var location_name = square.location_name
			square_visualization.get_node('Photo').get_surface_override_material(0).albedo_texture = load(DIR_IMAGES + location_name + IMG_EXTENSION)
			title.text = location_name
			description.text = square.description
			number.mesh.text = square.number
			
			#Show nodes
			back_panel.show()
			infos_square.show()
			square_visualization.show()
			
			#I Communicate to the visualManager my new camera and block updates of cameras
			VisualManager.set_block_access(true)
			VisualManager.set_camera(visualization_camera)
	
	#We enter here if we click somewhere else
	else:
		square_visualization.hide()
		infos_square.hide()
		back_panel.hide()
		
		#I let again the VisualManager control the cameras
		VisualManager.set_block_access(false)
		VisualManager.set_memory_camera()

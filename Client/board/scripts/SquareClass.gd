extends Node3D

@onready var infos : MeshInstance3D = $StaticBody3D/Infos
@onready var square_title : MeshInstance3D = $StaticBody3D/Infos/Title

const DIR_IMAGES = "res://resources/images/"
const PNG_EXTENSION = ".png"
const JPG_EXTENSION = ".jpg"
const FONT = "res://resources/fonts/Roboto-Black.ttf"

var location_name : String
var number : String
var description : String

func initialize(idx : int, square_infos : Dictionary):
	
	position = square_infos['space_position']
	location_name = square_infos['name']
	
	var material = StandardMaterial3D.new()
	square_title.mesh.text = location_name
	
	if 	square_infos['name'] == "Inizio" or square_infos['name'] == "Fine":
		material.albedo_color = square_infos['color']
		$StaticBody3D/Base.material_override = material
		$StaticBody3D/Photo.queue_free()
		$StaticBody3D/Circle.queue_free()
		for c in $StaticBody3D/Corners.get_children():
			c.queue_free()
	else:
		#number = square_infos['number']
		#description = square_infos['description']
		
		if ResourceLoader.exists(DIR_IMAGES + location_name + PNG_EXTENSION):
			material.albedo_texture = load(DIR_IMAGES + location_name + PNG_EXTENSION)
		else:
			material.albedo_texture = load(DIR_IMAGES + location_name + JPG_EXTENSION)
		$StaticBody3D/Photo.material_override = material
		var textmesh = TextMesh.new()
		textmesh.font = load(FONT)
		textmesh.font_size = 16
		textmesh.text = str(idx)
		var number_material = StandardMaterial3D.new()
		number_material.albedo_color = Color.LIGHT_GRAY
		textmesh.material = number_material
		$StaticBody3D/Circle/Number.mesh = textmesh
		$StaticBody3D/Infos/Title.mesh.text = location_name


func change_color(color : Color) -> void:
	$StaticBody3D/Base.get_surface_override_material(0).albedo_color = color


func get_location_name() -> String:
	return location_name


func _on_static_body_3d_mouse_entered():
	infos.show()


func _on_static_body_3d_mouse_exited():
	infos.hide()

extends Node3D
class_name CardPlacer

@onready var placer_hint: MeshInstance3D = $PlacerHint
var md_table : MDTable
var available : bool = true : 
	set(value):
		available = value
var tween : Tween

func _ready() -> void:
	GameState.cameraRig.target_table_changed.connect(update_placer_color)
	md_table = get_parent().get_parent()
	update_placer_color()

# If its not *MY* table, placer becomes red
func update_placer_color():
	var mat = placer_hint.get_surface_override_material(0) as ShaderMaterial
	mat.set_shader_parameter("color", Color.RED if md_table != GameState.cameraRig.target_table else Color.GREEN)

func _on_area_3d_mouse_entered() -> void:
	if not available: return
	if GameState.cameraRig.selected_object != null and GameState.cameraRig.placing_mode == false: return
	
	if is_instance_valid(tween) and tween.is_running():
		tween.stop()
	
	tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var mat = placer_hint.get_surface_override_material(0) as ShaderMaterial
	tween.tween_property(mat, "shader_parameter/cutoff", 0.0, 0.15)

func _on_area_3d_mouse_exited() -> void:
	if is_instance_valid(tween) and tween.is_running():
		tween.stop()
		
	tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	var mat = placer_hint.get_surface_override_material(0) as ShaderMaterial
	tween.tween_property(mat, "shader_parameter/cutoff", 1.0, 0.5)
